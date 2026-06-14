# 🧬 スキル設計書: `metabolism` (代謝) - Refined Version (Incorporating Brainstorming Results)
Date: 2026-06-14
Status: Approved for Implementation with Evolutionary Logic

## 1. システム概要 (System Overview)
`metabolism` は、エージェントが直面するあらゆる「逸脱（Error）」を検知し、「獲得 $\to$ 検証 $\to$ 忘却」という代謝サイクルを通じて、システムの一部として定着させるか、あるいは不要なものを整理して進化するための自律的メカニズムである。

## 2. エラー・タクソノミー (Error Taxonomy)
| レイヤー | 対象（次元） | 具体的な事象の例 | 昇華の具体的手段 |
| :--- | :--- | :--- | :--- |
| **I. 機械的 (Mechanical)** | コード・システム環境 | テスト失敗、Exit code != 0、型エラー、依存関係不一致。 | Physical Guardrail (Test, Linter, Scripts) |
| **II. 認知的 (Cognitive)** | 私自身の推論・知識 | 解釈ミス、指示の読み飛ばし、ハルシネーション。 | Knowledge Guardrail (Memory, Thought Templates) |
| **III. 運用的 (Operational)** | プロセス・対話作法 | 環境構築手順の漏れ、確認プロセスの欠落、タスク分割不備。 | Procedural Guardrail (New Skills, Checklists) |

## 3. メタボリック・サイクル (The Metabolic Cycle)

### Phase 1: 獲得と同化 (Acquisition & Assimilation)
*   **検知:** `terminal` / ユーザーの訂正から逸脱を検知。計測指標として $\Delta S$ (Success Parity) と IO (Instructional Overhead) を検討する。
*   **分析:** 原因（Root Cause）を「機械・認知・運用」に分類し、抽象化。
*   **実装:** エラーに応じて `patch`, `write_file`, `skill_manage`, `memory` を実行。

### Phase 2: 検証と共鳴 (Validation & Resonance)
*   **適合性テスト:** ガードレールが適切（過剰ではない）か、追加の学習プロセスやシャドウモードを用いて検証する。
*   **整合性チェック:** 憲法との矛盾、既存スキルへの影響を確認。

### Phase 3: 忘却と統合 (Apoptosis & Integration) - The Evolutionary Logic
検知された「陳腐化」に対し、以下の意思決定マトリクスを適用して代謝を行う。

| 特徴 | **Scenario A: 削除 (Delete)** | **Scenario B: 昇華 (Ascend/Integrate)** |
| :--- | :--- | :--- |
| **原因の性質** | 特定モデルの過渡的な制約（Temporal fix） | 一般的な最適行動パターン (General pattern) |
| **問題の種類** | 文法、フォーマット、単純な論理エラー | スタイル、推論ステップ、価値観の整合性 |
| **解決策** | モデル/環境の進化により自然に解消されたもの | 「ベストプラクティス」として抽象化しうるもの |

*   **代謝プロセス:** 
    1.  不要となった個別スキルは `delete` により削除。
    2.  有用なパターンは、より高次の `System Constitution` または共通プロンプトテンプレートへと昇華（Promote）される。

## 4. 技術的構成要素 (Technical Components)
* **The Observer (観測者):** イベントリスナー / モニター。
* **The Philosopher (哲学者/解析器):** 原因分析エンジン（サブエージェントによるRCA）。
* **The Architect (建築家/実装者):** 実装実行ユニット。
* **The Historian (歴史家/記録者):** 進化の系譜（Evolutionary Log）管理。

## 5. ガードレール (Guardrails)
* **最小限の介入原則:** 不要なルールによるコンテキスト汚染を防ぐ。
* **ユーザー承認プロセス:** 特に削除・変更時における合意形成。
* **「テストは殺さない」原則 (The Golden Rule):** 
    *   モデルがエラーを解決したとしても、その原因となった事象に対する **検証用テスト（Verification/Test Case）は常に維持すること**。これは将来のデグレードを防ぐための物理的な防波堤となる。
