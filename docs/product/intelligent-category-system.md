# Intelligent Category System Design Proposal

**Status:** Draft / Discussion
**Task ID:** DA-012 (Redesign)
**Date:** 2026-05-08

## 1. Vision & Objective
The DizzyAsset Category System aims to eliminate the friction between asset collection and retrieval. By combining Apple's native machine learning frameworks with a pro-editor-centric taxonomy, it ensures that creators spend less time organizing and more time editing.

---

## 2. Standard Taxonomy (3-Level Depth)
This structure is automatically seeded on first launch to provide immediate organization for Final Cut Pro (FCP) and other NLE workflows.

### 🎬 VISUALS
- **Footage** (Raw recording & main sources)
- **Memes** (Internet culture and reaction clips)
    - *Reactions*
    - *Funny*
    - *Loops*
- **Overlays** (Visual effects)
    - *Light & Particles*
    - *Transitions*

### 🎵 AUDIO
- **BGM** (Background music)
    - *Cinematic*
    - *Happy/Vlog*
    - *Lofi/Chill*
- **SFX** (Sound effects)
    - *Impacts/Hits*
    - *Transitions*
    - *Ambiance*
- **Voice** (Vocals and dialogue)

### 🎨 GRAPHICS
- **Titles** (Lower thirds and text templates)
- **Images** (Static assets)
    - *Photos*
    - *Logos/Icons*
    - *Vectors*
- **Elements** (Design backgrounds and textures)

---

## 3. Sidebar UX & Interaction Design
사이드바는 정적인 목록이 아니라, 자산 관리의 모든 명령이 이루어지는 **'액티브 컨트롤 센터'** 역할을 수행합니다.

### 🖱️ 핵심 인터랙션
- **인라인 편집 (Inline Editing)**: 카테고리 이름을 클릭하거나 Enter 키를 눌러 즉시 이름을 변경할 수 있습니다.
- **계층 간 이동 (Category Reordering)**: 카테고리 자체를 드래그 앤 드롭하여 부모-자식 관계를 변경하거나 순서를 바꿀 수 있습니다 (3단계 깊이 제한 내).
- **컨텍스트 메뉴 (Context Menu)**:
    - `Add Sub-Category`: 선택한 항목 하위에 새 폴더 생성.
    - `Set as Default`: 다음 가져오기 시 AI 분석 전 임시 저장소로 지정.
    - `Clear Inbox Items`: Inbox에 있는 모든 자산을 현재 카테고리로 강제 이동.

### 👁️ 시각적 피드백
- **Drop-Target Highlighting**: 자산을 드래그하여 사이드바 위로 가져가면, 대상 카테고리가 밝게 강조되며 하위 폴더가 자동으로 확장(Auto-expand)됩니다.
- **AI Recommendation Badge**: AI 분석을 통해 특정 카테고리가 추천될 경우, 해당 카테고리 옆에 부드러운 'Glow' 효과나 숫자가 포함된 배지를 표시합니다.
- **Empty State Guide**: 카테고리가 비어 있을 경우 "여기로 드래그하여 분류 시작"과 같은 마이크로 카피를 제공합니다.

---

## 4. Core Features

### 📥 Smart Inbox (Uncategorized)
- A dedicated "landing zone" for all newly imported or uncategorized assets.
- Support for **Bulk Management**: Select multiple assets from the Inbox and drag them to a category in the Sidebar for rapid organization.

### 🤖 Intelligent Matching (AI-Driven)
- **Vision Framework**: Automatic scene classification and object detection to identify Memes, Footage types, and Graphic elements.
- **SoundAnalysis Framework**: Classification of audio files into BGM vs. SFX. Detection of specific sound events (e.g., laughter, clapping) to suggest sub-categories.
- **Integration**: The Import Pipeline triggers analysis asynchronously, tagging assets or suggesting categories in real-time.

### 🔍 FTS5 Search Integration
- Categories are indexed as first-class citizens in the Full-Text Search (FTS5) engine.
- Searching "Cinematic" will return results matching the filename, tags, AND assets within the "Cinematic" category.

---

## 4. Technical Implementation Roadmap

1. **Phase 1: Zero-Config Seeding**
   - Implement `seedDefaultCategories()` in `CategoryService`.
   - Update `DatabaseManager` to trigger seeding if the category table is empty.

2. **Phase 2: Bulk Drag & Drop**
   - Update Sidebar to handle multi-asset drop payloads.
   - Implement `batchAssignCategory` in the persistence layer.

3. **Phase 3: Apple AI Integration**
   - Wire `Vision` and `SoundAnalysis` into the `AssetImportService` pipeline.
   - Implement "Suggested Category" UI indicators in the Sidebar.

---

## 5. UI/UX Principles
- **Visual Cues**: SFSymbols (🎬, 🎵, 🎨) for instant category recognition.
- **Dynamic Feedback**: Visual highlighting of target categories during drag-and-drop.
- **Minimal Effort**: Prioritize auto-classification to keep the Inbox clean without user intervention.
