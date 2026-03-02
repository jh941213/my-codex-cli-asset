#!/usr/bin/env bash
set -euo pipefail

# wt-cleanup.sh — 워크트리 제거
# 사용법: wt-cleanup.sh <name> [--force]

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[worktree]${NC} $1"; }
ok()    { echo -e "${GREEN}[worktree]${NC} $1"; }
warn()  { echo -e "${YELLOW}[worktree]${NC} $1"; }
error() { echo -e "${RED}[worktree]${NC} $1"; exit 1; }

NAME="${1:-}"
FORCE="${2:-}"

if [ -z "$NAME" ]; then
  error "사용법: wt-cleanup.sh <name> [--force]"
fi

# 메인 레포 루트 찾기
GIT_COMMON_DIR="$(git rev-parse --git-common-dir 2>/dev/null)" || error "git 저장소가 아닙니다."
if [ "$GIT_COMMON_DIR" = ".git" ]; then
  REPO_ROOT="$(pwd)"
else
  REPO_ROOT="$(cd "$GIT_COMMON_DIR/../.." 2>/dev/null && pwd || cd "$GIT_COMMON_DIR/.." && pwd)"
fi

WT_DIR="$REPO_ROOT/.worktrees"
ACTIVE_DIR="$WT_DIR/active"
ARCHIVED_DIR="$WT_DIR/archived"
WT_PATH="$ACTIVE_DIR/$NAME"

[ -d "$WT_DIR" ] || error ".worktrees가 없습니다."

if [ ! -d "$WT_PATH" ]; then
  error "워크트리를 찾을 수 없습니다: $NAME"
fi

# 미커밋 변경 확인
DIRTY="$(cd "$WT_PATH" && git status --porcelain 2>/dev/null || echo '')"
if [ -n "$DIRTY" ] && [ "$FORCE" != "--force" ]; then
  warn "미커밋 변경사항이 있습니다:"
  echo "$DIRTY" | head -10
  echo ""
  error "--force 옵션으로 강제 제거하거나, 먼저 커밋하세요."
fi

# 아카이브 기록
mkdir -p "$ARCHIVED_DIR"
ARCHIVE_FILE="$ARCHIVED_DIR/${NAME}_$(date +%Y%m%d_%H%M%S).md"

LAST_COMMIT="$(cd "$WT_PATH" && git log -1 --pretty=format:'%h %s' 2>/dev/null || echo '(none)')"

cat > "$ARCHIVE_FILE" <<EOF
# Archived Worktree: $NAME

| Key | Value |
|-----|-------|
| Removed | $(date -u '+%Y-%m-%dT%H:%M:%SZ') |
| Last Commit | ${LAST_COMMIT} |
| Had Uncommitted | $([ -n "$DIRTY" ] && echo "Yes (forced)" || echo "No") |
EOF

# worktree 제거
info "워크트리 제거 중: $NAME"
if [ "$FORCE" = "--force" ]; then
  git worktree remove "$WT_PATH" --force 2>/dev/null || rm -rf "$WT_PATH"
else
  git worktree remove "$WT_PATH" 2>/dev/null || error "워크트리 제거 실패"
fi

# 브랜치 삭제 (머지되지 않은 경우 경고만)
if git branch -d "$NAME" 2>/dev/null; then
  ok "브랜치 '$NAME' 삭제 완료"
else
  warn "브랜치 '$NAME'은 머지되지 않아 유지됩니다. (git branch -D $NAME 으로 강제 삭제)"
fi

ok "워크트리 제거 완료: $NAME"
ok "아카이브: $ARCHIVE_FILE"
