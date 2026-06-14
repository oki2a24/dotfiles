# `metabolism` スキル実装計画書 (Implementation Plan)

> **Hermes Agent 用:** この計画は subagent-driven-development スキルを使用して、各タスクごとにサブエージェントを起動して実行することを想定しています。

**目標:** エラー（機械的・認知的・運用的）を検知し、失敗を物理的な仕組み（テスト・スキル・ナレッジ）へと昇華させるとともに、環境の変化に合わせて自己のルールを更新する「代謝サイクル」を実装する。

**アーキテクチャ:** 以下のコンポーネントからなるオーケストレーション・パターンを採用：
1. **Observer (観測者):** イベント（エラー/訂正）の検知。
2. **Philosopher (哲学者/解析器):** エラーの原因分析と抽象化（サブエージェントとして実行）。
3. **Architect (建築家/実装者):** 修正案の実装（ツール実行）。
4. **Historian (歴史家/記録者):** 進化の系譜（Evolutionary Log）の管理。

---

## フェーズ 1: 基盤構築 (Foundation)

### Task 1: プロフィールディレクトリ構造の作成
**目的:** スキルのためのファイルシステムを構築する。

**作業内容:**
- [ ] `./.hermes_profiles/software-engineer/skills/metabolism/` 配下に以下のディレクトリを作成：
  - [ ] `core/` (コアロジック)
  - [ ] `templates/` (プロンプトテンプレート)
  - [ ] `utils/` (補助スクリプト)
  - [ ] `history/` (進化ログの保存先)

### Task 2: スキルメタデータの定義
**目的:** Hermes Agent が認識可能な `SKILL.md` を作成する。

**ファイル:**
- [ ] Create: `./.hermes_profiles/software-engineer/skills/metabolism/SKILL.md`

**内容:**
- [ ] Name: `metabolism`
- [ ] Description: 「エラー（機械的・認知的・運用的）を検知し、失敗を物理的な仕組みへと昇華させ、進化に合わせて自己を代謝させるために使用する。」
- [ ] Categories: `[meta-evolution, developer-tools]`

---

## フェーズ 2: データモデルと言語設計 (Detection & Schema)

### Task 3: `MetabolicEvent` スキーマの実装
**目的:** 検知されたエラーを構造化データとして定義する。

**ファイル:**
- [ ] Create: `./.hermes_profiles/software-engineer/skills/metabolism/core/models.py`

- [ ] **実装詳細 (Python Dataclass):**
```python
# ID, タイムスタンプ, ソース(terminal/user_correction), 次元(mechanical/cognitive/operational)を保持
```

### Task 4: Observer（観測者）の実装
**目的:** エラー信号のリアルタイムなキャプチャ。

**ファイル:**
- [ ] Create: `./.hermes_profiles/software-engineer/skills/metabolism/core/observer.py`

- [ ] **手順:**
1. ターミナルの `exit code != 0` を監視するロジックの実装。
2. ユーザーメッセージ内の「間違い・訂正」を表すキーワード（"no,", "wrong", etc.）を検知するフィルタリング実装。

---

## フェーズ 3: 知能層の開発 (The Intelligence Layer)

### Task 5: Philosopher（解析器）の実装
**目的:** エラーの抽象化と原因分析を行うサブエージェント用インターフェース。

**ファイル:**
- [ ] Create: `./.hermes_profiles/software-engineer/skills/metabolism/templates/rca_prompt.md` (プロンプトテンプレート)
- [ ] Create: `./.hermes_profiles/software-engineer/skills/metabolism/core/philosopher.py`

### Task 6: Architect（建築家）の実装
**目的:** 解析結果を具体的なツール実行コマンドへと変換する。

**ファイル:**
- [ ] Create: `./.hermes_profiles/software-engineer/skills/metabolism/core/architect.py`

---

## フェーズ 4: 代謝と履歴管理 (Metabolism & History)

### Task 7: Historian（歴史家）の実装
**目的:** 進化の系譜を JSON ファイルとして永続化する。

**ファイル:**
- [ ] Create: `./.hermes_profiles/software-engineer/skills/metabolism/core/historian.py`

### Task 8: Apoptosis（代謝・廃棄）ロジックの実装
- [ ] **目的:** モデルの進化により不要となった古いルールを検知し、削除または統合する。

---

## フェーズ 5: 統合と検証 (Integration & Validation)

### Task 9: Orchestrator（全体制御）の結合
**目的:** 全てのコンポーネントを繋ぎ合わせ、一つのフローとして動作させる。

### Task 10: フル・ライフサイクル・シミュレーションテスト
- [ ] 手順:**
1. **トリガー:** 手動で `test_fail` (エラー) を実行。
2. **検知 & 解析:** `metabolism` が問題を特定し、修正案を提示することを検証。
3. **実装:** テストコード自動生成と修正の適用を確認。
4. **履歴確認:** 歴史家が正しくログを記録したか確認。

---

**Plan complete and saved to docs/plans/2026-06-14-metabolism-plan.md. Ready to execute using subagent-driven-development — I'll dispatch a fresh subagent per task with two-stage review (spec compliance then code quality). Shall I proceed?**
