# 🚀 Serena Integration & Operation Guide

본 가이드는 신규 프로젝트에 **Serena(LSP 기반 Semantic Agent)**를 도입하고, AI 에이전트가 코드의 맥락을 완벽하게 이해하도록 설정하는 표준 절차를 정의합니다.

---

## 1. 초기 도입 단계 (Setup Phase)

새로운 프로젝트에서 Serena를 활성화할 때 에이전트에게 다음 프롬프트를 전달하세요.

### 📥 도입 프롬프트
> "이 프로젝트에 Serena MCP를 도입하려고 해. 먼저 프로젝트를 활성화(`activate_project`)하고, 온보딩(`onboarding`) 프로세스를 실행해서 현재 프로젝트의 기술 스택과 아키텍처 핵심 정보를 `memories`에 저장해줘."

### ✅ 체크리스트
- [ ] `activate_project` 실행 및 경로 확인
- [ ] `onboarding` 도구를 통한 프로젝트 성격 정의
- [ ] `.serena/memories/` 폴더 생성 확인

---

## 2. 공유 및 협업 설정 (Collaboration)

팀원들과 Serena의 지식을 공유하기 위해 Git 관리가 필요합니다.

### 📦 Git 포함 대상
- `.serena/project.yml`: 프로젝트 공통 설정
- `.serena/memories/`: 프로젝트 지식 베이스 (Markdown)

### 🚫 Git 제외 대상 (`.serena/.gitignore`)
- `/cache`: 로컬 인덱싱 데이터
- `/project.local.yml`: 개인별 경로 설정
- `/logs`: 실행 로그

---

## 3. 강력한 성능을 위한 프롬프트 전략 (Advanced Prompting)

작업 시 에이전트가 Serena의 기능을 200% 활용하게 만드는 지시어 예시입니다.

### 🔍 정밀 분석 요청
> "단순히 파일 전체를 읽지 말고, Serena의 `find_symbol`과 `find_referencing_symbols`를 사용해서 [함수/클래스명]의 구현부와 실제 호출되는 모든 위치를 분석한 뒤 영향 범위를 보고해줘."

### 🛠 안전한 리팩토링 요청
> "Serena의 `rename_symbol` 기능을 사용해서 [기존이름]을 [새이름]으로 변경해줘. 이때 단순 텍스트 치환이 아닌 LSP 기반으로 타입 안전성을 보장하며 모든 참조를 업데이트해야 해."

### 🧠 지식 업데이트 요청 (작업 완료 후)
> "이번에 구현한 [기능명]의 핵심 로직과 설계 결정을 Serena `write_memory` 도구를 사용해서 기록해줘. 나중에 다른 에이전트가 이 코드를 수정할 때 참고할 수 있도록."

---

## 4. 에이전트 운영 원칙 (Operating Rules)

본 프로젝트의 `AGENTS.md`와 연동하여 다음 규칙을 적용합니다.

1. **Precision First**: 오타 수정이나 단순 텍스트 변경 외의 모든 **Non-trivial** 작업은 Serena의 심볼 분석을 우선 수행한다.
2. **Memory-Driven**: 새로운 아키텍처 결정이나 복잡한 비즈니스 로직 수정 시 반드시 `memories`에 기록을 남긴다.
3. **Zero Assumption**: 코드를 읽기 전 Serena의 `get_symbols_overview`를 통해 파일 구조를 먼저 파악한다.

---

## 5. 트러블슈팅

- **"No active project" 에러 발생 시**: 에이전트에게 `list_repos`로 등록 여부를 확인하게 한 뒤, `activate_project`를 다시 명령하세요.
- **분석 속도가 느릴 경우**: `get_symbols_overview`의 `depth`를 조정하거나 특정 디렉토리로 범위를 좁히도록 지시하세요.

---

## 6. MCP Optimization Rules (from AGENTS.md Section 10)

These rules are authoritative and enforced by `AGENTS.md`.

1. **Precision First**: All **Non-trivial** tasks MUST follow the **3-Stage Exploration Pipeline** (`docs/agent-policy/3-stage-pipeline.md`).
2. **Memory-Driven**: Core architectural decisions and complex logic explanations MUST be recorded in Serena `memories` using `write_memory`.
3. **MCP Tool Whitelist**:
   - Retain ONLY the following tools; all others MUST be set as `disabledTools`:
     - **Read-only (Stage 2 analysis):** `get_symbols_overview`, `find_symbol`, `find_referencing_symbols`, `search_for_pattern`
     - **Write (Stage 3 implementation):** `replace_symbol_body`, `rename_symbol`
   - **Other Analysis Tools**: Remove from MCP list and utilize via CLI (`run_command`) only.
4. **LSP-Safe Refactoring**: Use `rename_symbol` to ensure type-safe changes across the entire codebase.

