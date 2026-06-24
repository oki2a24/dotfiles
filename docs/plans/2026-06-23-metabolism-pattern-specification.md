# 🧬 metabolism Pattern Specification

Date: 2026-06-23

Version: v1.0

Status: Draft

---

# 1. Purpose

本ドキュメントは metabolism における Pattern の定義を行う。

Pattern は metabolism の知識単位であり、

Historian による蓄積、

Apoptosis による統合・忘却の対象となる。

本仕様の目的は以下である。

* Pattern の意味を明確化する
* Pattern の命名ルールを定義する
* Pattern の生成ルールを定義する
* Pattern の統合ルールを定義する
* Pattern の忘却ルールを定義する

---

# 2. Core Philosophy

Pattern は失敗ではない。

Pattern は対策でもない。

Pattern は

「再利用可能な改善知識」

である。

---

例:

失敗

```text
ModuleNotFoundError
```

対策

```text
requirements.txt を確認する
```

Pattern

```text
DEPENDENCY_VALIDATION
```

---

Pattern は以下の抽象化によって生まれる。

```text
個別事象
↓
改善策
↓
共通化
↓
Pattern
```

---

# 3. Design Principles

## P01

Pattern は改善知識を表す

---

## P02

Pattern は再利用可能である

---

## P03

Pattern は増やし続けない

---

## P04

Pattern は統合を前提とする

---

## P05

Pattern は忘却を前提とする

---

# 4. Pattern Lifecycle

```text
Create
↓
Observe
↓
Grow
↓
Merge
↓
Retire
```

---

## Create

新規生成

---

## Observe

利用回数蓄積

---

## Grow

成功率更新

---

## Merge

他 Pattern へ統合

---

## Retire

利用終了

---

# 5. Pattern Structure

## Schema

```json
{
  "pattern_id": "uuid",
  "pattern_name": "DEPENDENCY_VALIDATION",
  "summary": "依存関係不足の事前検出",
  "observed_count": 17,
  "success_count": 16,
  "success_rate": 0.94,
  "status": "active"
}
```

---

# 6. Pattern Naming Rule

## Rule-N01

Pattern 名は自由入力禁止。

---

## Rule-N02

Pattern Catalog から選択する。

---

## Rule-N03

命名形式は UPPER_SNAKE_CASE とする。

---

例:

```text
DEPENDENCY_VALIDATION
ENVIRONMENT_VALIDATION
TASK_DECOMPOSITION
CHECKLIST_ENFORCEMENT
TEST_FIRST_DEVELOPMENT
```

---

# 7. Pattern Catalog

v1.0 では以下を標準 Pattern とする。

---

## DEPENDENCY_VALIDATION

依存関係不足の検出。

例:

* ModuleNotFoundError
* ImportError
* PackageNotFound

---

## ENVIRONMENT_VALIDATION

実行環境の検証。

例:

* Python Version 不一致
* PATH 不備
* 環境変数不足

---

## TASK_DECOMPOSITION

タスク分割改善。

例:

* 作業粒度過大
* 実装範囲過大

---

## CHECKLIST_ENFORCEMENT

確認漏れ防止。

例:

* レビュー漏れ
* 手順漏れ

---

## TEST_FIRST_DEVELOPMENT

TDD強化。

例:

* テスト不足
* テスト後書き

---

## ASSUMPTION_VALIDATION

推測防止。

例:

* Hallucination
* Wrong Assumption

---

## CONTEXT_PRESERVATION

コンテキスト維持。

例:

* 会話文脈消失
* 要件取り違え

---

# 8. Pattern Creation Rule

Historian は無制限に Pattern を生成してはならない。

---

処理順序

```text
既存Pattern探索
↓
一致
↓
更新

不一致
↓
Catalog確認

存在
↓
新規Pattern生成

存在しない
↓
Human Review
```

---

# 9. Pattern Matching Rule

Historian は以下を比較する。

---

## M01

Root Cause

---

## M02

Action Type

---

## M03

Expected Outcome

---

## M04

Pattern Name

---

Pattern一致条件

```text
2項目以上一致
```

---

# 10. Pattern Growth Rule

Pattern は以下を蓄積する。

---

## observed_count

観測回数

---

## success_count

成功回数

---

## success_rate

成功率

---

計算式

```text
success_count / observed_count
```

---

# 11. Pattern Merge Rule

Merge は自動実行しない。

---

Apoptosis は提案のみ行う。

---

最終判断者

```text
Human
```

---

Merge 条件

---

## MG01

同じ目的

---

## MG02

同じ改善効果

---

## MG03

同じ原因カテゴリ

---

## MG04

長期的に重複している

---

# 12. Pattern Limit Rule

Pattern は無制限に増加させない。

---

v1.0 上限

```text
50
```

---

超過時

```text
Merge Review
```

を実施する。

---

# 13. Pattern Retire Rule

Retire は削除ではない。

---

状態変更である。

```json
{
  "status": "retired"
}
```

---

削除禁止。

---

# 14. Retire Conditions

## R01

180日以上未利用

---

## R02

success_rate < 0.30

---

## R03

Merge 完了

---

## R04

人間が不要と判断

---

# 15. Human Review Points

以下は必ず人間判断を必要とする。

---

## HR01

新規 Pattern Catalog 追加

---

## HR02

Pattern Merge 承認

---

## HR03

Pattern Retire 承認

---

## HR04

Pattern Name 変更

---

# 16. Anti-Patterns

以下は禁止する。

---

## AP01

自由命名

例:

```text
dependency_check
dependency_validation_v2
dependency_verification
```

---

## AP02

類似 Pattern 乱立

---

## AP03

Pattern 自動削除

---

## AP04

Pattern 無制限増殖

---

# 17. Future Evolution

将来的に以下を検討可能。

* Pattern Hierarchy
* Pattern Recommendation
* Pattern Scoring
* Vector Search
* Knowledge Graph

ただし v1 系では採用しない。

---

# 18. Success Criteria

Pattern System が以下を満たすこと。

* Pattern が再利用される
* Pattern が増殖しない
* Pattern が統合される
* Pattern が忘却される
* Human が理解できる
* ローカルLLMが推測なしで扱える
* Historian が安定して更新できる
* Apoptosis が安定して評価できる

```
```

