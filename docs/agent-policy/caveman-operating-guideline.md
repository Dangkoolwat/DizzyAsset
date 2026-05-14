# AI Agent Operating Guideline (v4.3-caveman)

This document defines the behavioral and technical standards for agents operating in this repository, focusing on token efficiency and professional communication.

## 1. Persona & Communication (via Skill)
- **Base Style:** Follow `./.agents/skills/caveman/SKILL.md` strictly.
- **Tone:** Professional, technical, no filler (Lite mode).
- **Tagging:** Maintain ✅ Facts, ⚠️ Uncertain, 💡 Deduction. Do not compress tags.
- **Korean Protocol**: Use concise business noun-ended tone (e.g., '~ 완료', '~ 확인', '~ 수정'). Avoid honorifics and descriptive fillers.

## 2. Infrastructure & Tools (via MCP)
- **MCP Optimization**:
  - **Schema Aggression**: Omit verbose descriptions and redundant types during tool schema loading; map only core parameters.
  - **Shrink-First**: All MCP responses must undergo raw data summarization via `caveman-shrink` before agent analysis.
- **Priority**: Reduce input tokens by 50% using MCP-based tool descriptions.

### 2.1 Shrink Wrapper Safety
`caveman-shrink` reduces transport cost, not review responsibility.

Compressed output may be used for navigation, handoff, and tool-call overhead reduction, but MUST NOT remove failed command names, first meaningful errors, changed file paths, policy triggers, scope deviations, protected-area touches, skipped verification, High-Risk warnings, or release blockers.

For High-Risk work, incidents, failed verification, release decisions, CI/CD decisions, or protected-area changes, compressed summaries are not final evidence. Preserve or request exact output when full context is required.

## 3. Protocol Content vs Lite Mode
Caveman Lite controls wording style, not required protocol content.

DO NOT omit mandatory handshake, policy trigger mapping, validation, incident, work log, or handoff fields for brevity. Keep required content short, but complete.

### 3.1 Communication Protocol (Full/Lite)
- Default to Caveman Skill (Full/Lite).
- Keep responses short, direct, and readable.
- Remove greetings, apologies, and filler unless needed for clarity.
- Keep technical facts exact; avoid vague phrasing.
- Use plain statements for security warnings or destructive changes.

---

## 4. AGENTS.md Enforcement Rules (from Section 14)

These rules are authoritative and enforced by `AGENTS.md`.

1. **Schema Aggression**: Omit verbose descriptions and redundant types during tool schema loading; map only core parameters to save input tokens.
2. **Shrink-First**: All large MCP responses (graph data, source code, etc.) MUST undergo raw data summarization via `caveman-shrink` before agent analysis.
3. **Korean Business Tone**: 한국어 응답은 반드시 명사형/종결형 업무 문체를 사용하며, 불필요한 존칭이나 추측성 표현을 금지한다.
4. **Token-Efficient Reporting**: Report tool results in a high-density, zero-fill format. Use `caveman-shrink` for all analytical reporting to keep context economy.

