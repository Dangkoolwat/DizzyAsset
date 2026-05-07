# DizzyAsset 개발 설계 문서 v1.3

- 기준 문서: DizzyAsset v1.3 PRD
- 플랫폼: macOS
- 최소 지원 OS: macOS 13 Ventura
- 주요 QA 대상: macOS 15 Sequoia, macOS 26 Tahoe
- 주요 사용자: Final Cut Pro 기반 영상 편집자

---

## 1. 설계 목표

DizzyAsset은 내장 디스크, 외장 SSD, 다운로드 폴더 등에 흩어진 편집 리소스를 복사 없이 인덱싱하고, 태그/카테고리/검색/미리보기/Final Cut Pro 드래그 연동을 제공하는 위치 독립 에셋 허브이다.

개발 설계의 핵심 목표는 다음과 같다.

1. 원본 파일을 이동하거나 수정하지 않는다.
2. 에셋 정보와 사용자 분류 정보는 로컬 DB에 안정적으로 저장한다.
3. 파일/폴더 드래그 앤 드롭부터 검색/미리보기/파컷 드래그까지 빠르게 동작해야 한다.
4. AI/분석 기능은 교체 가능한 Provider 구조로 설계한다.
5. v1.0은 기본 태그/카테고리, Quick Peek 기본형, 무음 감지 표시, Final Cut Pro 드래그를 포함한다.

---

## 2. 전체 아키텍처

DizzyAsset은 SwiftUI 기반 앱으로 구성하되, macOS 네이티브 동작이 필요한 영역은 AppKit을 병행한다.

    SwiftUI Views
        ↓
    ViewModels / App State
        ↓
    Domain Services
        ↓
    Infrastructure Layer
        ↓
    SQLite / File System / AVFoundation / AppKit

### 2.1 주요 레이어

#### UI Layer

- MainWindowView
- SidebarView
- AssetListView
- AssetDetailView
- QuickPeekPanel
- PreferencesView

#### ViewModel Layer

- LibraryViewModel
- AssetListViewModel
- AssetDetailViewModel
- ImportViewModel
- QuickPeekViewModel
- PreferencesViewModel

#### Domain Service Layer

- AssetImportService
- AssetIndexingService
- DuplicateDetectionService
- SearchService
- TaggingService
- CategoryService
- PreviewService
- SilenceDetectionService
- FinalCutIntegrationService

#### Infrastructure Layer

- Database
- FileSystemAccess
- BookmarkStore
- HashService
- MetadataExtractor
- DragAndDropProvider
- AnalyzerProvider

---

## 3. 핵심 모듈 설계

## 3.1 Asset Import 모듈

### 역할

사용자가 파일 또는 폴더를 드래그 앤 드롭하면 미디어 파일을 찾고, 중복 탐지 및 인덱싱 파이프라인으로 전달한다.

### 입력

- 파일 URL 배열
- 폴더 URL 배열

### 출력

- 등록 성공 개수
- 중복 제외 개수
- 실패 개수
- 분석 대기열

### 처리 흐름

    Drop URLs
      ↓
    Resolve file/folder
      ↓
    Recursive media scan
      ↓
    Create import candidates
      ↓
    Duplicate check
      ↓
    Metadata extraction
      ↓
    DB insert/update
      ↓
    Background analysis queue
      ↓
    UI result summary

### v1.0 정책

- 원본 파일은 이동하지 않는다.
- 기본 저장 모드는 소프트 링크이다.
- 폴더는 재귀 스캔한다.
- 지원하지 않는 파일은 무시한다.
- 중복 파일은 기본적으로 등록하지 않는다.

---

## 3.2 Duplicate Detection 모듈

### 역할

등록 시점과 사용자가 명시적으로 실행하는 전체 재검사 시점에 중복 파일을 감지한다.

중복 탐지는 두 가지 축으로 나뉜다.

1. 등록 시 자동 중복 탐지
2. 설정/도구에서 실행하는 전체 중복 재검사

### 중복 유형

#### 경로 중복

이미 등록된 동일 경로가 다시 입력된 경우이다.

처리:

- 재등록하지 않는다.
- 기존 에셋을 표시한다.
- 사용자가 원하면 변경 사항만 재스캔한다.

#### 내용 중복

경로는 다르지만 파일 내용이 같은 경우이다.

처리:

- 동일 내용 중복으로 표시한다.
- 기본값은 신규 등록 제외이다.
- 사용자가 별도 등록 또는 기존 에셋 위치 추가를 선택할 수 있다.

### 탐지 기준

1차 빠른 체크:

