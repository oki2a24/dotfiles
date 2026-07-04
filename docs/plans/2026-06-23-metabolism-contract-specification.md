# 🧬 metabolism Contract Specification

Date: 2026-06-23

Version: v1.2

Status: Draft

---

# 1. Purpose

本ドキュメントは metabolism を構成するコンポーネント間のデータ契約（Data Contract）を定義する。

本仕様の目的は以下である。

* コンポーネント間の責務を固定する
* ローカルLLMによる推測実装を防ぐ
* データ形式を標準化する
* 将来の進化と忘却を支える

---

# 2. Core Philosophy

metabolism は単なる自己改善システムではない。

目指すのは以下のサイクルである。

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

改善策を無限に増やすのではなく、

* 共通パターンへ統合する
* 古くなった知識を忘却する

ことを重視する。

---

# 3. Contract Flow

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

# 4. Design Principles

## Rule 1: Enum First

可能な限り列挙型を使用する。

自由記述は最小限とする。

---

## Rule 2: Flat Structure

深いネストは禁止。

シンプルな JSON を優先する。

---

## Rule 3: Stable IDs

全契約は UUID を持つ。

---

## Rule 4: Version Everything

全契約は contract_version を持つ。

---

# 5. Contract: MetabolicEvent

## Responsibility

異常・失敗・逸脱を検知した事実を表現する。

原因分析は禁止。

---

## Schema

```json
{
  "contract_version": "1.2",
  "event_id": "uuid",
  "timestamp": "2026-06-23T12:34:56Z",
  "source": "terminal",
  "severity": "medium",
  "summary": "pytest failed",
  "raw_input": "...",
  "model_name": "gemma4:26b",
  "environment": "local"
}
```

---

## source

* terminal
* user_correction
* system
* manual

---

## severity

* low
* medium
* high
* critical

---

# 6. Contract: RootCause

## Responsibility

MetabolicEvent の原因分析結果。

---

## Schema

```json
{
  "contract_version": "1.2",
  "root_cause_id": "uuid",
  "event_id": "uuid",
  "dimension": "mechanical",
  "cause_type": "missing_dependency",
  "confidence": 0.87,
  "summary": "依存ライブラリ不足",
  "evidence": [
    "ModuleNotFoundError"
  ],
  "recommendation": "requirements.txt を更新する"
}
```

---

## dimension

* mechanical
* cognitive
* operational

---

## cause_type

### mechanical

* test_failure
* build_failure
* missing_dependency
* runtime_error

### cognitive

* instruction_misread
* hallucination
* wrong_assumption

### operational

* missing_checklist
* missing_validation
* poor_task_split

---

# 7. Contract: ActionPlan

## Responsibility

原因に対する改善計画。

---

## Schema

```json
{
  "contract_version": "1.2",
  "action_id": "uuid",
  "root_cause_id": "uuid",
  "action_type": "patch",
  "target": "observer.py",
  "priority": "medium",
  "summary": "依存関係検証処理を追加",
  "rationale": "再発防止",
  "risk": "low",
  "estimated_effort": "small",
  "expected_outcome": "同種エラー削減"
}
```

---

## action_type

* patch
* write_file
* create_skill
* update_memory
* delete_skill
* create_test

---

## priority

* low
* medium
* high
* critical

---

## risk

* low
* medium
* high

---

## estimated_effort

* small
* medium
* large

---

# 8. Contract: PatternRecord

## Responsibility

改善パターンを表現する。

個別事象ではなく、

再利用可能な改善知識を保存する。

---

## Important

PatternRecord はエラー単位ではない。

以下は同じパターンとして扱う。

```text
ModuleNotFoundError
ImportError
```

↓

```text
dependency_validation
```

---

## Schema

```json
{
  "contract_version": "1.2",
  "pattern_id": "uuid",
  "pattern_name": "dependency_validation",
  "summary": "依存関係不足の事前検出",
  "observed_count": 17,
  "success_count": 16,
  "success_rate": 0.94,
  "first_seen": "2026-06-01T12:00:00Z",
  "last_seen": "2026-06-23T09:00:00Z",
  "status": "active",
  "related_action_types": [
    "patch",
    "create_test"
  ]
}
```

---

## status

* active
* retired

---

# 9. Contract: ObsolescenceDecision

## Responsibility

改善パターンの維持・統合・忘却を判断する。

---

## Schema

```json
{
  "contract_version": "1.2",
  "decision_id": "uuid",
  "pattern_id": "uuid",
  "decision": "merge",
  "target_pattern": "environment_validation",
  "reason": "改善内容が重複している",
  "confidence": 0.92
}
```

---

## decision

* keep
* merge
* retire

---

# 10. Forgetting Policy

## Rule-F01

180日以上観測されていないパターンは retire 候補。

---

## Rule-F02

success_rate < 0.30 のパターンは retire 候補。

---

## Rule-F03

他パターンへ統合済みのパターンは retire 候補。

---

## Rule-F04

retire は物理削除ではない。

status=retired として保持する。

---

# 11. Merge Policy

## Rule-M01

目的が同じ。

---

## Rule-M02

改善内容が重複している。

---

## Rule-M03

原因カテゴリが近い。

---

# 12. Storage Layout

v1 は JSON ファイルで管理する。

```text
.history/

├─ events/
├─ root_causes/
├─ actions/
├─ patterns/
└─ decisions/
```

---

# 13. Future Migration

将来的に以下への移行を許容する。

* SQLite
* PostgreSQL
* Vector Database

ただし Contract は変更しない。

---

# 14. LLM Optimization Rules

本仕様は以下を優先する。

* Flat JSON
* Enum First
* Explicit Contracts
* Minimal Nesting

理由:

Gemma 4 や GPT-OSS などのローカルLLMが安定して扱えるため。
