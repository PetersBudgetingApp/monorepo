# =============================================================================
# All-in-One Budgeting App Image
# Packages frontend (Nginx) + backend (Spring Boot) + PostgreSQL into a single
# container managed by supervisord.
#
# Build:  docker build -t budgeting-app ./all-in-one  (from workspace root)
# Run:    docker run -d -p 3000:80 --name budget budgeting-app
# Access: http://localhost:3000
# =============================================================================

# ── Stage 1: Build the frontend ──────────────────────────────────────────────
FROM node:20-alpine AS frontend-build
WORKDIR /app

COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci

COPY frontend/ .

ARG VITE_API_BASE_URL=/api/v1
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
RUN npm run build

# ── Stage 2: Build the backend ───────────────────────────────────────────────
FROM maven:3.9.9-eclipse-temurin-21 AS backend-build
WORKDIR /app

COPY backend/pom.xml ./
RUN mvn -q -DskipTests dependency:go-offline

COPY backend/src ./src
RUN mvn -q -DskipTests package

# ── Stage 3: JRE 21 layer (same base the backend uses standalone) ────────────
FROM eclipse-temurin:21-jre-jammy AS jre-source

# ── Stage 4: Final all-in-one runtime ────────────────────────────────────────
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Add PostgreSQL 16 official APT repo (not in bookworm base)
RUN apt-get update && apt-get install -y --no-install-recommends \
        gnupg2 curl ca-certificates \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
       | gpg --dearmor -o /usr/share/keyrings/pgdg.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/pgdg.gpg] https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" \
       > /etc/apt/sources.list.d/pgdg.list \
    && rm -rf /var/lib/apt/lists/*

# Install PostgreSQL 16, Nginx, and supervisord
RUN apt-get update && apt-get install -y --no-install-recommends \
        postgresql-16 \
        nginx \
        supervisor \
    && rm -rf /var/lib/apt/lists/*

# Copy JRE 21 from temurin stage (matches the JDK 21 used to compile the backend)
COPY --from=jre-source /opt/java/openjdk /opt/java/openjdk
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# ── PostgreSQL configuration ─────────────────────────────────────────────────
ENV PGDATA=/var/lib/postgresql/data
ENV POSTGRES_DB=budget
ENV POSTGRES_USER=budget
ENV POSTGRES_PASSWORD=budget

# ── Backend artifacts ─────────────────────────────────────────────────────────
WORKDIR /app
COPY --from=backend-build /app/target /app/target

# ── Frontend artifacts ────────────────────────────────────────────────────────
COPY --from=frontend-build /app/dist /usr/share/nginx/html

# ── Nginx config (proxy /api to localhost:8080) ──────────────────────────────
COPY all-in-one/nginx-aio.conf /etc/nginx/sites-available/default

# ── Supervisord config ───────────────────────────────────────────────────────
COPY all-in-one/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ── Startup script ───────────────────────────────────────────────────────────
COPY all-in-one/startup.sh /app/startup.sh
RUN chmod +x /app/startup.sh

EXPOSE 80

VOLUME ["/var/lib/postgresql/data", "/var/lib/budget-secrets"]

ENTRYPOINT ["/app/startup.sh"]