- 동일 경로
- 파일 크기
- 확장자
- 수정일

2차 후보 체크:

- 부분 해시
  - 파일 앞 8KB
  - 파일 중간 8KB
  - 파일 끝 8KB

3차 정확한 체크:

- 전체 해시

### 구현 메모

대용량 영상 파일의 전체 해시 계산은 비용이 크므로 즉시 계산하지 않는다.

`DuplicateDetectionService`는 다음 값을 분리해서 관리한다.

- `quickFingerprint`
- `partialHash`
- `fullHash`
- `hashStatus`

전체 해시는 중복 후보가 발견된 경우 백그라운드에서 계산한다.

### 전체 중복 재검사

전체 중복 재검사는 설정 또는 도구 메뉴에서 실행한다.

    Settings
      → Library / Storage
      → Scan Duplicates

또는:

    Tools
      → Find Duplicates

검사 범위:

- 전체 라이브러리
- 특정 폴더/저장소
- 특정 카테고리/프로젝트

### 설계 원칙

- 등록 시 검사는 빠르게 수행한다.
- 전체 재검사는 사용자가 명시적으로 실행한다.
- 대량 재검사는 백그라운드 Task에서 수행한다.
- 원본 파일은 자동 삭제하지 않는다.
- 삭제/정리 결정은 사용자가 한다.

## 3.3 Metadata Extraction 모듈

### 역할

파일의 기본 정보를 추출하여 Asset DB에 저장한다.

### 추출 대상

- 파일명
- 원본 경로
- 확장자
- MIME/UTType
- 파일 크기
- 생성일/수정일
- 등록일
- 오디오/영상 길이
- 해상도(영상/이미지)
- 샘플레이트/채널 수(오디오)

### 사용 후보 프레임워크

- Foundation
- UniformTypeIdentifiers
- AVFoundation
- ImageIO

---

## 3.4 Tag / Category 모듈

### 역할

에셋에 논리적 의미를 부여한다.

DizzyAsset의 태그/카테고리 시스템은 일반 파일 분류가 아니라 편집자 언어 기반 탐색을 목표로 한다.

### 개념

- Tag: 검색과 의미 부여를 위한 짧은 키워드
- Category: 사용자가 관리하는 논리적 묶음
- Project: 특정 편집 프로젝트와 연결되는 카테고리성 그룹

### 한글/영어 병기

태그와 카테고리는 한국어/영어 병기 구조를 지원한다.

예:

    예능/Funny
    긴장/Tension
    타격/Impact
    전환/Transition
    쇼츠/Shorts

DB 필드 후보:

    name_ko
    name_en
    normalized_name
    aliases

### 편집자 언어 사전

초기 추천 태그는 모델 출력에만 의존하지 않는다. 인터넷 기반 편집 문화, 숏폼/밈 편집 패턴, 효과음 라이브러리 naming convention, 한국어/영어 혼합 편집 용어를 기반으로 기본 사전을 구축한다.

AI 분석기는 분석 결과를 이 편집 언어 사전에 매핑한다.

### 카테고리 깊이

카테고리는 기본 2단계, 최대 3단계까지만 허용한다.

    기본: 2단계
    최대: 3단계

4단계 이상은 허용하지 않는다.

이유:

- 무제한 폴더 트리 방지
- 빠른 탐색 유지
- 편집자 중심의 얕은 의미 구조 유지

### 편집 가능 정책

사용자는 사용자 카테고리에 대해 다음 작업을 수행할 수 있다.

- 추가
- 이름 변경
- 이동
- 병합
- 삭제
- 순서 변경

시스템 카테고리는 기본값으로 제공하되, 사용자가 숨기거나 수정할 수 있는 범위는 별도 정책으로 관리한다.

### 정책

- 하나의 에셋은 여러 태그를 가질 수 있다.
- 하나의 에셋은 여러 카테고리에 속할 수 있다.
- 파일은 이동하지 않고 DB 관계만 추가한다.
- 중앙 리스트에서 여러 에셋을 선택한 뒤 왼쪽 카테고리로 드래그하면 관계가 생성된다.
- 카테고리 삭제는 원본 파일 삭제가 아니다.
- AI 추천 태그/카테고리는 기본적으로 suggested 상태로 저장하고, 사용자 승인 시 confirmed 상태로 변경한다.

## 3.5 Search 모듈

### 역할

파일명, 태그, 카테고리, 분석 텍스트를 대상으로 빠른 검색을 제공한다.

### v1.0 검색 범위

- 파일명
- 확장자
- 태그명
- 카테고리명
- 등록일 정렬
- 이름순 정렬

