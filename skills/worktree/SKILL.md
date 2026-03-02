---
name: worktree
description: Git worktree 관리 + 커밋 자동 기록. "워크트리", "worktree", "작업 분기" 키워드에 활성화.
---

# Git Worktree 관리

프로젝트에 git worktree 시스템을 설정하고, 매 커밋마다 이력을 자동 기록합니다.

## 스크립트

| 스크립트 | 용도 |
|----------|------|
| `wt-init.sh` | 프로젝트에 worktree 시스템 초기화 |
| `wt-create.sh <name>` | 새 워크트리 생성 |
| `wt-list.sh` | 워크트리 목록 + 커밋 이력 조회 |
| `wt-switch.sh <name>` | 워크트리로 이동 |
| `wt-cleanup.sh <name>` | 워크트리 제거 |

## 사용법

### 1. 초기화 (프로젝트당 1회)

```bash
bash ~/.codex/skills/worktree/scripts/wt-init.sh
```

이 명령은:
- `.worktrees/` 디렉토리 생성 (log/, active/, hooks/, archived/)
- git post-commit 훅 설치 (매 커밋마다 자동 이력 기록)
- `.gitignore`에 `.worktrees/` 추가

### 2. 워크트리 생성

```bash
bash ~/.codex/skills/worktree/scripts/wt-create.sh feature-auth
# 특정 브랜치 기반:
bash ~/.codex/skills/worktree/scripts/wt-create.sh hotfix-login main
```

### 3. 워크트리로 이동

```bash
cd $(bash ~/.codex/skills/worktree/scripts/wt-switch.sh feature-auth)
```

### 4. 목록 조회

```bash
bash ~/.codex/skills/worktree/scripts/wt-list.sh
```

### 5. 워크트리 제거

```bash
bash ~/.codex/skills/worktree/scripts/wt-cleanup.sh feature-auth
# 미커밋 변경 강제 제거:
bash ~/.codex/skills/worktree/scripts/wt-cleanup.sh feature-auth --force
```

## 프로젝트에 생성되는 구조

```
<project>/
├── .worktrees/                  ← .gitignore에 추가됨
│   ├── hooks/wt-log.sh         ← self-contained 커밋 기록기
│   ├── log/                    ← 커밋별 상세 기록
│   │   └── 2026-03-02_abc1234.md
│   ├── active/                 ← git worktree 디렉토리들
│   │   └── feature-auth/
│   ├── archived/               ← 제거된 워크트리 기록
│   └── HISTORY.md              ← 전체 커밋 이력 테이블
└── .git/hooks/post-commit      ← wt-log.sh 호출
```

## 자동 커밋 기록

초기화 후 어떤 worktree에서 커밋하든 자동으로:
- `.worktrees/log/YYYY-MM-DD_<hash>.md` — 상세 기록 (변경 파일, diff stats)
- `.worktrees/HISTORY.md` — 한 줄 요약 테이블

## 주의사항

- `.worktrees/`는 로컬 전용 (`.gitignore`에 추가됨)
- skill 삭제 후에도 `.worktrees/hooks/wt-log.sh`가 독립 동작
- 기존 post-commit 훅이 있으면 보존 (마커 기반 append)
