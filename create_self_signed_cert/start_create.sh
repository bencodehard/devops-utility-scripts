#!/usr/bin/env bash

PROJECT_NAME="psql_tlsssl" \
DNS_NAMES="postgres,localhost,db.task-mng.internal,host.docker.internal" \
IP_ADDRESSES="127.0.0.1,10.0.0.10" \
./create_self_sign_cert.sh