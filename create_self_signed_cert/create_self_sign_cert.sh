#!/usr/bin/env bash
set -euo pipefail

# =========================
# Config (edit as needed)
# =========================
PROJECT_NAME="${PROJECT_NAME:-myproject}"

# Hostname ที่ client จะใช้เรียก Postgres (ต้องตรงกับ CN/SAN สำหรับ verify-full)
# ใส่ได้หลายค่า: "postgres,localhost,db.internal"
DNS_NAMES="${DNS_NAMES:-postgres,localhost}"
IP_ADDRESSES="${IP_ADDRESSES:-127.0.0.1}"

# อายุ cert
CA_DAYS="${CA_DAYS:-3650}"
SERVER_DAYS="${SERVER_DAYS:-825}"

# Output base dir
CERT_BASE_DIR="${CERT_BASE_DIR:-certs}"

# =========================
# Derived
# =========================
TS="$(date +"%Y%m%d-%H%M%S")"
OUT_DIR="${CERT_BASE_DIR}/${PROJECT_NAME}-${TS}"

# Make dir
mkdir -p "${OUT_DIR}"
cd "${OUT_DIR}"

echo "==> Creating certs in: ${OUT_DIR}"

# =========================
# 1) Create CA
# =========================
echo "==> [1/3] Create CA key/cert"
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key \
  -sha256 -days "${CA_DAYS}" \
  -out ca.crt \
  -subj "/CN=${PROJECT_NAME}-Postgres-CA"

# =========================
# 2) Create Server key + CSR
# =========================
echo "==> [2/3] Create Server key + CSR"
openssl genrsa -out server.key 2048
chmod 600 server.key

# CN ใช้ตัวแรกของ DNS_NAMES เป็นหลัก (เหมาะกับ verify-full)
CN="$(echo "${DNS_NAMES}" | awk -F',' '{print $1}')"
openssl req -new -key server.key -out server.csr -subj "/CN=${CN}"

# =========================
# 3) Create SAN ext and sign server cert
# =========================
echo "==> [3/3] Sign Server cert with SAN"

# Build SAN line
SAN_ITEMS=()
IFS=',' read -ra DNS_ARR <<< "${DNS_NAMES}"
for d in "${DNS_ARR[@]}"; do
  d="$(echo "$d" | xargs)"       # trim
  [[ -n "$d" ]] && SAN_ITEMS+=("DNS:${d}")
done

IFS=',' read -ra IP_ARR <<< "${IP_ADDRESSES}"
for ip in "${IP_ARR[@]}"; do
  ip="$(echo "$ip" | xargs)"     # trim
  [[ -n "$ip" ]] && SAN_ITEMS+=("IP:${ip}")
done

SAN_LINE="$(IFS=','; echo "${SAN_ITEMS[*]}")"

cat > server.ext <<EOF
subjectAltName = ${SAN_LINE}
extendedKeyUsage = serverAuth
EOF

openssl x509 -req -in server.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.crt \
  -days "${SERVER_DAYS}" -sha256 \
  -extfile server.ext

# Cleanup
rm -f server.csr server.ext ca.srl

echo
echo "✅ Done. Files created:"
ls -l

echo
echo "ℹ️  Suggested docker-compose mount (read-only):"
echo "   - ./${OUT_DIR}:/var/lib/postgresql/tls:ro"
echo
echo "ℹ️  Client (psql) verify-full example:"
echo "   psql \"host=${CN} port=5432 dbname=appdb user=app sslmode=verify-full sslrootcert=$(pwd)/ca.crt\""