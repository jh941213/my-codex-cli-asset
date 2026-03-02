#!/usr/bin/env bash
set -euo pipefail

# wt-switch.sh — 워크트리 경로 출력 (Codex가 cd로 이동)
# 사용법: wt-switch.sh <name>
# 사용 예: cd $(wt-switch.sh feature-auth)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

error() { echo -e "${RED}[worktree]${NC} $1" >&2; exit 1; }

NAME="${1:-}"

if [ -z "$NAME" ]; then
  error "사용법: wt-switch.sh <name>"
fi

# 메인 레포 루트 찾기
GIT_COMMON_DIR="$(git rev-parse --git-common-dir 2>/dev/null)" || error "git 저장소가 아닙니다."
if [ "$GIT_COMMON_DIR" = ".git" ]; then
  REPO_ROOT="$(pwd)"
else
  REPO_ROOT="$(cd "$GIT_COMMON_DIR/../.." 2>/dev/null && pwd || cd "$GIT_COMMON_DIR/.." && pwd)"
fi

WT_PATH="$REPO_ROOT/.worktrees/active/$NAME"

if [ ! -d "$WT_PATH" ]; then
  error "워크트리를 찾을 수 없습니다: $NAME"
fi

# 경로만 출력 (cd에서 사용)
echo "$WT_PATH"
