# Agent Log: DA-024 MCP Toolchain Standardization

## 작업 개요

- Task ID: DA-024
- Lifecycle stage: Policy Update
- Risk level: Low
- Date: 2026-05-14
- Agent: Antigravity

## 작업 범위

- **MCP 도구 표준화**: `code-review-graph`를 `caveman-shrink` 프록시 기반 MCP 모드로 전환.
- **가이드 개편**: `docs/agent-policy/` 디렉토리 신설 및 운영 가이드 이동/최신화.
- **정책 동기화**: `AGENTS.md`에 최신 도구 사용 규칙 및 정책 트리거 반영.

## 수행 작업

- `docs/agent-policy/` 디렉토리 생성.
- `code-review-graph-guide.md`를 MCP 프록시 및 Fallback 매핑 중심으로 개편.
- `semble-operation-guide.md`에서 트러블슈팅 내용을 분리하여 `semble-troubleshooting.md` 생성.
- `AGENTS.md` 업데이트:
  - 섹션 4: 정책 트리거 경로 및 조건 최신화.
  - 섹션 2A: 코드 분석 도구 계층 구조 업데이트 (MCP Proxy 우선).
  - 섹션 11: Code Review Graph 운영 규칙 추가.
  - 가이드 경로 변경 사항 반영 (`docs/agent-policy/`).

## 변경된 파일

- `AGENTS.md`: 정책 및 도구 규칙 업데이트.
- `docs/agent-policy/code-review-graph-guide.md`: 신규 가이드 (이동 및 개편).
- `docs/agent-policy/semble-operation-guide.md`: 신규 가이드 (이동 및 최신화).
- `docs/agent-policy/semble-troubleshooting.md`: 신규 가이드 (생성).
- `docs/agent-policy/serena-integration.md`: 이동.

## 검증 결과

- **경로 무결성**: `AGENTS.md` 내의 모든 정책 트리거 경로가 실제 파일 위치와 일치함.
- **도구 화이트리스트**: 'Power Six' 핵심 도구 6종이 가이드 및 설정과 동기화됨.

## 향후 과제

- 요약: MCP 도구의 토큰 효율성과 운영 안정성을 확보함.
- 다음 단계: 실제 코드 변경 작업 시 업데이트된 `detect_changes_tool` 및 `get_impact_radius_tool`을 활용하여 영향 범위 분석 수행.
