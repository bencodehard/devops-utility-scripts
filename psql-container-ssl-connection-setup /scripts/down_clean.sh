#!/usr/bin/env bash
set -euo pipefail

echo "🧨 Stopping PostgreSQL containers and removing ALL data..."

# ตรวจว่ามี docker-compose.yml
if [[ ! -f "docker-compose.yml" ]]; then
  echo "❌ docker-compose.yml not found"
  exit 1
fi

echo "🛑 docker compose down -v (remove volumes)"
docker compose down -v --remove-orphans

echo "🧹 Cleaning dangling images (optional)"
docker image prune -f >/dev/null 2>&1 || true

echo "✅ All containers, volumes, and related resources have been removed"
echo "⚠️  PostgreSQL data is permanently deleted"