### 후속 검색 범위

- Speech 전사 텍스트
- Vision 분석 텍스트
- LLM 정규화 태그
- 유사 태그 검색

### 구현 후보

- SQLite FTS5
- 기본 LIKE 검색으로 시작 후 FTS 확장

---

## 3.6 Preview 모듈

### 역할

선택된 에셋을 Space 키로 즉시 미리듣기/미리보기한다.

### v1.0 범위

- 오디오 즉시 재생
- 영상 기본 미리보기
- Space: 재생/정지
- 방향키 이동 시 선택 에셋 변경
- 옵션에 따라 선택 이동 중 자동 재생

### 구현 후보

- AVFoundation
- AVAudioPlayer 또는 AVPlayer
- 썸네일/파형 캐시 후속 지원

### 성능 목표

- Space 입력 후 체감 지연 최소화
- 목록 이동 중 플레이어 재생 상태가 꼬이지 않아야 함

---

## 3.7 Quick Peek 모듈

### 역할

Final Cut Pro 작업 중 전역 단축키로 빠른 검색 패널을 띄운다.

### v1.0 범위

- 전역 단축키
- 작은 오버레이 패널
- 검색 입력
- 결과 목록
- 방향키 이동
- Space 미리듣기
- Esc 닫기

### 구현 후보

- AppKit NSPanel
- Global hotkey 등록
- SwiftUI view hosting

### 후속 범위

- Quick Peek에서 바로 Final Cut Pro로 드래그
- 최근 사용/즐겨찾기 우선 표시
- AI 추천 검색어

---

## 3.8 Final Cut Pro Integration 모듈

### 역할

DizzyAsset에서 찾은 에셋을 Final Cut Pro에서 바로 사용할 수 있게 한다.

### v1.0 범위

1. AssetList에서 Final Cut Pro 타임라인으로 파일 드래그
2. 실제 파일 URL 기반 drag item 제공
3. 소프트 링크 기반 라이브러리 연결 상태를 설정에서 표시

### 후속 범위

- Final Cut Pro 사운드 라이브러리 경로 자동 탐지
- DizzyAsset 관리 경로와 FCP 사운드 라이브러리 비교
- 소프트 링크 연결 제안
- 연결/해제/재생성
- Final Cut Pro 재시작 안내

---

## 3.9 Silence Detection 모듈

### 역할

오디오 파일 앞뒤의 무음 구간을 감지하고 상세 패널에 표시한다.

### v1.0 범위

- 앞 무음 길이 감지
- 뒤 무음 길이 감지
- 상세 패널 표시
- 원본 파일 수정 없음

### 후속 범위

- 트림 후 미리듣기
- 클린 버전 생성
- 대량 무음 제거
- 파일명 규칙 적용 (`_trimmed`, `_clean`)

### 구현 후보

- AVAssetReader
- PCM 샘플 분석
- RMS 또는 peak threshold 기반 감지

---

## 3.10 Analysis Provider 모듈

### 역할

파일명/폴더명 기반 분석, Apple 프레임워크, 로컬 LLM 등 분석 기능을 교체 가능한 구조로 제공한다.

### v1.0 포함

- FilenameAnalyzer
- FolderNameAnalyzer
- MetadataAnalyzer

### 후속 Provider

- SoundAnalysisProvider
- VisionAnalysisProvider
- SpeechAnalysisProvider
- LocalLLMProvider
- CloudLLMProvider

### 공통 인터페이스 개념

    AnalyzerProvider
      - canAnalyze(asset)
      - analyze(asset)
      - providerIdentifier
      - providerVersion

### 저장 원칙

분석 결과는 원본 결과와 정규화 결과를 모두 저장한다.

---

## 4. 데이터 저장 설계

## 4.1 저장 위치

DizzyAsset은 원본 파일, 앱 내부 데이터, 작업 공간을 분리한다.

### 원본 리소스

원본 파일은 사용자가 보관한 위치에 그대로 둔다.

    /Volumes/ExternalSSD/SFX/boom.wav
    ~/Downloads/meme_sound.mp3

DizzyAsset은 원본 파일을 이동하거나 수정하지 않는다.

### 앱 내부 데이터

앱의 데이터베이스, 설정, 북마크, 인덱스 정보는 macOS 표준 앱 데이터 위치에 저장한다.

    ~/Library/Application Support/DizzyAsset/

포함:

    Database/
    Settings/
    Index/
    Bookmarks/
    AIAnalysis/

역할:

