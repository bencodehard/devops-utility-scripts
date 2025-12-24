# 🛠️ DevOps Utility Scripts & Automation Tools

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/yourusername/devops-utility-scripts/graphs/commit-activity)
[![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/Language-Python-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📖 About
Welcome to my personal collection of **automation scripts** and **operational tools**. 
As a DevOps Engineer, I believe in the philosophy of *"Automate everything that needs to be done more than twice."*

This repository contains scripts I use for:
* 🔐 **Security:** SSL/TLS Certificate management
* 🐳 **Container:** Docker & Kubernetes maintenance
* ☁️ **Cloud:** AWS Resource management & Cleanup
* 🐧 **System:** Linux administration & Monitoring

---

## 📂 Script Catalog

Here is a list of available tools categorized by function:

### 🔐 Security & Certificates
| Script Name | Language | Description |
| :--- | :--- | :--- |
| `ssl/gen-self-signed.sh` | Bash | Generates a self-signed SSL certificate with SAN (Subject Alternative Name) support for local development. |
| `ssl/check-expiry.sh` | Bash | Checks SSL certificate expiration date of a remote domain and alerts if expiring soon. |

### 🐳 Docker & Kubernetes
| Script Name | Language | Description |
| :--- | :--- | :--- |
| `docker/prune-all.sh` | Bash | Safely cleans up unused Docker images, containers, and networks to free up disk space. |
| `k8s/context-switcher.sh` | Bash | A simple utility to switch between K8s contexts and namespaces quickly. |

### ☁️ Cloud & Backup
| Script Name | Language | Description |
| :--- | :--- | :--- |
| `aws/s3-upload.py` | Python | Uploads backups to AWS S3 with automatic versioning and slack notification support. |
| `db/backup-postgres.sh` | Bash | Dumps PostgreSQL database, compresses it, and rotates old backups (keeps last 7 days). |

---

## 🚀 Usage Examples

### 1. Generating a Self-Signed Certificate
Stop struggling with `openssl` commands. This script generates a valid self-signed cert for `localhost` or any domain in seconds.

**Usage:**
```bash
# chmod +x ssl/gen-self-signed.sh
./ssl/gen-self-signed.sh --domain myapp.local --days 365