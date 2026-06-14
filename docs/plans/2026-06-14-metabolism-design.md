# 🧬 スキル設計書: `metabolism` (代謝) - Final Version
Date: 2026-06-14
Status: Approved for Implementation

## 1. システム概要 (System Overview)
`metabolism` は、エージェントが直面するあらゆる「逸脱（Error）」を検知し、それを**「獲得 $\to$ 検証 $\to$ 忘却」**という代謝サイクルを通じて、システムの一部として定着させるか、あるいは不要なものを整理して進化するための自律的メカニズムである。

## 2. エラー・タクソノミー (Error Taxonomy)
| レイヤー | 対象（次元） | 具体的な事象の例 | 昇華の具体的手段 |
| :--- | :--- | :--- | :--- |
| **I. 機械的 (Mechanical)** | コード・システム環境 | テスト失敗、Exit code != 0、型エラー、依存関係不一致。 | Physical Guardrail (Test, Linter, Scripts) |
| **II. 認知的 (Cognitive)** | 私自身の推論・知識 | 解釈ミス、指示の読み飛ばし、ハルシネーション。 | Knowledge Guardrail (Memory, Thought Templates) |
| **III. 運用的 (Operational)** | プロセス・対話作法 | 環境構築手順の漏れ、確認プロセスの欠落、タスク分割不備。 | Procedural Guardrail (New Skills, Checklists) |

## 3. メタボリック・サイクル (The Metabolic Cycle)
### Phase 1: 獲得と同化 (Acquisition & Assimilation)
*   **検知:** `terminal` / ユーザーの訂正から逸脱を検知。
*   **分析:** 原因（Root Cause）を「機械・認知・運用」に分類し、抽象化。
*   **実装:** エラーに応じて `patch`, `write_file`, `skill_manage`, `memory` を実行。

### Phase 2: 検証と共鳴 (Validation & Resonance)
*   **適合性テスト:** Hermes Agent アプリおよび接続モデルの進化に対し、ガードレールが適切（過剰ではない）か検証。
*   **整合性チェック:** 憲法との矛盾、既存スキルへの影響を確認。

### Phase 3: 忘却と統合 (Apoptosis & Integration)
*   **陳腐化検知:** モデル/環境の変化によりルールが不要になったことを検知。
*   **代謝:** 不要なスキルの削除 (`delete`) または高次原理への統合（昇華）。

## 4. 技術的構成要素 (Technical Components)
*   **The Observer (観測者):** イベントリスナー / モニター。
*   **The Philosopher (哲学者/解析器):** 原因分析エンジン。
*   **The Architect (建築家/実装者):** 実装実行ユニット。
*   **The Historian (歴史家/記録者):** 進化の系譜（Evolutionary Log）管理。

## 5. ガードレール (Guardrails)
*   最小限の介入原則。
*   ユーザーの承認プロセス（特に削除・変更時）。