- 앱 상태
- SQLite DB
- 설정
- Security-scoped bookmark
- 인덱싱 상태
- 내부 메타데이터

### DizzyAsset 작업 공간

DizzyAsset이 생성하는 작업본과 파생 리소스는 기본적으로 다음 위치에 저장한다.

    ~/DizzyAsset/

포함:

    Derived/
      Trimmed/
      Converted/
      Proxy/

    Generated/
      Preview/
      Export/

    Analysis/
      Waveforms/
      Speech/
      Vision/

    Temp/

### 작업 공간 변경

작업 공간은 설정에서 변경 가능하다.

변경 시 선택지:

    [기존 작업 공간 파일 이동]
    [새 위치만 사용]
    [취소]

### 원칙

- 원본 파일 위치와 앱 DB는 분리한다.
- 앱 내부 데이터는 Application Support에 둔다.
- 작업본/파생 리소스는 `~/DizzyAsset/`에 둔다.
- `~/DizzyAsset/`은 기본값이며 외장 SSD/NAS 등으로 이동 가능하다.
- DB 백업을 유지한다.

## 4.2 주요 테이블 초안

### assets

- id
- file_name
- file_extension
- original_path
- bookmark_data
- file_hash
- file_size
- media_type
- duration
- created_at
- modified_at
- imported_at
- last_seen_at
- is_missing

### tags

- id
- name
- normalized_name
- color
- source
- created_at

### categories

- id
- name
- type
  - ai_suggested
  - user
  - project
  - smart_filter
- parent_id
- created_at
- updated_at

### asset_tags

- asset_id
- tag_id
- source
  - filename
  - folder
  - user
  - analysis
  - llm
- confidence
- is_confirmed
- created_at

### asset_categories

- asset_id
- category_id
- source
  - user_drag
  - ai_suggested
  - rule
- created_at

### asset_analysis

- id
- asset_id
- analyzer_type
- analyzer_version
- raw_result_json
- normalized_result_json
- confidence
- created_at

### asset_locations

- id
- asset_id
- path
- bookmark_data
- volume_identifier
- file_size
- modified_at
- last_seen_at
- status
  - available
  - missing
  - permission_denied
  - volume_offline

### asset_derivations

- id
- source_asset_id
- derived_asset_id
- derivation_type
  - silence_trim
  - normalized_volume
  - converted_format
  - proxy
- workspace_path
- created_at

### duplicate_scan_sessions

- id
- started_at
- finished_at
- scope
  - full_library
  - storage_location
  - category
  - project
- total_assets
- duplicate_candidates
- confirmed_duplicates
- needs_review


### import_sessions

- id
- started_at
- finished_at
- total_found
- total_imported
- total_duplicates
- total_failed

### import_failures

- id
- import_session_id
- path
- reason
- created_at

### app_settings

- key
- value_json
- updated_at

---

## 5. 파일 접근 및 보안

### 5.1 Bookmark 저장

macOS sandbox 환경을 고려하여 파일 접근 권한 유지를 위해 security-scoped bookmark 저장을 고려한다.

### 5.2 Missing File 처리

외장 드라이브 분리, 파일 이동, 삭제 등에 대응해야 한다.

상태:

- 정상
- 누락됨
- 권한 없음
- 외장 드라이브 미연결 추정

### 5.3 재연결 UX

후속 기능으로 누락 파일에 대해 경로 재연결 기능을 제공한다.

---

## 6. 주요 사용자 플로우

## 6.1 파일/폴더 등록 플로우

    파일/폴더 드롭
      ↓
    미디어 파일 스캔
      ↓
    중복 체크
      ↓
    메타데이터 추출
      ↓
    파일명/폴더명 태그 추천
      ↓
    DB 저장
      ↓
    리스트 표시
      ↓
    등록 결과 요약 표시

## 6.2 검색 및 미리보기 플로우

    검색어 입력
      ↓
    파일명/태그/카테고리 검색
      ↓
    결과 리스트 갱신
      ↓
    방향키로 선택 이동
      ↓
    Space 미리듣기

## 6.3 사용자 카테고리 드래그 태깅 플로우

    카테고리 생성
      ↓
    중앙 리스트에서 에셋 다중 선택
      ↓
    왼쪽 카테고리로 드래그
      ↓
    asset_categories 관계 추가
      ↓
    UI 태그/카테고리 표시 갱신

## 6.4 Final Cut Pro 사용 플로우

    DizzyAsset에서 에셋 검색
      ↓
    Space로 미리듣기
      ↓
    에셋을 Final Cut Pro 타임라인으로 드래그
      ↓
    실제 파일 URL 전달
      ↓
    Final Cut Pro에서 사용

