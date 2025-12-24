#!/usr/bin/env bash
set -euo pipefail

echo "▶ Ensure PostgreSQL database exists (TLS)"

# =========================
# Load .env
# =========================
if [[ ! -f ".env" ]]; then
  echo "❌ .env file not found"
  exit 1
fi

set -a
source .env
set +a

# =========================
# Validate required vars
# =========================
REQUIRED_VARS=(
  POSTGRES_USER
  POSTGRES_PASSWORD
  POSTGRES_DB
  PG_PORT
  CERTS_DIR
)

for VAR in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!VAR:-}" ]]; then
    echo "❌ Missing required env var: $VAR"
    exit 1
  fi
done

# =========================
# Validate cert files
# =========================
for f in ca.crt; do
  if [[ ! -f "$CERTS_DIR/$f" ]]; then
    echo "❌ Missing $CERTS_DIR/$f"
    exit 1
  fi
done

# =========================
# Export password for psql
# =========================
export PGPASSWORD="$POSTGRES_PASSWORD"

# =========================
# Check if database exists
# =========================
echo "🔎 Checking database: $POSTGRES_DB"

DB_EXISTS=$(psql \
  "host=localhost port=$PG_PORT dbname=postgres user=$POSTGRES_USER sslmode=verify-full sslrootcert=$CERTS_DIR/ca.crt" \
  -tAc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB';" || true)

if [[ "$DB_EXISTS" == "1" ]]; then
  echo "✅ Database '$POSTGRES_DB' already exists"
  exit 0
fi

# =========================
# Create database
# =========================
echo "➕ Creating database '$POSTGRES_DB' (owner: $POSTGRES_USER)"

psql \
  "host=localhost port=$PG_PORT dbname=postgres user=$POSTGRES_USER sslmode=verify-full sslrootcert=$CERTS_DIR/ca.crt" \
  -c "CREATE DATABASE \"$POSTGRES_DB\" OWNER \"$POSTGRES_USER\";"

echo "🎉 Database '$POSTGRES_DB' created successfully"