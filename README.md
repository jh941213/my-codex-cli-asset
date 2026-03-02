<div align="center">

<img src="assets/hero.png" alt="Codex CLI Power Pack" width="720" />

# My Codex Code Asset

**ChatGPT를 마구 Harness 장착시킨 Codex CLI 올인원 파워 팩**

[![Skills](https://img.shields.io/badge/skills-33-blue)](#스킬-목록)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Codex CLI](https://img.shields.io/badge/Codex_CLI-compatible-orange)](https://github.com/openai/codex)

</div>

> [jh941213/my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) 기반 **OpenAI Codex CLI** 올인원 설정

OpenAI Codex CLI에서 사용할 수 있도록 변환한 스킬 팩입니다.
원본 Claude Code Power Pack의 스킬, 에이전트, 규칙을 Codex CLI 형식에 맞게 재구성했습니다.

## 요구사항

- [OpenAI Codex CLI](https://github.com/openai/codex) (`npm i -g @openai/codex`)
- Node.js 22+
- Git

## 설치

### 자동 설치 (권장)

```bash
curl -fsSL https://raw.githubusercontent.com/jh941213/my-codex-code-asset/main/install.sh | bash
```

또는 클론 후 설치:

```bash
git clone https://github.com/jh941213/my-codex-code-asset.git
cd my-codex-code-asset
bash install.sh
```

### 수동 설치

```bash
# 1. 글로벌 AGENTS.md 복사
mkdir -p ~/.codex
cp AGENTS.md ~/.codex/AGENTS.md

# 2. 스킬 복사
cp -r skills/* ~/.codex/skills/

# 3. config.toml 복사 (선택)
cp config.toml ~/.codex/config.toml
```

## 구조

```
my-codex-code-asset/
├── AGENTS.md              # 메인 설정 (글로벌 지시사항)
├── config.toml            # Codex CLI 설정
├── install.sh             # 자동 설치 스크립트
├── skills/                # 30개 스킬
│   ├── plan/              # 작업 계획 수립
│   ├── verify/            # 코드 검증
│   ├── review/            # 코드 리뷰
│   ├── frontend/          # 빅테크 스타일 UI
│   ├── commit-push-pr/    # Git 워크플로우
│   ├── simplify/          # 코드 단순화
│   ├── tdd/               # 테스트 주도 개발
│   ├── build-fix/         # 빌드 에러 수정
│   ├── handoff/           # 세션 인계
│   ├── techdebt/          # 기술 부채 정리
│   ├── spec/              # SPEC 기반 개발
│   ├── spec-verify/       # 명세서 검증
│   ├── e2e-verify/        # E2E 테스트 검증
│   ├── nano-banana/       # 이미지 생성 (Gemini)
│   ├── compact-guide/     # 컨텍스트 관리
│   ├── react-patterns/    # React 19 패턴
│   ├── typescript-advanced-types/
│   ├── shadcn-ui/
│   ├── tailwind-design-system/
│   ├── ui-ux-pro-max/
│   ├── fastapi-templates/
│   ├── api-design-principles/
│   ├── async-python-patterns/
│   ├── python-testing-patterns/
│   ├── vercel-react-best-practices/
│   ├── e2e-agent-browser/
│   ├── stitch-design-md/
│   ├── stitch-enhance-prompt/
│   ├── stitch-loop/
│   ├── stitch-react/
│   ├── worktree/          # Git 워크트리 관리
│   ├── prd/               # PRD 생성
│   └── docs/              # 자동 문서 생성
└── .gitignore
```

## 스킬 목록

### 워크플로우 스킬 (18개)

| 스킬 | 호출 | 용도 |
|------|------|------|
| plan | `$plan` | 복잡한 작업 전 계획 수립 |
| verify | `$verify` | 타입체크, 린트, 테스트, 빌드 검증 |
| review | `$review` | 코드 리뷰 |
| frontend | `$frontend` | 빅테크 스타일 UI 개발 |
| commit-push-pr | `$commit-push-pr` | 커밋 -> 푸시 -> PR |
| simplify | `$simplify` | 코드 단순화 |
| tdd | `$tdd` | 테스트 주도 개발 |
| build-fix | `$build-fix` | 빌드 에러 수정 |
| handoff | `$handoff` | HANDOFF.md 생성 |
| techdebt | `$techdebt` | 기술 부채 정리 |
| spec | `$spec` | SPEC 기반 개발 인터뷰 |
| spec-verify | `$spec-verify` | 명세서 기반 검증 |
| e2e-verify | `$e2e-verify` | E2E 테스트 검증 |
| nano-banana | `$nano-banana` | 이미지 생성 |
| compact-guide | `$compact-guide` | 컨텍스트 관리 가이드 |
| worktree | `$worktree` | Git 워크트리 관리 + 커밋 자동 기록 |
| prd | `$prd` | PRD(제품 요구사항 문서) 생성 |
| docs | `$docs` | 코드 변경사항 기반 자동 문서 생성 |

### 기술 스킬 (15개)

| 스킬 | 분야 |
|------|------|
| react-patterns | React 19 전체 패턴 |
| vercel-react-best-practices | React/Next.js 성능 최적화 |
| typescript-advanced-types | 고급 타입 시스템 |
| shadcn-ui | shadcn/ui 컴포넌트 |
| tailwind-design-system | Tailwind CSS 디자인 시스템 |
| ui-ux-pro-max | UI/UX 종합 가이드 |
| fastapi-templates | FastAPI 템플릿 |
| api-design-principles | REST/GraphQL API 설계 |
| async-python-patterns | Python 비동기 패턴 |
| python-testing-patterns | pytest 테스트 패턴 |
| e2e-agent-browser | 브라우저 E2E 테스트 |
| stitch-design-md | Stitch 디자인 시스템 |
| stitch-enhance-prompt | Stitch 프롬프트 최적화 |
| stitch-loop | Stitch 멀티페이지 생성 |
| stitch-react | Stitch React 변환 |

## 권장 워크플로우

```
$plan -> 구현 -> $review -> $verify -> $e2e-verify
```

대규모 기능 개발:
```
세션 1: $spec (인터뷰) -> SPEC.md 생성
세션 2: SPEC.md 읽고 구현
세션 3: $spec-verify (검증)
```

## 원본 프로젝트

- [jh941213/my-claude-code-asset](https://github.com/jh941213/my-claude-code-asset) - Claude Code Power Pack (원본)

## 라이선스

MIT