---

## 7. 성능 설계

### 7.1 인덱싱

- 백그라운드 Task에서 처리
- UI block 방지
- 진행률/결과 요약 제공
- 대량 폴더 처리 시 batch insert 사용

### 7.2 검색

- v1.0은 기본 SQL 검색
- 에셋 수가 증가하면 FTS5 도입
- 태그/카테고리 join 최적화 필요

### 7.3 미리보기

- 선택 변경 시 이전 재생 정리
- 재생 객체 재사용 검토
- 자주 접근한 에셋 preload 검토

### 7.4 분석

- 인덱싱과 분석을 분리
- 빠른 태그 추천은 즉시 처리
- 무거운 분석은 background queue 처리

---

## 8. 에러 처리

### 8.1 Import 오류

- 지원하지 않는 파일
- 접근 권한 없음
- 손상된 파일
- 메타데이터 추출 실패
- 해시 계산 실패

### 8.2 Preview 오류

- 파일 없음
- 포맷 미지원
- 권한 없음

### 8.3 Final Cut Pro Drag 오류

- 파일 URL 전달 실패
- 원본 파일 누락
- 권한 없음

### 8.4 DB 오류

- DB 초기화 실패
- insert/update 실패
- migration 실패

---

## 9. 설정 설계

v1.0 설정은 최소 항목만 제공한다.

### 포함 항목

1. 에셋 추가 기본 동작
   - 원본 위치 유지
   - 복사 모드
2. 중복 처리
   - 자동 건너뛰기
   - 확인 후 처리
3. 미리보기
   - Space 미리보기
   - 선택 이동 시 자동 재생
4. 분석 수준
   - 기본 분석
   - 확장 분석 준비
5. Final Cut Pro 연동 상태
6. 캐시/DB 관리
7. Quick Peek 전역 단축키

---

## 10. OS / 배포 전략

### 최소 지원

- macOS 13 Ventura

### 주요 QA 대상

- macOS 15 Sequoia
- macOS 26 Tahoe

### 전략

- 기본 기능은 macOS 13 이상에서 동일하게 동작해야 한다.
- 고급 AI/분석 기능은 OS 및 하드웨어 지원 여부에 따라 점진적으로 활성화한다.
- Apple Silicon 환경에서 성능 최적화를 우선한다.

---

## 11. v1.0 개발 범위

### 필수 구현

1. 프로젝트 기본 구조
2. SQLite 초기화 및 마이그레이션 구조
3. 파일/폴더 드래그 앤 드롭
4. 미디어 파일 스캔
5. 중복 탐지
6. Asset DB 저장
7. 기본 3단 UI
8. 중앙 리스트
9. 검색/정렬
10. 태그/카테고리 기본 구조
11. 드래그 태깅
12. Space 미리보기
13. Quick Peek 기본형
14. Final Cut Pro 파일 드래그
15. 무음 감지 표시
16. 설정 기본 화면

### 후속 구현

1. 고급 LLM 자동분류
2. Sound Analysis 기반 태그 추천
3. Vision/Speech 전체 분석
4. 클린 파일 생성
5. 대량 무음 제거
6. Final Cut Pro 사운드 라이브러리 자동 연결
7. 유사 에셋 추천

---

## 12. 작업 분해 준비

다음 단계에서는 본 설계 문서를 기준으로 작업을 다음 단위로 분해한다.

- Epic
- Feature
- Task
- Acceptance Criteria
- Dependencies
- Risk

우선 Epic 후보:

1. App Foundation
2. Database & Persistence
3. Asset Import & Indexing
4. Search & Filtering
5. Tag / Category System
6. Preview Engine
7. Quick Peek
8. Final Cut Pro Integration
9. Silence Detection
10. Preferences
11. QA / Compatibility

---

## 13. v1.3 설계 업데이트 요약

### 반영 내용

- 기본 작업 공간을 `~/DizzyAsset/`으로 확정
- Application Support와 Workspace 역할 분리
- Workspace 이동 가능 정책 추가
- 중복 탐지를 등록 시 자동 탐지와 전체 재검사로 분리
- 경로 중복과 내용 중복을 구분
- 부분 해시 + 전체 해시 구조 반영
- 편집자 언어 기반 한국어/영어 태그 구조 반영
- 카테고리 기본 2단계, 최대 3단계 제한 반영
- 사용자 카테고리 편집/이동/병합/삭제/정렬 정책 반영
- asset_locations, asset_derivations, duplicate_scan_sessions 테이블 후보 추가
