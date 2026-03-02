#!/usr/bin/env bash
set -euo pipefail

# My Codex Code Asset Installer
# OpenAI Codex CLI용 스킬 팩 설치 스크립트

REPO_URL="https://github.com/jh941213/my-codex-code-asset.git"
CODEX_DIR="$HOME/.codex"
SKILLS_DIR="$CODEX_DIR/skills"
TMP_DIR=$(mktemp -d)

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo ""
echo "========================================="
echo "  My Codex Code Asset Installer"
echo "  OpenAI Codex CLI Power Pack"
echo "========================================="
echo ""

# 1. 사전 조건 확인
info "사전 조건 확인 중..."

if ! command -v git &>/dev/null; then
  error "git이 설치되어 있지 않습니다."
fi

if ! command -v codex &>/dev/null; then
  warn "Codex CLI가 설치되어 있지 않습니다."
  warn "npm i -g @openai/codex 로 설치하세요."
fi

ok "사전 조건 확인 완료"

# 2. 레포 클론
info "레포지토리 클론 중..."

# 이미 install.sh가 있는 디렉토리에서 실행 중인지 확인
if [ -f "./AGENTS.md" ] && [ -d "./skills" ]; then
  info "로컬 디렉토리에서 설치합니다."
  SOURCE_DIR="."
else
  git clone --depth 1 "$REPO_URL" "$TMP_DIR/repo" 2>/dev/null || error "레포 클론 실패"
  SOURCE_DIR="$TMP_DIR/repo"
fi

ok "소스 준비 완료"

# 3. 디렉토리 생성
info "Codex 디렉토리 생성 중..."
mkdir -p "$CODEX_DIR"
mkdir -p "$SKILLS_DIR"
ok "디렉토리 생성 완료"

# 4. AGENTS.md 설치
info "AGENTS.md 설치 중..."
if [ -f "$CODEX_DIR/AGENTS.md" ]; then
  warn "기존 AGENTS.md가 있습니다. 백업 후 덮어씁니다."
  cp "$CODEX_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md.backup.$(date +%s)"
fi
cp "$SOURCE_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md"
ok "AGENTS.md 설치 완료"

# 5. 스킬 설치
info "스킬 설치 중..."
SKILL_COUNT=0
for skill_dir in "$SOURCE_DIR"/skills/*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$SKILLS_DIR/$skill_name"
  cp -r "$skill_dir"* "$SKILLS_DIR/$skill_name/" 2>/dev/null || true
  SKILL_COUNT=$((SKILL_COUNT + 1))
done
ok "$SKILL_COUNT개 스킬 설치 완료"

# 6. config.toml 설치 (선택)
if [ -f "$SOURCE_DIR/config.toml" ]; then
  if [ -f "$CODEX_DIR/config.toml" ]; then
    warn "기존 config.toml이 있습니다. 덮어쓰지 않습니다."
    warn "수동으로 병합하세요: $SOURCE_DIR/config.toml"
  else
    cp "$SOURCE_DIR/config.toml" "$CODEX_DIR/config.toml"
    ok "config.toml 설치 완료"
  fi
fi

# 7. 설치 결과 출력
echo ""
echo "========================================="
echo -e "  ${GREEN}설치 완료!${NC}"
echo "========================================="
echo ""
echo "설치 위치:"
echo "  AGENTS.md : $CODEX_DIR/AGENTS.md"
echo "  스킬      : $SKILLS_DIR/ ($SKILL_COUNT개)"
echo "  설정      : $CODEX_DIR/config.toml"
echo ""
echo "사용법:"
echo "  codex         # Codex CLI 시작"
echo "  \$plan        # 계획 수립 스킬"
echo "  \$verify      # 검증 스킬"
echo "  \$review      # 코드 리뷰 스킬"
echo ""
