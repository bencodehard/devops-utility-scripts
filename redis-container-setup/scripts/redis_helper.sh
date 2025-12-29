#!/usr/bin/env bash
set -euo pipefail

# scripts/redis.sh

# หา project root (โฟลเดอร์ที่มี docker-compose.yml)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${PROJECT_ROOT}"

# เลือกใช้ docker compose หรือ docker-compose
if command -v docker &>/dev/null && docker compose version &>/dev/null; then
  DC="docker compose"
elif command -v docker-compose &>/dev/null; then
  DC="docker-compose"
else
  echo "❌ docker compose / docker-compose ไม่พร้อมใช้งาน"
  exit 1
fi

DATA_DIR="${PROJECT_ROOT}/data"

usage() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  start     Build และ start redis stack (ในโหมด background)
  stop      Stop container ทั้งหมดใน stack
  restart   Restart service redis
  status    แสดงสถานะ container ใน stack
  logs      ดู logs ของ redis (กด Ctrl+C เพื่อออก)
  clean     Down stack + ลบ volume + ลบ data directory (ใช้อย่างระวัง)

Examples:
  $(basename "$0") start
  $(basename "$0") restart
  $(basename "$0") clean
EOF
}

start() {
  mkdir -p "${DATA_DIR}"
  echo "▶ Starting Redis stack..."
  ${DC} up -d --build
  echo "✔ Redis is starting. Check status with: $(basename "$0") status"
}

stop() {
  echo "⏹ Stopping Redis stack..."
  ${DC} stop
  echo "✔ Stopped."
}

restart() {
  echo "🔄 Restarting Redis service..."
  ${DC} restart redis
  echo "✔ Restarted."
}

status() {
  echo "📊 Container status:"
  ${DC} ps
}

logs() {
  echo "📜 Tail logs from redis (Ctrl+C to exit)..."
  ${DC} logs -f redis
}

clean() {
  echo "⚠ WARNING: This will remove containers, volumes, and local data directory."
  read -rp "Type 'yes' to continue: " confirm
  if [[ "${confirm:-}" != "yes" ]]; then
    echo "Cancelled."
    exit 1
  fi

  echo "🧹 Stopping and removing containers + volumes..."
  ${DC} down -v

  if [[ -d "${DATA_DIR}" ]]; then
    echo "🗑 Removing data directory: ${DATA_DIR}"
    rm -rf "${DATA_DIR}"
  fi

  echo "✔ Clean completed."
}

COMMAND="${1:-}"

case "${COMMAND}" in
  start)   start ;;
  stop)    stop ;;
  restart) restart ;;
  status)  status ;;
  logs)    logs ;;
  clean)   clean ;;
  ""|help|-h|--help)
    usage
    ;;
  *)
    echo "Unknown command: ${COMMAND}"
    usage
    exit 1
    ;;
esac