#!/bin/bash
set -eu

# ─── Defaults ─────────────────────────────────────────────────────────────────
export POSTGRES_DB="${POSTGRES_DB:-budget}"
export POSTGRES_USER="${POSTGRES_USER:-budget}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-budget}"
export JWT_SECRET="${JWT_SECRET:-aio-dev-jwt-secret-please-change-this-32-plus-bytes}"

SECRET_DIR="${SECRET_DIR:-/var/lib/budget-secrets}"
SECRET_FILE="${SECRET_FILE:-$SECRET_DIR/encryption_secret}"

# ─── Resolve backend JAR path (used by supervisord) ──────────────────────────
export BACKEND_JAR
BACKEND_JAR="$(find /app/target -maxdepth 1 -name '*.jar' ! -name '*original*' | head -n 1)"

# ─── Generate / load encryption secret ───────────────────────────────────────
mkdir -p "$SECRET_DIR"
chmod 700 "$SECRET_DIR"

if [ -s "$SECRET_FILE" ]; then
  ENCRYPTION_SECRET="$(cat "$SECRET_FILE")"
elif [ -n "${ENCRYPTION_SECRET:-}" ]; then
  printf '%s' "$ENCRYPTION_SECRET" > "$SECRET_FILE"
  chmod 600 "$SECRET_FILE"
else
  ENCRYPTION_SECRET="$(head -c 48 /dev/urandom | base64 | tr -d '\n')"
  printf '%s' "$ENCRYPTION_SECRET" > "$SECRET_FILE"
  chmod 600 "$SECRET_FILE"
fi
export ENCRYPTION_SECRET

# ─── Initialize PostgreSQL if data directory is empty ─────────────────────────
if [ ! -s "$PGDATA/PG_VERSION" ]; then
  echo "==> Initializing PostgreSQL data directory..."
  chown -R postgres:postgres "$PGDATA"
  su - postgres -c "/usr/lib/postgresql/16/bin/initdb -D $PGDATA"

  # Allow local connections with password
  echo "host all all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
  echo "local all all trust" >> "$PGDATA/pg_hba.conf"

  # Listen only on localhost (all traffic is internal)
  sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/" "$PGDATA/postgresql.conf"

  # Start postgres temporarily to create user and database
  su - postgres -c "/usr/lib/postgresql/16/bin/pg_ctl -D $PGDATA -w start"

  su - postgres -c "psql -c \"CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';\"" 2>/dev/null || true
  su - postgres -c "psql -c \"CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;\"" 2>/dev/null || true
  su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;\"" 2>/dev/null || true

  su - postgres -c "/usr/lib/postgresql/16/bin/pg_ctl -D $PGDATA -w stop"
  echo "==> PostgreSQL initialized."
else
  echo "==> PostgreSQL data directory already exists, skipping init."
  chown -R postgres:postgres "$PGDATA"
fi

# ─── Remove default nginx site if it exists ──────────────────────────────────
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# ─── Launch everything via supervisord ────────────────────────────────────────
echo "==> Starting all services..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
