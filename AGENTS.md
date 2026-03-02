# Codex Code Power Pack 설정

jh941213/my-claude-code-asset 기반 Codex CLI 올인원 설정

## 핵심 마인드셋
**Codex는 시니어가 아니라 똑똑한 주니어 개발자다.**
- 작업을 작게 쪼갤수록 결과물이 좋아진다
- "인증 기능 만들어줘" (X)
- "로그인 폼 만들고, JWT 생성하고, 리프레시 토큰 구현해줘" (O)

## 핵심 원칙 (Core Principles)

- **Simplicity First**: 모든 변경은 최대한 단순하게. 최소한의 코드만 변경
- **No Laziness**: 근본 원인을 찾아 수정. 임시 수정/우회 금지. 시니어 개발자 기준 유지
- **Minimal Impact**: 필요한 부분만 변경. 불필요한 변경으로 버그 도입 방지

## 워크플로우 오케스트레이션

### Plan 우선 규칙
- 3단계 이상 또는 아키텍처 결정이 필요한 모든 작업은 `$plan` 스킬 사용
- **문제 발생 시 STOP -> 즉시 re-plan** (밀어붙이지 않기)
- 상세 스펙을 먼저 작성하여 모호함 제거

### 완료 전 검증 (Verification Before Done)
- 작동을 증명하지 않고는 절대 완료 표시하지 않기
- 자문: **"스태프 엔지니어가 이걸 승인할까?"**
- 테스트 실행, 로그 확인, 정확성 입증

### 자율적 버그 수정
- 버그 리포트 받으면 질문 없이 직접 수정
- 로그, 에러, 실패 테스트를 찾아서 해결
- 사용자에게 컨텍스트 스위칭 부담 주지 않기

## 작업 관리 (Task Management)

1. **계획 작성**: `tasks/todo.md`에 체크 가능한 항목으로 작성
2. **계획 확인**: 구현 시작 전 사용자와 확인
3. **진행 추적**: 완료된 항목 체크 표시
4. **변경 설명**: 각 단계마다 고수준 요약 제공
5. **교훈 기록**: 수정 후 `tasks/lessons.md` 업데이트

## 코딩 스타일

### 불변성 (필수)
항상 새 객체 생성, 절대 뮤테이션 금지:
```javascript
// 올바름: 불변성
function updateUser(user, name) {
  return { ...user, name }
}
```

### 파일 구성
- 높은 응집도, 낮은 결합도
- 일반적으로 200-400줄, 최대 800줄
- 기능/도메인별로 구성

### 에러 처리
```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('작업 실패:', error)
  throw new Error('사용자 친화적인 상세 메시지')
}
```

### 입력 검증
```typescript
import { z } from 'zod'
const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})
const validated = schema.parse(input)
```

### 코드 품질 체크리스트
- [ ] 코드가 읽기 쉽고 이름이 적절함
- [ ] 함수가 작음 (<50줄)
- [ ] 파일이 집중됨 (<800줄)
- [ ] 깊은 중첩 없음 (>4단계)
- [ ] 적절한 에러 처리
- [ ] console.log 문 없음
- [ ] 하드코딩된 값 없음
- [ ] 뮤테이션 없음 (불변 패턴 사용)

## Git 워크플로우

### 브랜치 전략
```
main (또는 master)
  └── develop
       ├── feature/기능명
       ├── fix/버그명
       └── refactor/대상
```

### 커밋 메시지 형식
```
[타입] 제목 (50자 이내)

본문 (선택, 72자 줄바꿈)

Co-Authored-By: Codex <noreply@openai.com>
```
타입: feat, fix, docs, style, refactor, test, chore

### 금지 사항
- main/master에 직접 push 금지
- force push 금지
- .env 파일 커밋 금지
- 하드코딩된 API 키/시크릿 금지
- console.log 커밋 금지

## 테스트 가이드라인

- 새 기능 = 새 테스트
- 버그 수정 = 회귀 테스트
- 새 코드 커버리지: 80% 이상
- 핵심 비즈니스 로직: 90% 이상

## 성능 가이드라인

### React 최적화
```typescript
const MemoizedComponent = React.memo(Component);
const memoizedValue = useMemo(() => compute(a, b), [a, b]);
```

### 백엔드
- 인덱스 적절히 사용
- N+1 쿼리 방지
- 페이지네이션 구현

## 보안 가이드라인

### 필수 보안 검사
- [ ] 하드코딩된 시크릿 없음
- [ ] 모든 사용자 입력 검증됨
- [ ] SQL 인젝션 방지
- [ ] XSS 방지
- [ ] CSRF 보호 활성화
- [ ] 에러 메시지에 민감 정보 노출 없음

### 시크릿 관리
```typescript
// 항상: 환경 변수 사용
const apiKey = process.env.OPENAI_API_KEY
if (!apiKey) {
  throw new Error('OPENAI_API_KEY가 설정되지 않았습니다')
}
```

## 사용 가능한 스킬

| 스킬 | 용도 |
|------|------|
| `$plan` | 작업 계획 수립 |
| `$spec` | SPEC 기반 개발 - 심층 인터뷰 |
| `$spec-verify` | 명세서 기반 구현 검증 |
| `$frontend` | 빅테크 스타일 UI 개발 |
| `$verify` | 테스트, 린트, 빌드 검증 |
| `$e2e-verify` | 피처 기반 E2E 테스트 검증 |
| `$commit-push-pr` | 커밋 -> 푸시 -> PR |
| `$review` | 코드 리뷰 |
| `$simplify` | 코드 단순화 |
| `$tdd` | 테스트 주도 개발 |
| `$build-fix` | 빌드 에러 수정 |
| `$handoff` | HANDOFF.md 세션 인계 |
| `$techdebt` | 기술 부채 정리 |
| `$nano-banana` | Gemini CLI로 이미지 생성 |
| `$worktree` | Git 워크트리 관리 + 커밋 자동 기록 |
| `$prd` | PRD(제품 요구사항 문서) 생성 |
| `$docs` | 코드 변경사항 기반 자동 문서 생성 |
| `$react-patterns` | React 19 패턴 |
| `$typescript-advanced-types` | 고급 타입 시스템 |
| `$shadcn-ui` | shadcn/ui 컴포넌트 |
| `$tailwind-design-system` | Tailwind CSS 디자인 시스템 |
| `$ui-ux-pro-max` | UI/UX 종합 가이드 |
| `$fastapi-templates` | FastAPI 템플릿 |
| `$api-design-principles` | REST/GraphQL API 설계 |
| `$async-python-patterns` | Python 비동기 패턴 |
| `$python-testing-patterns` | pytest 테스트 패턴 |
| `$vercel-react-best-practices` | React/Next.js 성능 최적화 |

## 워크플로우 체이닝
```
복잡한 작업 -> $plan -> 구현 -> $review -> $verify -> $e2e-verify
```
