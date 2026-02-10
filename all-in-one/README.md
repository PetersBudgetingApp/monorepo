# Budgeting App — All-in-One Docker Image

Everything you need in a single `docker run` command. No Docker Compose required!

## Quick Start

### 0. Pull it (if you published it to a registry)

If you (or a friend) pushed this image to Docker Hub / GHCR, you can run it directly:

```bash
docker run -d \
  -p 3000:80 \
  -v budget-data:/var/lib/postgresql/data \
  -v budget-secrets:/var/lib/budget-secrets \
  --name budget \
  <your-registry-namespace>/budgeting-app:latest
```

### 1. Build the image (one-time)

From the project root directory:

```bash
docker build -t budgeting-app -f all-in-one/Dockerfile .
```

### 2. Run it

```bash
docker run -d \
  -p 3000:80 \
  -v budget-data:/var/lib/postgresql/data \
  -v budget-secrets:/var/lib/budget-secrets \
  --name budget \
  budgeting-app
```

Then open **http://localhost:3000** in your browser.

### 3. Stop / restart

```bash
docker stop budget
docker start budget      # data is preserved in volumes
```

### 4. Remove everything

```bash
docker rm -f budget
docker volume rm budget-data budget-secrets   # deletes all data
```

## If you received a pre-built image file

If someone sent you a `.tar` file instead of the source code:

```bash
docker load -i budgeting-app.tar
docker run -d -p 3000:80 \
  -v budget-data:/var/lib/postgresql/data \
  -v budget-secrets:/var/lib/budget-secrets \
  --name budget \
  budgeting-app
```

## Configuration (optional)

You can customize behavior with environment variables:

| Variable            | Default   | Description                        |
|---------------------|-----------|------------------------------------|
| `POSTGRES_DB`       | `budget`  | Database name                      |
| `POSTGRES_USER`     | `budget`  | Database username                  |
| `POSTGRES_PASSWORD` | `budget`  | Database password                  |
| `JWT_SECRET`        | (auto)    | Secret for signing auth tokens     |

Example with custom settings:

```bash
docker run -d -p 3000:80 \
  -e JWT_SECRET="my-super-secret-key-at-least-32-bytes-long" \
  -v budget-data:/var/lib/postgresql/data \
  -v budget-secrets:/var/lib/budget-secrets \
  --name budget \
  budgeting-app
```

## Exporting the image to share

After building, you can export the image to a file and send it to friends:

```bash
docker save budgeting-app -o budgeting-app.tar
```

They can then load it with `docker load -i budgeting-app.tar` (see above).

## Publishing to a registry (so friends can `docker run ...`)

### Docker Hub

```bash
docker login
docker tag budgeting-app <your-dockerhub-username>/budgeting-app:latest
docker push <your-dockerhub-username>/budgeting-app:latest
```

### Multi-arch (recommended if friends might be on Intel + Apple Silicon)

```bash
docker buildx create --name multiarch --use
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t <your-dockerhub-username>/budgeting-app:latest \
  -f all-in-one/Dockerfile \
  --push \
  .
```
