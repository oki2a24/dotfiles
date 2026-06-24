# 🧬 metabolism Implementation Plan

Date: 2026-06-23

Version: v2.1

Status: Draft

---

# 1. Purpose

本ドキュメントは metabolism を実装するための実行計画を定義する。

対象:

- Observer
- Philosopher
- Architect
- Historian
- Apoptosis

本バージョンでは、

```text
失敗
↓
分析
↓
改善
↓
パターン化
↓
統合
↓
忘却
```

を実現する。

---

# 2. Design Strategy

実装は以下の順序で行う。

```text
Phase 1
Contract Layer

Phase 2
Core Layer

Phase 3
Observer

Phase 4
Philosopher

Phase 5
Architect

Phase 6
Historian

Phase 7
Apoptosis

Phase 8
Storage

Phase 9
Integration

Phase 10
End-to-End Test
```

---

# 3. Architecture

```text
Observer
↓
MetabolicEvent

Philosopher
↓
RootCause

Architect
↓
ActionPlan

Historian
↓
PatternRecord

Apoptosis
↓
ObsolescenceDecision
```

---

# 4. Phase 1: Contract Layer

## Goal

Data Contract の実装。

---

## Deliverables

```text
contracts/

metabolic_event.py
root_cause.py
action_plan.py
pattern_record.py
obsolescence_decision.py
```

---

## Implementation

### DTO

実装する。

### Serializer

実装する。

### Deserializer

実装する。

### Validator

実装する。

---

## Definition of Done

- DTO完成
- JSON往復成功
- Validation成功

---

# 5. Phase 2: Core Layer

## Goal

共通機能を実装する。

---

## Deliverables

```text
core/

id_generator.py
timestamp_provider.py
contract_validator.py
enums.py
```

---

## Definition of Done

- UUID生成
- Timestamp生成
- Contract Validation成功

---

# 6. Phase 3: Observer

## Goal

異常検知。

---

## Responsibilities

実施すること:

- イベント検出
- severity判定

禁止:

- 分析
- 改善提案

---

## Deliverables

```text
observer/

event_detector.py
severity_classifier.py
observation_factory.py
observer.py
```

---

## Input

```text
terminal output
user feedback
system event
```

---

## Output

```text
MetabolicEvent
```

---

## Definition of Done

- MetabolicEvent生成成功
- severity分類成功

---

# 7. Phase 4: Philosopher

## Goal

原因分析。

---

## Responsibilities

実施すること:

- dimension分類
- cause_type分類
- confidence計算

禁止:

- 実行
- 修正

---

## Deliverables

```text
philosopher/

dimension_classifier.py
cause_type_classifier.py
confidence_calculator.py
root_cause_factory.py
philosopher.py
```

---

## Output

```text
RootCause
```

---

## Definition of Done

- dimension決定成功
- cause_type決定成功
- confidence生成成功

---

# 8. Phase 5: Architect

## Goal

改善計画生成。

---

## Responsibilities

実施すること:

- action選択
- priority算出
- risk評価

禁止:

- ファイル編集
- 実行

---

## Deliverables

```text
architect/

action_selector.py
priority_calculator.py
risk_assessor.py
action_plan_factory.py
architect.py
```

---

## Output

```text
ActionPlan
```

---

## Definition of Done

- ActionPlan生成成功

---

# 9. Phase 6: Historian

## Goal

改善パターン蓄積。

---

## Important

Historian は履歴保管庫ではない。

Historian は

```text
経験
↓
抽象化
↓
パターン化
```

を担当する。

---

## Responsibilities

実施すること:

- Pattern探索
- Pattern更新
- Pattern生成

禁止:

- Pattern削除
- Forget判定

---

## Deliverables

```text
historian/

pattern_matcher.py
pattern_repository.py
pattern_updater.py
pattern_factory.py
historian.py
```

---

## Internal Flow

```text
ActionPlan
↓
PatternMatcher

既存Pattern発見
↓
PatternUpdate

未発見
↓
PatternCreate
```

---

## Output

```text
PatternRecord
```

---

## Definition of Done

- Pattern更新成功
- Pattern新規作成成功
- observed_count更新成功
- success_rate更新成功

---

# 10. Phase 7: Apoptosis

## Goal

統合と忘却。

---

## Important

Apoptosis は削除機能ではない。

知識の整理機能である。

---

## Responsibilities

実施すること:

- Merge候補検出
- Retire候補検出

禁止:

- 自動削除
- 自動統合

---

## Deliverables

```text
apoptosis/

merge_evaluator.py
retire_evaluator.py
decision_engine.py
decision_factory.py
apoptosis.py
```

---

## Decision Types

```text
keep
merge
retire
```

---

## Output

```text
ObsolescenceDecision
```

---

## Definition of Done

- Merge判定成功
- Retire判定成功

---

# 11. Phase 8: Storage

## Goal

JSONベース保存。

---

## Directory Structure

```text
.history/

events/
root_causes/
actions/
patterns/
decisions/
```

---

## Storage Rules

1ファイル = 1レコード

---

## Example

```text
.history/patterns/

dependency_validation.json
```

---

## Future Migration

将来以下へ移行可能。

- SQLite
- PostgreSQL
- Vector DB

Contract変更は禁止。

---

# 12. Phase 9: Integration

## Goal

全コンポーネント統合。

---

## Deliverables

```text
metabolism/

pipeline.py
orchestrator.py
```

---

## Flow

```text
Observer
↓
Philosopher
↓
Architect
↓
Historian
↓
Apoptosis
```

---

## Definition of Done

- 全Contract接続成功
- 型不整合ゼロ

---

# 13. Phase 10: End-to-End Test

## Goal

実運用シナリオ検証。

---

## Scenario 1

### Input

```text
ModuleNotFoundError
```

---

### Expected Pattern

```text
dependency_validation
```

---

## Scenario 2

### Input

```text
Instruction Misread
```

---

### Expected

```text
dimension=cognitive
```

---

## Scenario 3

### Input

```text
Poor Task Split
```

---

### Expected

```text
dimension=operational
```

---

## Scenario 4

### Input

複数の ImportError

---

### Expected

```text
Pattern Merge
```

---

## Scenario 5

### Input

200日以上未使用パターン

---

### Expected

```text
retire candidate
```

---

# 14. Non-Functional Requirements

## Deterministic

同じ入力なら同じ出力。

---

## Testable

全コンポーネントが単体テスト可能。

---

## Explainable

判定理由を出力できる。

---

## LLM Friendly

以下を禁止する。

- 深い継承
- 複雑なDI
- 過度な抽象化

---

# 15. Completion Criteria

以下を満たした時点で v1 完了。

- Contract Layer完成
- Core Layer完成
- Observer完成
- Philosopher完成
- Architect完成
- Historian完成
- Apoptosis完成
- Storage完成
- Integration成功
- E2E成功
- ドキュメント更新完了
