# DizzyAsset 🌀

**DizzyAsset은 맥과 외장 SSD에 흩어진 편집 리소스를 복사 없이 인덱싱하고, 편집자 언어로 정리하여 Final Cut Pro에서 즉시 사용할 수 있게 해주는 위치 독립 에셋 허브입니다.**

---

## 🚀 핵심 가치 (Core Values)

1. **복사 없이 관리**: 내장 디스크, 외장 SSD, 다운로드 폴더 어디에 있든 원본 파일을 이동하지 않고 인덱싱합니다.
2. **초고속 탐색**: 0.3초 이내의 지연 시간을 목표로 하는 즉각적인 검색과 미리듣기(Space)를 제공합니다.
3. **워크플로우 통합**: 검색된 에셋을 Final Cut Pro 타임라인으로 직접 드래그하여 즉시 사용합니다.
4. **지능형 정리**: 무음 구간 자동 감지 및 파일명 기반 태깅으로 정리 시간을 단축합니다.

---

## ✨ 주요 기능 (Features)

- **위치 독립 인덱싱**: 파일 이동 없이 메타데이터와 북마크(Security-scoped)만 관리
- **고속 미리보기**: Space 키를 활용한 오디오/영상 즉시 재생 및 리스트 연속 탐색
- **Quick Peek**: 전역 단축키 기반의 Spotlight 스타일 오버레이 검색창
- **FCP 연동**: 드래그 앤 드롭을 통한 타임라인 삽입 및 라이브러리 연결 지원
- **무음 구간 감지**: 오디오 파일 앞/뒤의 무음 구간을 분석하여 시각화

---

## 🛠 기술 스택 (Tech Stack)

- **Language**: Swift 6.0+
- **UI Framework**: SwiftUI & AppKit (for Quick Peek/Global Hotkey)
- **Database**: SQLite (FTS5 기반 고속 검색)
- **Frameworks**: AVFoundation (Preview & Analysis), Combine/Swift Concurrency
- **Project Tool**: XcodeGen (Project as Code)

---

## 🏗 아키텍처 (Architecture)

Clean Architecture 기반의 4계층 구조를 따릅니다.

- **Presentation**: SwiftUI 기반의 3단 분할 뷰 레이아웃
- **Domain**: 핵심 비즈니스 로직 및 에셋 모델
- **Data**: SQLite 영속성 관리 및 파일 시스템 접근(Bookmark)
- **Infrastructure**: 하드웨어 가속 기반의 미디어 분석 및 연동

---

## 📂 프로젝트 구조 (Project Structure)

```text
DizzyAsset/
├── App/                # 앱 엔트리 포인트 및 라이프사이클
├── Presentation/       # UI 레이어 (Views, ViewModels, DesignSystem)
├── Domain/             # 비즈니스 로직 및 도메인 모델
├── Data/               # 데이터 저장 및 외부 서비스 연동
└── Resources/          # 에셋 카탈로그, 권한(Entitlements), 디자인 리소스
```

---

## ⚙️ 시작하기 (Getting Started)

본 프로젝트는 **XcodeGen**을 사용하여 관리됩니다.

1. **XcodeGen 설치**:
   ```bash
   brew install xcodegen
   ```

2. **프로젝트 생성**:
   ```bash
   xcodegen generate
   ```

3. **Xcode에서 실행**:
   `DizzyAsset.xcodeproj` 파일을 열고 `Command + R`을 눌러 실행합니다. (macOS 13.0+ 필요)

---

## 📄 문서 (Documentation)

자세한 제품 기획 및 설계 내용은 `docs/product/` 폴더를 참조하십시오.
- [PRD](docs/product/dizzyasset_v1_prd.md)
- [개발 설계 문서](docs/product/dizzyasset_design_doc.md)
- [개발 계획서](docs/product/dizzyasset_development_plan.md)

---

## ⚖️ License

이 프로젝트는 MIT 라이선스에 따라 배포됩니다.