---
name: nano-banana
description: Gemini CLI를 사용한 이미지 생성/편집. 블로그 이미지, 유튜브 썸네일, 아이콘, 다이어그램 등. 이미지 생성, 만들기, 그리기, 디자인 요청 시 사용.
---

# Nano Banana Image Generation

Gemini CLI의 nanobanana 확장으로 이미지를 생성합니다.

## 설치
```bash
npm install -g @google/gemini-cli
gemini extensions install https://github.com/gemini-cli-extensions/nanobanana
```

## 명령어

| 요청 | 명령어 |
|------|--------|
| 블로그 헤더 | `/generate` |
| 앱 아이콘 | `/icon` |
| 플로우차트 | `/diagram` |
| 사진 복원 | `/restore` |
| 배경 제거 | `/edit` |
| 텍스처 | `/pattern` |

## 사용 예시
```bash
# 이미지 생성
gemini --yolo "/generate 'modern flat illustration, purple and blue gradient' --preview"

# 아이콘 생성
gemini --yolo "/icon 'minimalist app logo' --sizes='64,128,256,512'"

# 다이어그램
gemini --yolo "/diagram 'user authentication flow' --type='flowchart'"
```

## 일반 사이즈
| 용도 | 크기 |
|------|------|
| YouTube 썸네일 | 1280x720 |
| 블로그 이미지 | 1200x630 |
| 정사각형 소셜 | 1080x1080 |

## 출력 위치
`./nanobanana-output/` 디렉토리에 저장됩니다.
