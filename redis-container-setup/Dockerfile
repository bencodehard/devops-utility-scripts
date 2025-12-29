# Dockerfile
FROM redis:7-alpine

# ตำแหน่ง config ตาม convention ของ redis image
COPY config/redis.conf /usr/local/etc/redis/redis.conf
COPY config/users.acl  /usr/local/etc/redis/users.acl

# ค่า default: ใช้ redis.conf ในการ start
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]