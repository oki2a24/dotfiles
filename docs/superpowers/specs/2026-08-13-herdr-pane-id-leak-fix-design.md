# HERDR_PANE_ID 環境変数リーク修正設計
## 概要
HERDR_PANE_ID 環境変数がペイン間で一意に更新されず、古い値が継続利用される問題を解決する。
Herdr API からリアルタイムに現在のペイン ID を取得し、環境変数のキャッシュ依存を排除する。

## 問題点
- HERDR_PANE_ID がサブシェルやペイン移動時に正しく更新されない
- w7:pJ で起動したペインで HERDR_PANE_ID=w7:p1 が出力される事例確認
- herdr agent list では正しいペイン ID が取得可能

## 要件
- 環境変数 HERDR_PANE_ID の参照を廃止し、API 経由でリアルタイム取得
- ペイン判定は herdr pane current / herdr agent list を使用
- 既存の codex/claude ラッパー動作は維持
- TDD でテストを作成後実装

## 設計
### アーキテクチャ
zsh/.zshrc に以下を追加:
- __herdr_current_pane_id(): herdr pane current --current から現在のペイン ID を取得。失敗時は空文字返却
- __herdr_pane_is_agent(): 現在のペイン ID が herdr agent list に存在するか判定
- __run_with_provider_if_herdr(): 上記ヘルパーを使用し、エージェント稼働中のみ provider 注入

### データフロー
1. ユーザーが codex arg1 を実行
2. __run_with_provider_if_herdr が __herdr_current_pane_id を呼び出し
3. API から取得したペイン ID で herdr agent list と照合
4. マッチ時のみ --local-provider/--provider 注入

### エラーハンドリング
- herdr コマンド失敗 → 通常実行
- jq 不存在 → grep ベースフォールバック
- API レスポンス不正 → 安全側で通常実行

## テスト項目
- HERDR_PANE_ID 未設定でも正しく判定
- ペイン ID がエージェントリストに存在 → フラグ注入
- ペイン ID が不在 → 通常実行
- herdr コマンド失敗 → 通常実行
- 複数ペイン混在時の正確性

## スコープ
- zsh/.zshrc のみ修正
- 既存テストを更新
