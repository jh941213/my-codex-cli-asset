#!/usr/bin/env bash
set -euo pipefail

# wt-list.sh — 활성 워크트리 목록 + 최근 커밋 이력 조회

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 메인 레포 루트 찾기
GIT_COMMON_DIR="$(git rev-parse --git-common-dir 2>/dev/null)" || { echo "git 저장소가 아닙니다."; exit 1; }
if [ "$GIT_COMMON_DIR" = ".git" ]; then
  REPO_ROOT="$(pwd)"
else
  REPO_ROOT="$(cd "$GIT_COMMON_DIR/../.." 2>/dev/null && pwd || cd "$GIT_COMMON_DIR/.." && pwd)"
fi

WT_DIR="$REPO_ROOT/.worktrees"

if [ ! -d "$WT_DIR" ]; then
  echo "worktree 시스템이 초기화되지 않았습니다. wt-init.sh를 먼저 실행하세요."
  exit 1
fi

# ── 활성 워크트리 목록 ──
echo -e "${BLUE}== Active Worktrees ==${NC}"
echo ""

ACTIVE_DIR="$WT_DIR/active"
if [ -d "$ACTIVE_DIR" ] && [ "$(ls -A "$ACTIVE_DIR" 2>/dev/null)" ]; then
  printf "%-20s %-15s %-40s\n" "NAME" "BRANCH" "PATH"
  printf "%-20s %-15s %-40s\n" "----" "------" "----"
  for wt in "$ACTIVE_DIR"/*/; do
    [ -d "$wt" ] || continue
    wt_name="$(basename "$wt")"
    wt_branch="$(cd "$wt" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
    printf "%-20s %-15s %-40s\n" "$wt_name" "$wt_branch" "$wt"
  done
else
  echo "  (활성 워크트리 없음)"
fi

echo ""

# ── Git worktree list (전체) ──
echo -e "${BLUE}== Git Worktree List ==${NC}"
echo ""
git worktree list 2>/dev/null || echo "  (조회 실패)"

echo ""

# ── 최근 커밋 이력 ──
echo -e "${BLUE}== Recent Commits (last 10) ==${NC}"
echo ""

HISTORY_FILE="$WT_DIR/HISTORY.md"
if [ -f "$HISTORY_FILE" ]; then
  TOTAL_LINES="$(wc -l < "$HISTORY_FILE" | tr -d ' ')"
  if [ "$TOTAL_LINES" -le 13 ]; then
    # 파일이 작으면 전체 출력
    cat "$HISTORY_FILE"
  else
    # 헤더(3줄) + 마지막 10줄
    head -3 "$HISTORY_FILE"
    tail -10 "$HISTORY_FILE"
  fi
else
  echo "  (커밋 이력 없음 — 커밋 후 자동 생성됩니다)"
fi
