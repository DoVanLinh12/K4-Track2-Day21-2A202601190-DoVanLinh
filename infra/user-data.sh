#!/bin/bash
set -euxo pipefail

apt-get update
apt-get install -y python3-pip curl
python3 -m pip install fastapi uvicorn scikit-learn joblib boto3

install -d -o ubuntu -g ubuntu /home/ubuntu/models
install -d -o ubuntu -g ubuntu /home/ubuntu/src
