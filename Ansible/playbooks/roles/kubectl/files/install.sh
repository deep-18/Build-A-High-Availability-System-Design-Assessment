#!/bin/bash
pwd
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
ls && \
chmod +x kubectl && \
mv kubectl /usr/local/bin/.