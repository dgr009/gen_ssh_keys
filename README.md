# 🔐 SSH 키 자동 생성 및 등록 스크립트

이 스크립트는 JSON 파일로 정의된 계정 목록을 바탕으로 SSH 키를 자동 생성하고, 필요시 원격 호스트에 공개키를 등록할 수 있습니다.

---

## 📁 파일 구조

```
.
├── setup_ssh.sh
└── account.json
```

---

## 📄 account.json 예시

```json
[
  {
    "nickname": "cruiser594",
    "email": "cruiser594@gmail.com",
    "keyname": "id_ed25519_github_cruiser",
    "hostname": "github.com"
  }
]
```

| 필드명   | 설명 |
|----------|------|
| nickname | 계정 별칭 (단순 식별용) |
| email    | 키 생성 시 주석으로 들어갈 이메일 주소 |
| keyname  | 키 파일 이름 (`~/.ssh` 내부 파일명) |
| hostname | 공개키를 복사할 대상 호스트 주소 또는 도메인 |

---

## 🛠 사용법

```bash
bash setup_ssh.sh [옵션]
```

### 🔧 지원 옵션

| 옵션         | 설명 |
|--------------|------|
| `--check`    | 키가 존재하는지 확인만 수행합니다. |
| `--copy`     | 키가 존재할 경우 `ssh-copy-id`로 공개키를 원격 서버에 등록합니다. |
| `--verbose`  | 처리 중인 계정 정보를 상세히 출력합니다. |
| `--list`     | 현재 `~/.ssh`에 있는 키 목록을 출력합니다. |

---

## 📌 요구 사항

- `bash`
- [`jq`](https://stedolan.github.io/jq/) (JSON 파싱을 위해 필요)

설치 예시 (Ubuntu):
```bash
sudo apt install jq
```

---

## 🔐 예시 실행

```bash
bash setup_ssh.sh --check --verbose
bash setup_ssh.sh --copy
bash setup_ssh.sh --list
```

---

## 📬 출력 예시

```bash
[INFO ] 현재 등록된 키 목록:
  - id_ed25519_github_cruiser
[INFO ] 처리 중: cruiser594 | cruiser594@gmail.com | id_ed25519_github_cruiser | github.com
[INFO ] 이미 존재함: id_ed25519_github_cruiser
```

---

## 📃 라이선스

MIT License