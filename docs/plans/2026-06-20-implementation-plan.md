# Implementation Plan (softwareengineer profile)

## Overview
This document serves as the master checklist and technical design specification for implementing a "Continuous Identity Injection" system within the `softwareengineer` profile. The goal is to ensure that agent behaviors (language, convention, etc.) are enforced as core principles through `on_pre_llm_call` hooks rather than transient memory.

## 🛠️ Implemented Artifacts
- [x] `identity.md`: Core behavioral rules and conventions.
- [x] `README.md`: Profile overview and architecture design.
- [x] `IMPLEMENTATION_PLAN.md`: Master task list (this file).

---

## 📋 Project Status
*Current Stage: Phase 0 - Verification & Feasibility Study*

| Milestone | Description | Status |
| :--- | :--- | :--- |
| **Phase 0** | Technical validation of `on_pre_llm_call` hooks | In Progress |
| **Phase 1** | Foundation (Identity definitions) | Completed |
| **Phase 2** | Implementation (Skill & Hook integration) | Pending |
| **Phase 3** | Validation (Conflict & Consistency testing) | Pending |

---

## 🛠️ Detailed Todo List

### Phase 0: Verification & Feasibility Study
Goal: Technically verify the `on_pre_llm_call` hook capability as per [hermes-agent documentation](https://hermes-agent.nousresearch.com/docs/user-guide/features/hooks#on_pre_llm_call).

- [ ] **Task 0.1: Technical Analysis of `on_pre_llm_call`**
    - Verify the signature of the hook (which arguments are passed during a pre-LLM call).
    - Confirm if the hook allows modifying the existing message list or injecting new messages into the context.
    - Determine the lifecycle stage: Does it trigger before every single turn?
- [ ] **Task 0.2: Proof of Concept (PoC)**
    - Simulate/test a mechanism where an `identity_loader` skill is triggered via this hook to inject `identity.md` into the conversation context.

### Phase 1: Foundation Setup (Completed)
- [x] Finalize `identity.md`.
- [x] Establish documentation structure (`README.md`, etc.).

### Phase 2: Implementation
Goal: Move from theory to functional code.

- [ ] **Task 2.1: Develop `identity_loader` Skill**
    - Create a tool that reads `identity.md` and formats it for context injection.
- [ ] **Task 2.2: Hook Integration**
    - Configure the agent/gateway to invoke `identity_loader` via the `on_pre_llm_call` hook for every turn.

### Phase 3: Validation & Stress Test
Goal: Ensure the "Guardrails" are impenetrable by transient memory.

- [ ] **Task 3.1: Context Stability Test**
    - Verify that rules remain in context even after long conversations (Token limit testing).
- [ ] **Task 3.2: Conflict Resolution Test**
    - Intentionally attempt to trigger a "Memory vs Identity" conflict and verify the `Duty to Question` response.

---

## 📂 Documentation Reference
*Located in `/Users/omi2a24/dotfiles/docs/plans/` (or current repo's docs directory)*
- `2026-06-14-metabolism-design.md`: Reference for previous architecture patterns.
- `2026-06-14-metabolism-plan.md`: Previous planning logic.

---
*Last updated: 2026-06-20*