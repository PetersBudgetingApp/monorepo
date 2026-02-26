# Velum

This repo contains:

- `backend`: Spring Boot API
- `frontend`: React app
- `postgres`: local persistent database (Docker volume)

[Privacy Policy](https://github.com/VelumApp/velum/blob/main/privacy-policy.md)

## Quick Start

If you just want to run Velum (no source code, no building), use the published image: `petergelgor/velum:latest`.

### Option 1: `docker run`

```bash
docker run -d \
  -p 3000:80 \
  -v velum-data:/var/lib/postgresql/data \
  -v velum-secrets:/var/lib/budget-secrets \
  --name velum \
  petergelgor/velum:latest
```

Open [http://localhost:3000](http://localhost:3000).

### Option 2: `docker compose`

Create a `docker-compose.yml`:

```yaml
services:
  velum:
    image: petergelgor/velum:latest
    container_name: velum
    restart: unless-stopped
    ports:
      - "3000:80"
    volumes:
      - velum_data:/var/lib/postgresql/data
      - velum_secrets:/var/lib/budget-secrets

volumes:
  velum_data:
  velum_secrets:
```

Then:

```bash
docker compose up -d
```

## Development: Docker Compose (from source)

1. Copy the env template:

```bash
cp .env.example .env
```

2. Optionally update `JWT_SECRET` in `.env`.
   `ENCRYPTION_SECRET` is now auto-generated on first backend start and persisted in a Docker volume.

3. If you access the app remotely (DDNS/Tailscale), set `APP_CORS_ALLOWED_ORIGINS` in the same root `.env`.
   Example:

```env
APP_CORS_ALLOWED_ORIGINS=http://localhost:3000,http://server.domain.net:3000,http://100.104.225.32:3000
```

4. Start everything:

```bash
docker compose up --build -d
```

Open:

- App: [http://localhost:3000](http://localhost:3000)
- API (via frontend proxy): [http://localhost:3000/api/v1](http://localhost:3000/api/v1)

## Networking Notes

- In Docker Compose, the backend is exposed on `${BACKEND_PORT:-8080}` for convenience, but the browser UI still talks to it via the frontend proxy (`/api/*`).
- In the all-in-one image, the backend is internal-only and is reached via Nginx proxying to `localhost:8080` inside the container.


## Demo / example user

A pre-populated demo account is created automatically on first startup via Flyway migration. It contains 12 months of realistic financial data (March 2025 – February 2026) so testers can explore all app features immediately.

| | |
|---|---|
| **Email** | `example.user@test.com` |
| **Password** | `example-user-password1` |

What's included:

- **6 accounts** – checking, savings, credit card, auto loan, brokerage, vacation fund (covers all account types and net-worth categories)
- **~420 transactions** – salary, rent, groceries, gas, streaming, restaurants, Amazon, travel, transfers, and more
- **3 custom categories** – Side Hustle, Loan Payments, Date Night
- **8 custom categorization rules** – Trader Joe's, Olive Garden, Petco, State Farm, Blue Cross, Oakwood Rent, Capital One Auto, City Electric
- **6 months of budget targets** – across groceries, restaurants, coffee, gas, clothing, streaming, and more
- **13 recurring patterns** – salary, rent, Netflix, Spotify, Disney+, Verizon, Comcast, Planet Fitness, iCloud, health/car insurance, car loan
- **24 linked transfer pairs** – checking → savings and checking → credit card payments

Every self-hosted user can log in with these credentials to see a fully populated dashboard, transaction history, budget insights, and recurring bills.