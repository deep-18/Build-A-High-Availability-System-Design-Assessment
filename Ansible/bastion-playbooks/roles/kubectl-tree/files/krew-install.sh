#!/bin/bash
set -x;
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" &&
tar zxvf krew.tar.gz &&
KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
"$KREW" install --manifest=krew.yaml --archive=krew.tar.gz &&
"$KREW" update
cat << FOE >> ~/.bashrc

# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
FOE