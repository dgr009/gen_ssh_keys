#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# 컬러 로그 함수
log() {
  local level="$1"
  shift
  case "$level" in
    INFO)  echo -e "\033[1;34m[INFO ]\033[0m $*" ;;
    WARN)  echo -e "\033[1;33m[WARN ]\033[0m $*" ;;
    ERROR) echo -e "\033[1;31m[ERROR]\033[0m $*" ;;
    *)     echo -e "\033[1;32m[LOG  ]\033[0m $*" ;;
  esac
}

check_only=false
copy_key=false
verbose=false
list_keys=false
ACCOUNT_FILE="account.json"

# 옵션 파싱
while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) check_only=true ;;
    --copy) copy_key=true ;;
    --verbose) verbose=true ;;
    --list) list_keys=true ;;
    *) log WARN "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

SSH_DIR="$HOME/.ssh"
mkdir -p "$SSH_DIR"

if $list_keys; then
  log INFO "현재 등록된 키 목록:"
  find "$SSH_DIR" -type f -name "id_*" ! -name "*.pub" | while read -r key; do
    echo "  - $(basename "$key")"
  done
  exit 0
fi

# jq 확인
if ! command -v jq &> /dev/null; then
  log ERROR "jq 명령어가 필요합니다. 설치 후 다시 시도해주세요."
  exit 1
fi

# 계정 파일 확인
if [[ ! -f "$ACCOUNT_FILE" ]]; then
  log ERROR "계정 파일이 존재하지 않습니다: $ACCOUNT_FILE"
  exit 1
fi

# 키 처리 함수
process_account() {
  local nickname="$1"
  local email="$2"
  local keyname="$3"
  local hostname="$4"
  local keypath="$SSH_DIR/$keyname"

  if [[ -f "$keypath" ]]; then
    log INFO "이미 존재함: $keyname"
    if $copy_key; then
      log INFO "$hostname 에 공개키 복사 시도 중..."
      ssh-copy-id -i "$keypath.pub" "$USER@$hostname"
    fi
  else
    if $check_only; then
      log INFO "[CHECK] 없음: $keyname"
    else
      log INFO "[CREATE] 키 생성 중: $keyname ($email)"
      ssh-keygen -t ed25519 -C "$email" -f "$keypath" -N ""
    fi
  fi
}

# 계정 반복
count=$(jq length "$ACCOUNT_FILE")
for ((i=0; i < count; i++)); do
  nickname=$(jq -r ".[$i].nickname" "$ACCOUNT_FILE")
  email=$(jq -r ".[$i].email" "$ACCOUNT_FILE")
  keyname=$(jq -r ".[$i].keyname" "$ACCOUNT_FILE")
  hostname=$(jq -r ".[$i].hostname" "$ACCOUNT_FILE")

  if $verbose; then
    log INFO "처리 중: $nickname | $email | $keyname | $hostname"
  fi

  process_account "$nickname" "$email" "$keyname" "$hostname"
done