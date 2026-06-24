#🧬 metabolism API Specification

Date: 2026-06-23

Version: v1.1

Status: Draft

---

# 1. Purpose

本ドキュメントは metabolism を構成する各コンポーネントの API 契約を定義する。

対象コンポーネント:

- Observer
- Philosopher
- Architect
- Historian
- Apoptosis

目的:

- コンポーネント責務の固定
- 入出力契約の固定
- 実装者ごとの差異の抑制
- ローカルLLMによる推測実装の防止

---

# 2. System Flow

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

# 3. Common Rules

## Rule-C01

全APIは Contract Specification v1.2 に準拠する。

---

## Rule-C02

全APIは副作用を最小化する。

---

## Rule-C03

コンポーネントは後続コンポーネントを知らない。

例:

Observer は Philosopher を知らない。

---

## Rule-C04

コンポーネント間通信は必ず Contract を経由する。

直接オブジェクト参照は禁止。

---

# 4. Observer API

## Responsibility

異常・失敗・逸脱を検知する。

分析は禁止。

改善提案は禁止。

---

## Input

```json
{
  "source": "terminal",
  "payload": "pytest failed"
}
```

---

## API

```python
observe(
    source: str,
    payload: str
) -> MetabolicEvent
```

---

## Output

```json
{
  "event_id": "uuid",
  "severity": "medium",
  "summary": "pytest failed"
}
```

---

## Preconditions

- source が存在する
- payload が存在する

---

## Postconditions

- event_id が生成される
- timestamp が付与される

---

## Error Behavior

```text
InvalidObservationError
```

---

# 5. Philosopher API

## Responsibility

MetabolicEvent を分析し、

RootCause を生成する。

修正は禁止。

実行は禁止。

---

## Input

```json
MetabolicEvent
```

---

## API

```python
analyze(
    event: MetabolicEvent
) -> RootCause
```

---

## Output

```json
{
  "root_cause_id": "uuid",
  "dimension": "mechanical",
  "cause_type": "missing_dependency",
  "confidence": 0.87
}
```

---

## Preconditions

- event_id が存在する

---

## Postconditions

- root_cause_id が生成される
- confidence が設定される

---

## Error Behavior

```text
AnalysisFailedError
```

---

# 6. Architect API

## Responsibility

RootCause から改善計画を生成する。

実行は禁止。

ファイル編集は禁止。

---

## Input

```json
RootCause
```

---

## API

```python
design(
    root_cause: RootCause
) -> ActionPlan
```

---

## Output

```json
{
  "action_id": "uuid",
  "action_type": "patch",
  "priority": "medium"
}
```

---

## Preconditions

- root_cause_id が存在する

---

## Postconditions

- action_id が生成される

---

## Error Behavior

```text
PlanningFailedError
```

---

# 7. Historian API

## Responsibility

個別履歴を保存するのではなく、

改善パターンを蓄積する。

---

## Concept

Historian は以下を行う。

```text
Action
↓
Pattern Matching
↓
Pattern Update
```

既存パターンが存在する場合:

```text
Pattern更新
```

存在しない場合:

```text
Pattern新規作成
```

---

## Input

```json
{
  "event": "MetabolicEvent",
  "root_cause": "RootCause",
  "action_plan": "ActionPlan",
  "execution_result": "success"
}
```

---

## API

```python
update_pattern(
    event: MetabolicEvent,
    root_cause: RootCause,
    action_plan: ActionPlan,
    execution_result: str
) -> PatternRecord
```

---

## Output

```json
{
  "pattern_id": "uuid",
  "pattern_name": "dependency_validation",
  "observed_count": 17,
  "success_rate": 0.94
}
```

---

## Preconditions

- event_id が存在する
- root_cause_id が存在する
- action_id が存在する

---

## Postconditions

- PatternRecord が生成または更新される
- observed_count が更新される
- success_count が更新される
- success_rate が更新される

---

## Error Behavior

```text
PatternUpdateFailedError
```

---

# 8. Apoptosis API

## Responsibility

改善パターンを評価し、

統合または忘却を判断する。

---

## Input

```json
[
  "PatternRecord"
]
```

---

## API

```python
evaluate_patterns(
    patterns: List[PatternRecord]
) -> List[ObsolescenceDecision]
```

---

## Output

```json
[
  {
    "decision": "merge",
    "pattern_id": "uuid",
    "target_pattern": "environment_validation",
    "confidence": 0.92
  }
]
```

---

## Preconditions

- PatternRecord が存在する

---

## Postconditions

- Decision が生成される

---

## Error Behavior

```text
DecisionFailedError
```

---

# 9. Decision Rules

## keep

維持する。

条件例:

- 活発に利用されている
- success_rate が高い

---

## merge

他パターンへ統合する。

条件例:

- 改善内容が重複
- 同一目的

---

## retire

忘却対象。

条件例:

- 180日以上未使用
- success_rate が極端に低い

---

# 10. Pattern Matching Rules

Historian は新規 Pattern を無制限に生成してはならない。

以下の順序で判定する。

```text
既存Pattern探索
↓
類似Pattern発見
↓
更新

発見できない
↓
新規Pattern作成
```

---

# 11. Merge Rules

Apoptosis は以下を評価する。

- pattern_name
- root cause category
- action_type
- success_rate

---

類似性が高い場合:

```text
merge
```

を提案する。

---

# 12. Forgetting Rules

Apoptosis は以下を評価する。

## Rule-F01

180日以上未観測

---

## Rule-F02

success_rate < 0.30

---

## Rule-F03

統合済み

---

判定結果:

```text
retire
```

---

# 13. Forbidden Actions

## Observer

禁止:

- 原因分析
- 修正提案

---

## Philosopher

禁止:

- ファイル編集
- パッチ作成

---

## Architect

禁止:

- 実行
- ファイル編集

---

## Historian

禁止:

- 改善案生成
- パターン削除

---

## Apoptosis

禁止:

- 自動削除
- 自動統合
- 自動実行

---

# 14. Implementation Principle

各コンポーネントは

- Single Responsibility
- Contract First
- Testable
- Deterministic

を満たさなければならない。

すべての入出力は Contract Specification v1.2 に従う。
