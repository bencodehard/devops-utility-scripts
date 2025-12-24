# 🛠️ DevOps Utility Scripts & Automation Tools

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/yourusername/devops-utility-scripts/graphs/commit-activity)
[![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/Language-Python-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📖 About
Welcome to my personal collection of **automation scripts** and **operational tools**. 
As a DevOps Engineer, I believe in the philosophy of *"Automate everything that needs to be done more than twice."*

This repository contains a small collection of DevOps helper scripts. The main tool currently available is a **PostgreSQL TLS certificate generator** located in the `create_self_signed_cert/` directory — a Bash script that creates an internal CA and server certificates with SAN (DNS/IP) support for PostgreSQL (intended for local/dev environments).

---

## 📂 Script Catalog

### TLS Certificate Generator
| Script Name | Language | Description |
| :--- | :--- | :--- |
| `create_self_signed_cert/create_self_sign_cert.sh` | Bash | Generates an internal CA and server cert/key (supports SAN DNS/IP) for PostgreSQL. |
| `create_self_signed_cert/start_create.sh` | Bash | Example wrapper that sets sensible defaults and runs the generator. |

### Setup psql tls ssl connections
| Directory | Language | Description |
| :--- | :--- | :--- |
| `psql-container-ssl-connection-setup/` | Docker Compose / Bash | Example Compose + Dockerfile to run PostgreSQL with TLS (includes `.env.example`, example certs, and helper scripts). |

> See [create_self_signed_cert/README.md](create_self_signed_cert/README.md) for the certificate generator usage; see [psql-container-ssl-connection-setup/README.md](psql-container-ssl-connection-setup/README.md) for the Compose setup and SSL connection tests.

---


---

## Notes

### 1. Generating a Self-Signed Certificate
Stop struggling with `openssl` commands. This script generates a valid self-signed cert for `localhost` or any domain in seconds.

**Usage:**
See [create_self_signed_cert/README.md](create_self_signed_cert/README.md) for the actual usage example; see [psql-container-ssl-connection-setup/README.md](psql-container-ssl-connection-setup/README.md) for an example Compose setup and SSL connection tests.