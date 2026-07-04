# 🧬 metabolism Architecture Decisions

Date: 2026-06-23

Version: v1.0

Status: Accepted

Purpose:

本ドキュメントは metabolism における重要な設計判断と、その理由を記録する。

---

# ADR-001

## Title

Contract First を採用する

## Status

Accepted

## Decision

すべての実装は Contract から開始する。

## Reason

* ローカルLLMの推測実装防止
* 責務の明確化
* テスト容易性向上

---

# ADR-002

## Title

JSON Storage を採用する

## Status

Accepted

## Decision

v1では JSON ファイル保存を採用する。

## Reason

* Git管理が容易
* Diff確認可能
* grep可能
* SQLiteへの移行が容易

---

# ADR-003

## Title

Pattern を知識単位として採用する

## Status

Accepted

## Decision

履歴ではなく Pattern を蓄積する。

## Reason

目的は履歴管理ではなく改善知識の蓄積だから。

---

# ADR-004

## Title

Pattern は自由命名しない

## Status

Accepted

## Decision

Pattern Catalog 方式を採用する。

## Reason

命名ゆれによる Pattern 増殖を防ぐため。

---

# ADR-005

## Title

Pattern 数の上限を設ける

## Status

Accepted

## Decision

Pattern 上限は 50 とする。

## Reason

統合を促進するため。

---

# ADR-006

## Title

Pattern 階層を採用しない

## Status

Accepted

## Decision

v1では Pattern Hierarchy を採用しない。

## Reason

ローカルLLMが扱いやすいフラット構造を優先するため。

---

# ADR-007

## Title

Merge は自動実行しない

## Status

Accepted

## Decision

Apoptosis は Merge 提案のみ行う。

## Reason

誤統合リスクを避けるため。

---

# ADR-008

## Title

Retire は論理削除とする

## Status

Accepted

## Decision

Pattern は削除しない。

status=retired とする。

## Reason

忘却理由も知識だから。

---

# ADR-009

## Title

TDD を必須とする

## Status

Accepted

## Decision

すべての Work Package は TDD で実施する。

## Reason

品質維持とローカルLLMの暴走防止。

---

# ADR-010

## Title

Red-Green-Refactor を必須とする

## Status

Accepted

## Decision

すべての実装は以下に従う。

1. Red
2. Green
3. Refactor

## Reason

継続的品質改善のため。

---

# ADR-011

## Title

1 Work Package = 1責務

## Status

Accepted

## Decision

Work Package は単一責務とする。

## Reason

ローカルLLMが扱いやすい粒度にするため。

---

# ADR-012

## Title

Human Review Point を設ける

## Status

Accepted

## Decision

以下は人間承認必須。

* Pattern Merge
* Pattern Retire
* Pattern Catalog追加

## Reason

知識体系の破壊を防ぐため。

---

# ADR-013

## Title

Document Explosion を防止する

## Status

Accepted

## Decision

新規設計文書の追加は原則停止する。

## Reason

人間およびローカルLLMの認知負荷を抑えるため。

---

# ADR-014

## Title

現在の設計セットを v1 Baseline とする

## Status

Accepted

## Decision

以下を v1 Baseline とする。

* Contract Specification
* Pattern Specification
* API Specification
* Development Policy
* Implementation Plan
* Work Packages
* README

## Reason

設計フェーズを終了し実装フェーズへ移行するため。
