# 🧬 metabolism Development Policy

Date: 2026-06-23

Version: v1.0

Status: Draft

---

# 1. Purpose

本ドキュメントは metabolism プロジェクトの実装ルールを定義する。

Implementation Plan および Work Packages は本ドキュメントに従って実施する。

目的は以下である。

- ローカルLLMによる推測実装を防ぐ
- 実装品質を一定に保つ
- TDDを強制する
- リファクタリングを強制する
- 実装粒度を揃える

---

# 2. Core Principles

本プロジェクトは以下を最重要原則とする。

## Principle-D01

Contract First

---

## Principle-D02

Test First

---

## Principle-D03

Red-Green-Refactor

---

## Principle-D04

Small Steps

---

## Principle-D05

Explainability

---

# 3. Contract First Rule

実装開始前に Contract が存在しなければならない。

実装者は Contract を変更してはならない。

Contract変更が必要な場合は設計フェーズへ戻る。

---

# 4. TDD Rule

すべての実装は TDD で行う。

禁止事項:

- テスト後書き
- 動作確認のみ
- 手動確認のみ

---

# 5. Red-Green-Refactor Rule

すべての Work Package は以下の順序で実施する。

## Step 1: Red

失敗するテストを作成する。

期待する振る舞いを明文化する。

テスト実行により失敗を確認する。

---

## Step 2: Green

テストを通すための最小実装を行う。

この段階では美しい設計を求めない。

まずテストを成功させる。

---

## Step 3: Refactor

重複排除。

命名改善。

責務整理。

構造改善。

---

## Step 4: Verify

全テスト成功を確認する。

---

# 6. Work Package Execution Rule

各 Work Package は以下の手順で進める。

1. Contract確認
2. テスト作成
3. テスト失敗確認
4. 最小実装
5. テスト成功確認
6. リファクタリング
7. 全テスト実行
8. 完了判定

---

# 7. Definition of Done

Work Package は以下を満たした場合のみ完了とする。

## 必須条件

- テスト作成済み
- テスト失敗確認済み
- 実装完了
- テスト成功
- リファクタリング完了
- 全テスト成功

---

## 禁止

以下の状態で完了扱いにしてはならない。

- テストなし
- TODO残存
- 未使用コード残存
- コンパイルエラー残存
- 失敗テスト残存

---

# 8. Refactoring Rule

リファクタリングは省略不可。

最低限以下を確認する。

## R01

責務が明確か

---

## R02

命名が適切か

---

## R03

重複が存在しないか

---

## R04

テスト可読性が保たれているか

---

# 9. LLM Implementation Rule

ローカルLLMは以下を守ること。

## 許可

- DTO作成
- Unit Test作成
- Enum作成
- Validation作成

---

## 禁止

- 勝手な仕様追加
- Contract変更
- 推測によるフィールド追加
- 未承認ライブラリ導入

---

# 10. Commit Rule

推奨コミット粒度:

1 Work Package = 1 Commit

例:

WP-033 EventDetector Test

↓

WP-034 EventDetector Implementation

↓

WP-035 EventDetector Refactor

---

# 11. Documentation Rule

実装完了後は以下を更新する。

- 実装状況
- テスト状況
- 発見事項

---

# 12. Quality Gate

以下を満たさない場合は次フェーズへ進めない。

## Gate-Q01

Contract Test Success

---

## Gate-Q02

Unit Test Success

---

## Gate-Q03

Integration Test Success

---

## Gate-Q04

E2E Test Success

---

# 13. Success Criteria

metabolism の実装は以下を満たしたとき成功とする。

- Contract First が維持されている
- TDD が維持されている
- Red-Green-Refactor が維持されている
- 全テストが成功している
- Work Package 単位で追跡可能である
