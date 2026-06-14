# `metabolism` スキル実装計画書 (Implementation Plan) - Refined Version

> **Hermes Agent 用:** この計画は subagent-driven-development スキルを使用して、各タスクごとにサブエージェントを起動して実行することを想定しています。

**目標:** エラー（機械的・認知的・運用的）を検知し、失敗を物理的な仕組み（テスト・スキル・ナレッジ）へと昇華させるとともに、環境の変化に合わせて自己のルールを更新する「代謝サイクル」を実装する。

---

## フェーズ 1: 基盤構築 (Foundation) [Project Progress: 0%]

### Task 1: プロフィールディレクトリ構造の作成
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/core/` を作成
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/templates/` を作成
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/utils/` を作成
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/history/` を作成

### Task 2: スキルメタデータの定義
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/SKILL.md` を作成（Name, Description, Categoriesを規定）

### Task 3: `MetabolicEvent` スキーマの実装
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/core/models.py` を作成 (Python Dataclassによる定義)
  - [ ] ID, Timestamp の実装
  - [ ] Source (terminal/user_correction) の実装
  - [ ] Dimension (mechanical/cognitive/operational) の実装
  - [ ] **Model Version / Environment Context** の保持（陳腐化判定に必須）

---

## フェーズ 2: データモデルと言語設計 (Detection & Schema) [Project Progress: 0%]

### Task 4: Observer（観測者）の実装
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/core/observer.py` を作成
  - [ ] ターミナルの `exit code != 0` を監視するロジックを実装
  - [ ] ユーザーの訂正キーワード（"no,", "wrong", etc.）を検知するフィルタリングロジックを実装

---

## フェーズ 3: 知能層の開発 (The Intelligence Layer) [Project Progress: 0%]

### Task 5: Philosopher（解析器）の実装
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/templates/rca_prompt.md` を作成 (原因分析用プロンプトテンプレート)
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/core/philosopher.py` を作成

### Task 6: Architect（建築家）の実装
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/core/architect.py` を作成 (解析結果をツール実行コマンドへと変換)

---

## フェーズ 4: 代謝と履歴管理 (Metabolism & History) [Project Progress: 0%]

### Task 7: Historian（歴史家）の実想
- [ ] `~/.hermes_profiles/software-engineer/skills/metabolism/core/historian.py` を作成 (JSON形式による進化ログの永続化)

### Task 8: Apoptosis（代謝・廃棄）ロジックの実装
- [ ] **意思決定マトリクスの実装:**
  - [ ] `Scenario A (Delete)`: 一時的な制約エラーを判定し、スキルの削除 (`delete`) を実行する。
  - [ ] `Scenario B (Ascend)`: 一般化可能なパターンを検知し、`Constitution` への昇華プロセスを開始する。
- [ | **陳腐化の定量的判定:** $\Delta S$ (成功率差異) および IO (指示コスト) に基づく指標検討の実装。

---

## フェーズ 5: 統合と検証 (Integration & Validation) [Project Progress: 0%]

### Task 9: Orchestrator（全体制御）の結合
- [ ] 全コンポーネントを連携させるオーケストレーション・フローの実装
- [ ] **Shadow Mode モード:** ガードレール適用前後の挙動を非破壊的に比較するフェーズの統合。

### Task 10: フル・ライフサイクル・シミュレーションテスト
- [ ] エラー $\to$ 検知 $\to$ 解析 $\to$ 実装 $\to$ 履歴確認 の一連のテストを実施し、正常動作を検証する
- [ ] **「テストは殺さない」原則の検証:** ガードレール（指示）が削除された後も、**対応する検証用テストコードが残留していること**を確認する。
