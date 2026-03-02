#!/usr/bin/env bash
set -euo pipefail

# wt-log.sh — git post-commit hook이 호출하는 커밋 기록 스크립트
# 어떤 worktree에서 커밋해도 메인 레포의 .worktrees/에 기록
# self-contained: skill 삭제 후에도 .worktrees/hooks/wt-log.sh로 동작

# ── 메인 레포 루트 찾기 (worktree에서도 동작) ──
GIT_COMMON_DIR="$(git rev-parse --git-common-dir 2>/dev/null)" || exit 0
if [ "$GIT_COMMON_DIR" = ".git" ]; then
  REPO_ROOT="$(pwd)"
else
  # --git-common-dir는 절대경로 또는 상대경로를 반환
  # macOS 호환: readlink -f 대신 cd && pwd 사용
  REPO_ROOT="$(cd "$(dirname "$GIT_COMMON_DIR")" && pwd)"
  # .git/worktrees/<name> → .git → 부모 디렉토리가 레포 루트
  if [ "$(basename "$GIT_COMMON_DIR")" = ".git" ]; then
    REPO_ROOT="$(cd "$GIT_COMMON_DIR/.." && pwd)"
  else
    REPO_ROOT="$(cd "$GIT_COMMON_DIR/../.." && pwd)"
  fi
fi

WT_DIR="$REPO_ROOT/.worktrees"
LOG_DIR="$WT_DIR/log"
HISTORY_FILE="$WT_DIR/HISTORY.md"

# .worktrees 디렉토리가 없으면 종료 (init 안 된 프로젝트)
[ -d "$WT_DIR" ] || exit 0
mkdir -p "$LOG_DIR"

# ── 커밋 정보 수집 ──
HASH="$(git rev-parse HEAD)"
SHORT_HASH="$(git rev-parse --short HEAD)"
MESSAGE="$(git log -1 --pretty=format:'%s')"
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'detached')"
AUTHOR="$(git log -1 --pretty=format:'%an <%ae>')"
DATE_ISO="$(git log -1 --pretty=format:'%aI')"
DATE_SHORT="$(git log -1 --pretty=format:'%ad' --date=short)"
TIME_SHORT="$(echo "$DATE_ISO" | sed 's/.*T\([0-9]*:[0-9]*\).*/\1/')"
CHANGED_FILES="$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null || echo '(none)')"
DIFF_STAT="$(git diff-tree --no-commit-id --stat -r HEAD 2>/dev/null || echo '(none)')"

# ── 상세 로그 파일 작성 ──
LOG_FILE="$LOG_DIR/${DATE_SHORT}_${SHORT_HASH}.md"

cat > "$LOG_FILE" <<EOF
# Commit: ${SHORT_HASH}

| Key | Value |
|-----|-------|
| Hash | \`${HASH}\` |
| Branch | \`${BRANCH}\` |
| Author | ${AUTHOR} |
| Date | ${DATE_ISO} |
| Message | ${MESSAGE} |

## Changed Files

\`\`\`
${CHANGED_FILES}
\`\`\`

## Diff Stats

\`\`\`
${DIFF_STAT}
\`\`\`
EOF

# ── HISTORY.md 업데이트 ──
# 헤더가 없으면 생성
if [ ! -f "$HISTORY_FILE" ]; then
  cat > "$HISTORY_FILE" <<'HEADER'
# Commit History

| Date | Time | Hash | Branch | Message |
|------|------|------|--------|---------|
HEADER
fi

# 테이블 행 추가 (파일 끝에 append)
echo "| ${DATE_SHORT} | ${TIME_SHORT} | \`${SHORT_HASH}\` | \`${BRANCH}\` | ${MESSAGE} |" >> "$HISTORY_FILE"
