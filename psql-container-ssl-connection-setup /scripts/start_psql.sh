#!/usr/bin/env bash
set -euo pipefail

echo "▶ Starting PostgreSQL TLS container..."

# Load .env
if [[ ! -f ".env" ]]; then
  echo "❌ .env file not found"
  echo "👉 Please create .env from .env.example"
  exit 1
fi

set -a
source .env
set +a

# Validate required vars
REQUIRED_VARS=(POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB PG_PORT CERTS_DIR)
for VAR in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!VAR:-}" ]]; then
    echo "❌ Missing required env var: $VAR"
    exit 1
  fi
done

# Validate cert files
CERT_PATH="${CERTS_DIR}"
if [[ ! -d "$CERT_PATH" ]]; then
  echo "❌ CERTS_DIR not found: $CERT_PATH"
  exit 1
fi

for f in server.crt server.key ca.crt; do
  if [[ ! -f "$CERT_PATH/$f" ]]; then
    echo "❌ Missing cert file: $CERT_PATH/$f"
    exit 1
  fi
done

echo "🔐 Setting permission 600 on server.key"
chmod 600 "$CERT_PATH/server.key"

echo "✔ Environment summary:"
echo "  POSTGRES_USER = $POSTGRES_USER"
echo "  POSTGRES_DB   = $POSTGRES_DB"
echo "  PG_PORT       = $PG_PORT"
echo "  CERTS_DIR     = $CERTS_DIR"

echo "🐳 Building image..."
docker compose build

echo "🚀 Starting containers..."
docker compose up -d

# Get container id for service "db"
CID="$(docker compose ps -q db | head -n 1)"
if [[ -z "${CID}" ]]; then
  echo "❌ Could not find container for service 'db' (docker compose ps -q db returned empty)"
  exit 1
fi

echo "⏳ Waiting for PostgreSQL to be ready..."
READY=0
for i in {1..30}; do
  if docker exec "$CID" pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1; then
    READY=1
    echo "✅ PostgreSQL is ready"
    break
  fi
  sleep 2
done

if [[ "$READY" -ne 1 ]]; then
  echo "❌ PostgreSQL not ready in time. Last logs:"
  docker logs "$CID" --tail 120
  exit 1
fi

# =========================
# Ensure database exists (idempotent)
# =========================
if [[ -f "./scripts/create_db_if_not_exists.sh" ]]; then
  echo "🗄️  Ensuring database exists..."
  chmod +x ./scripts/create_db_if_not_exists.sh || true
  ./scripts/create_db_if_not_exists.sh
else
  echo "⚠️  scripts/create_db_if_not_exists.sh not found, skipping database creation step"
fi

echo "🎉 Done!"
echo "👉 Test TLS from macOS:"
echo "psql \"host=localhost port=$PG_PORT dbname=$POSTGRES_DB user=$POSTGRES_USER sslmode=verify-full sslrootcert=$CERTS_DIR/ca.crt\""