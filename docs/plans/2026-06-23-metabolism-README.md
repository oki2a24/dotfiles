# 🧬 metabolism

Self-Improvement Through Patternization, Consolidation, and Forgetting

---

# Overview

metabolism は自己改善システムである。

ただし一般的な自己改善システムとは異なり、

改善策を無限に増やすことを目的としない。

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

改善知識を整理しながら進化し続けることを目的とする。

---

# Core Philosophy

metabolism の目的は以下である。

* 改善知識の蓄積
* 改善知識の統合
* 不要知識の忘却

---

# Design Documents

実装前に以下を読むこと。

---

## 1. Contract Specification

ファイル:

```text
2026-06-23-metabolism-contract-specification.md
```

内容:

* Data Contract
* DTO定義
* Contract Flow

---

## 2. Pattern Specification

ファイル:

```text
2026-06-23-metabolism-pattern-specification.md
```

内容:

* Pattern定義
* Pattern Lifecycle
* Merge Rule
* Retire Rule

---

## 3. API Specification

ファイル:

```text
2026-06-23-metabolism-api-specification.md
```

内容:

* Component API
* Input / Output
* Responsibility

---

## 4. Development Policy

ファイル:

```text
2026-06-23-metabolism-development-policy.md
```

内容:

* TDD
* Red-Green-Refactor
* Quality Gate

---

## 5. Implementation Plan

ファイル:

```text
2026-06-23-metabolism-implementation-plan.md
```

内容:

* 実装順序
* フェーズ設計
* 成果物定義

---

## 6. Work Packages

ファイル:

```text
2026-06-23-metabolism-work-packages.md
```

内容:

* 実装タスク
* 実装粒度
* 完了条件

---

## 7. Architecture Decisions

ファイル:

```text
2026-06-23-metabolism-architecture-decisions.md
```

内容:

* 設計判断
* 採用理由
* 変更履歴

---

# Recommended Reading Order

```text
README
↓
Contract Specification
↓
Pattern Specification
↓
API Specification
↓
Development Policy
↓
Implementation Plan
↓
Work Packages
```

---

# System Flow

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

# Development Process

すべての実装は以下に従う。

```text
Contract First
↓
Test First
↓
Red
↓
Green
↓
Refactor
```

---

# Human Review Points

以下は必ず人間承認を必要とする。

* Pattern Merge
* Pattern Retire
* Pattern Catalog追加
* Architecture Decision変更

---

# Current Status

Version:

```text
v1 Baseline
```

状態:

```text
設計完了
実装開始可能
```

---

# Next Step

Implementation Plan と Work Packages に従って実装を開始する。

新規設計文書の追加は原則行わない。

必要な変更は ADR と既存文書の改訂で対応する。

