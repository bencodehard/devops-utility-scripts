# PostgreSQL TLS Certificate Generator (Bash Script)

สคริปต์นี้ใช้สำหรับ **สร้าง TLS/SSL certificate สำหรับ PostgreSQL**  
โดยใช้ **Internal CA (Certificate Authority)** ของตัวเอง  
เหมาะสำหรับใช้งานกับ:

- PostgreSQL (Docker / VM)
- docker-compose
- GitHub Actions (ใช้ cert ที่เตรียมไว้ล่วงหน้า)
- Environment: dev / uat / prod

> ❗ สคริปต์นี้ **ไม่ควรถูกรันใน CI/CD workflow**  
> ให้รันแบบ manual แล้วนำ cert ไปใช้งานต่อเท่านั้น

---

## ✨ Features
- สร้าง CA (`ca.crt`)
- สร้าง Server Certificate (`server.crt`, `server.key`)
- รองรับ **SAN (DNS / IP)** สำหรับ `sslmode=verify-full`
- สร้างโฟลเดอร์แบบ `{project-name}-{timestamp}`
- ปลอดภัย (`server.key` permission = `600`)
- ใช้ซ้ำได้ (reproducible)

---

## 📁 Output Structure
เมื่อรันสคริปต์แล้ว จะได้โครงสร้างประมาณนี้:
```sh
certs/
└── myproject-20250101-153000/
    ├── ca.crt
    ├── ca.key   
    ├── server.crt
    └── server.key
```

> ⚠️ **ห้าม commit cert/key จริงขึ้น GitHub**
---

## 🚀 Usage
### 1) เตรียมสคริปต์

```bash
chmod +x ./create_self_sign_cert.sh
chmod +x ./start_creat.sh
```

### 2) รันสคริปต์
```bash
bash ./start_creat.sh
```

```bash
./start_creat.sh
```
