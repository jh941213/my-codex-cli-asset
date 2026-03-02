#!/usr/bin/env bash
set -euo pipefail

# wt-init.sh — 프로젝트에 worktree 시스템 초기화
# - .worktrees/ 디렉토리 구조 생성
# - wt-log.sh를 .worktrees/hooks/에 복사 (self-contained)
# - git post-commit 훅 설치 (기존 훅 보존)
# - .gitignore에 .worktrees/ 추가

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[worktree]${NC} $1"; }
ok()    { echo -e "${GREEN}[worktree]${NC} $1"; }
warn()  { echo -e "${YELLOW}[worktree]${NC} $1"; }
error() { echo -e "${RED}[worktree]${NC} $1"; exit 1; }

# git 저장소 확인
git rev-parse --git-dir &>/dev/null || error "git 저장소가 아닙니다. git 프로젝트 루트에서 실행하세요."

REPO_ROOT="$(git rev-parse --show-toplevel)"
WT_DIR="$REPO_ROOT/.worktrees"
HOOK_MARKER="# [worktree-skill]"

# 이미 초기화된 경우
if [ -d "$WT_DIR/hooks" ] && [ -f "$WT_DIR/hooks/wt-log.sh" ]; then
  warn "이미 초기화되어 있습니다: $WT_DIR"
  warn "재초기화하려면 .worktrees/ 디렉토리를 삭제하세요."
  exit 0
fi

echo ""
echo "=================================="
echo "  Worktree System Initializer"
echo "=================================="
echo ""

# ── 1. 디렉토리 생성 ──
info "디렉토리 생성 중..."
mkdir -p "$WT_DIR"/{log,active,hooks,archived}
ok ".worktrees/ 구조 생성 완료"

# ── 2. wt-log.sh 복사 (self-contained) ──
info "wt-log.sh 복사 중..."

# 스크립트 위치 찾기 (이 파일과 같은 디렉토리의 wt-log.sh)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_LOG="$SCRIPT_DIR/wt-log.sh"

if [ ! -f "$SOURCE_LOG" ]; then
  # 설치된 위치에서 시도
  SOURCE_LOG="$HOME/.codex/skills/worktree/scripts/wt-log.sh"
fi

if [ ! -f "$SOURCE_LOG" ]; then
  error "wt-log.sh를 찾을 수 없습니다. 스킬이 올바르게 설치되었는지 확인하세요."
fi

cp "$SOURCE_LOG" "$WT_DIR/hooks/wt-log.sh"
chmod +x "$WT_DIR/hooks/wt-log.sh"
ok "wt-log.sh → .worktrees/hooks/ 복사 완료"

# ── 3. git post-commit 훅 설치 ──
info "post-commit 훅 설치 중..."

GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"
mkdir -p "$GIT_HOOKS_DIR"
POST_COMMIT="$GIT_HOOKS_DIR/post-commit"

# 이미 마커가 있으면 스킵
if [ -f "$POST_COMMIT" ] && grep -q "$HOOK_MARKER" "$POST_COMMIT" 2>/dev/null; then
  warn "post-commit 훅에 이미 worktree-skill이 설치되어 있습니다."
else
  # 기존 훅이 없으면 새로 생성
  if [ ! -f "$POST_COMMIT" ]; then
    echo '#!/usr/bin/env bash' > "$POST_COMMIT"
  fi

  # 마커와 함께 추가
  # --git-common-dir로 메인 .git를 찾아 실제 레포 루트 결정
  # (worktree에서 --show-toplevel은 worktree 루트를 반환하므로 사용 불가)
  cat >> "$POST_COMMIT" <<'EOF'

# [worktree-skill] — START (자동 생성, 수동 삭제 가능)
_WT_GIT_COMMON="$(git rev-parse --git-common-dir 2>/dev/null)"
if [ "$_WT_GIT_COMMON" = ".git" ]; then
  _WT_REPO_ROOT="$(pwd)"
else
  _WT_REPO_ROOT="$(cd "$_WT_GIT_COMMON/.." 2>/dev/null && pwd)"
fi
if [ -x "$_WT_REPO_ROOT/.worktrees/hooks/wt-log.sh" ]; then
  "$_WT_REPO_ROOT/.worktrees/hooks/wt-log.sh"
fi
unset _WT_GIT_COMMON _WT_REPO_ROOT
# [worktree-skill] — END
EOF

  chmod +x "$POST_COMMIT"
  ok "post-commit 훅 설치 완료"
fi

# ── 4. .gitignore 업데이트 ──
info ".gitignore 업데이트 중..."

GITIGNORE="$REPO_ROOT/.gitignore"
if [ -f "$GITIGNORE" ] && grep -q '^\.worktrees/' "$GITIGNORE" 2>/dev/null; then
  warn ".gitignore에 이미 .worktrees/가 있습니다."
else
  echo "" >> "$GITIGNORE"
  echo "# Worktree system (local only)" >> "$GITIGNORE"
  echo ".worktrees/" >> "$GITIGNORE"
  ok ".gitignore에 .worktrees/ 추가 완료"
fi

# ── 완료 ──
echo ""
echo "=================================="
echo -e "  ${GREEN}초기화 완료!${NC}"
echo "=================================="
echo ""
echo "생성된 구조:"
echo "  $WT_DIR/"
echo "  ├── hooks/wt-log.sh   ← 커밋 자동 기록"
echo "  ├── log/               ← 커밋별 상세 기록"
echo "  ├── active/            ← 워크트리 디렉토리"
echo "  └── archived/          ← 제거된 워크트리 기록"
echo ""
echo "다음 단계:"
echo "  git commit ...                                    # 자동 이력 기록 시작"
echo "  bash ~/.codex/skills/worktree/scripts/wt-create.sh feature-name  # 워크트리 생성"
echo "  bash ~/.codex/skills/worktree/scripts/wt-list.sh                 # 목록 조회"
