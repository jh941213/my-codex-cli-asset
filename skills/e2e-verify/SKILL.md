---
name: e2e-verify
description: 개발 완료 후 피처 기반 E2E 테스트 작성 및 실행. verify 이후 실제 사용자 플로우를 검증합니다. "e2e 검증", "e2e-verify", "E2E 테스트" 키워드에 활성화.
---

# E2E 피처 검증

개발 + `$verify` 완료 후, 구현한 피처가 실제 브라우저에서 동작하는지 E2E 테스트로 검증합니다.

## 전제 조건
- `$verify` 통과 완료 (typecheck, lint, test, build)
- 앱이 로컬에서 실행 가능한 상태

## 워크플로우

### 1단계: 피처 분석
구현한 피처의 사용자 플로우를 파악합니다.

### 2단계: 앱 실행
```bash
cat package.json | grep -A 5 '"scripts"'
npm run dev &
sleep 5
```

### 3단계: E2E 테스트 작성

**Playwright 사용 시:**
```typescript
import { test, expect } from '@playwright/test';

test('피처명: 사용자 플로우', async ({ page }) => {
  await page.goto('/');
  await page.fill('[data-testid="email"]', 'test@example.com');
  await page.click('[data-testid="submit"]');
  await expect(page.locator('.success')).toBeVisible();
});
```

**Cypress 사용 시:**
```typescript
describe('피처명', () => {
  it('사용자 플로우를 완료한다', () => {
    cy.visit('/');
    cy.get('[data-testid="email"]').type('test@example.com');
    cy.get('[data-testid="submit"]').click();
    cy.contains('Success').should('be.visible');
  });
});
```

### 4단계: 테스트 실행
```bash
npx playwright test e2e/feature.spec.ts
# 또는
npx cypress run --spec "cypress/e2e/feature.cy.ts"
```

## 테스트 체크리스트
- [ ] 해피 패스 (정상 플로우) 통과
- [ ] 에러 케이스 처리 확인
- [ ] 페이지 이동/라우팅 정상 동작
- [ ] UI 상태 변화 표시 확인
