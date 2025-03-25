#!/bin/bash

# 계정 정의: 이름, 이메일, 키 이름, 호스트 이름
ACCOUNTS=(
    "cruiser cruiser594@gmail.com id_ed25519_github_cuiser github.com"
)

mkdir -p ~/.ssh

for entry in "${ACCOUNTS[@]}"; do
  set -- $entry
  nickname=$1
  email=$2
  keyname=$3
  hostname=$4

  keypath="$HOME/.ssh/$keyname"

  if [[ -f "$keypath" ]]; then
    echo "[SKIP] Key already exists: $keypath"
  else
    echo "[CREATE] Generating key for $nickname ($email)..."
    ssh-keygen -t ed25519 -C "$email" -f "$keypath" -N ""
  fi
done


