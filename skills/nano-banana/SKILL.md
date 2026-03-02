---
name: nano-banana
description: Nano Banana 2로 이미지 생성/편집. 블로그 이미지, 썸네일, 아이콘, 다이어그램 등. "이미지 생성", "그려줘", "만들어줘" 키워드에 활성화.
---

# Nano Banana 2 Image Generation

Nano Banana 2 (`gemini-3.1-flash-image-preview`)로 프로페셔널 이미지를 생성합니다.
Pro 수준 품질을 Flash 속도로 — 512px~4K, 다양한 종횡비, 다국어 텍스트 렌더링 지원.

## 사전 준비

```bash
pip install google-genai
export GEMINI_API_KEY="your-paid-api-key"  # 유료 필수
```

**중요**: 무료 API 키는 이미지 생성 할당량이 0입니다. 반드시 유료 키 사용.

## 이미지 생성 코드

```python
import os
from google import genai
from google.genai import types

client = genai.Client(api_key=os.environ["GEMINI_API_KEY"])

response = client.models.generate_content(
    model="gemini-3.1-flash-image-preview",
    contents="프롬프트",
    config=types.GenerateContentConfig(
        response_modalities=["IMAGE", "TEXT"],
    )
)

for part in response.candidates[0].content.parts:
    if part.inline_data is not None:
        with open("output.png", "wb") as f:
            f.write(part.inline_data.data)
```

## 고급 옵션

### 해상도
```python
config=types.GenerateContentConfig(
    response_modalities=["IMAGE", "TEXT"],
    image_size="4K",  # "512", "1K", "2K" (기본), "4K"
)
```

### 종횡비
```python
config=types.GenerateContentConfig(
    response_modalities=["IMAGE", "TEXT"],
    aspect_ratio="16:9",  # "1:1", "16:9", "9:16", "4:3", "3:4", "4:1", "1:4"
)
```

### 사고 수준 (복잡한 장면)
```python
config=types.GenerateContentConfig(
    response_modalities=["IMAGE", "TEXT"],
    thinking_level="high",  # "minimal" (기본), "high", "dynamic"
)
```

## 일반 사이즈

| 용도 | 종횡비 |
|------|--------|
| YouTube 썸네일 | 16:9 |
| 블로그 이미지 | 16:9 |
| 정사각형 소셜 | 1:1 |
| 세로 스토리 | 9:16 |
| GitHub 배너 | 16:9 |

## 모델 선택

| 모델 | ID | 가격/이미지 |
|------|-----|------------|
| **NB2 (기본)** | `gemini-3.1-flash-image-preview` | ~$0.10 (2K) |
| NB Pro | `gemini-3-pro-image-preview` | ~$0.20 |

기본은 항상 NB2 — Pro는 최고 품질 필요 시에만.

## 프롬프트 팁

1. **구체적으로**: 스타일, 무드, 색상, 구도 세부사항 포함
2. **텍스트 불필요 시**: "no text" 추가
3. **스타일 참조**: "editorial photography", "flat illustration", "3D render"
4. **복잡한 장면**: `thinking_level="high"` 사용

## 멀티턴 편집

```python
chat = client.chats.create(model="gemini-3.1-flash-image-preview")
r1 = chat.send_message("A red apple on a table",
    config=types.GenerateContentConfig(response_modalities=["IMAGE", "TEXT"]))
r2 = chat.send_message("Add a green leaf on top",
    config=types.GenerateContentConfig(response_modalities=["IMAGE", "TEXT"]))
```

## 트러블슈팅

| 문제 | 해결 |
|------|------|
| Quota exceeded | 유료 API 키 필요 (무료 = 0 할당량) |
| 텍스트만 응답 | `response_modalities=["IMAGE", "TEXT"]` 확인 |
| 429 Rate Limit | 지수 백오프 (2s → 4s → 8s) |
| 모델 not found | ID 확인: `gemini-3.1-flash-image-preview` |
