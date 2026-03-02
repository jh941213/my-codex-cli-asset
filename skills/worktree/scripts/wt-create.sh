#!/usr/bin/env bash
set -euo pipefail

# wt-create.sh — 새 git worktree 생성
# 사용법: wt-create.sh <name> [base-branch]

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[worktree]${NC} $1"; }
ok()    { echo -e "${GREEN}[worktree]${NC} $1"; }
error() { echo -e "${RED}[worktree]${NC} $1"; exit 1; }

NAME="${1:-}"
BASE="${2:-HEAD}"

if [ -z "$NAME" ]; then
  error "사용법: wt-create.sh <name> [base-branch]"
fi

# git 저장소 확인
git rev-parse --git-dir &>/dev/null || error "git 저장소가 아닙니다."

# 메인 레포 루트 찾기
GIT_COMMON_DIR="$(git rev-parse --git-common-dir)"
if [ "$GIT_COMMON_DIR" = ".git" ]; then
  REPO_ROOT="$(pwd)"
else
  REPO_ROOT="$(cd "$GIT_COMMON_DIR/../.." 2>/dev/null && pwd || cd "$GIT_COMMON_DIR/.." && pwd)"
fi

WT_DIR="$REPO_ROOT/.worktrees"
ACTIVE_DIR="$WT_DIR/active"

[ -d "$WT_DIR" ] || error ".worktrees가 없습니다. 먼저 wt-init.sh를 실행하세요."
mkdir -p "$ACTIVE_DIR"

WT_PATH="$ACTIVE_DIR/$NAME"

if [ -d "$WT_PATH" ]; then
  error "이미 존재하는 worktree: $NAME"
fi

# worktree 생성
info "워크트리 생성 중: $NAME (base: $BASE)"
git worktree add "$WT_PATH" -b "$NAME" "$BASE" 2>/dev/null || \
  git worktree add "$WT_PATH" "$NAME" 2>/dev/null || \
  error "워크트리 생성 실패. 브랜치 '$NAME'이 이미 존재할 수 있습니다."

# INFO.md 메타데이터 생성
cat > "$WT_PATH/INFO.md" <<EOF
# Worktree: $NAME

| Key | Value |
|-----|-------|
| Created | $(date -u '+%Y-%m-%dT%H:%M:%SZ') |
| Base | \`$BASE\` |
| Branch | \`$NAME\` |
| Path | \`$WT_PATH\` |
EOF

ok "워크트리 생성 완료: $NAME"
echo ""
echo "  경로: $WT_PATH"
echo "  브랜치: $NAME"
echo ""
echo "이동하려면:"
echo "  cd $WT_PATH"
