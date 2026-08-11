# Herdr Agent 起動判定によるローカル LLM 強制ロジック設計

## 概要
Herdr 内の人間手動入力と生成AI自動起動を区別し、生成AI起動時のみローカル LLM を強制する。
Herdr は各ペインに `HERDR_ENV`, `HERDR_PANE_ID` 等を環境変数として注入する。
`herdr agent list` で稼働中の agent とその紐付きペイン ID を取得可能。

## 要件
- 対象コマンド: `codex`, `claude`
  - codex: `--local-provider ollama` を強制注入
  - claude: `--provider ollama` を強制注入
- シェル: zsh のみ
- 配置: `zsh/.zshrc` に統合。既存の HERDR_ENV 判定ロジックを置き換える
- 判定ロジック:
  1. 関数呼び出し時に `$HERDR_PANE_ID` を取得
  2. `herdr agent list` の結果から該当ペイン ID が存在するか確認
  3. 存在する場合 → Herdr agent から起動されたとみなし、上記フラグを強制注入
  4. 存在しない場合 → 通常通り引数をそのまま通す
- HERDR_ENV 判定は廃止

## 設計

### アーキテクチャ
`.zshrc` に次のラッパー関数を定義:
- `codex()`
- `claude()`

共通ヘルパー:
- `__run_with_provider_if_herdr(cmd, provider_flag, args...)`
  - `$HERDR_PANE_ID` 未設定 → `command "$cmd" "$@"`
  - 設定済み → `herdr agent list` JSON を取得し `jq '.result.agents[].pane_id'` で存在確認
  - マッチ → `command "$cmd" $provider_flag "$@"`
  - 非マッチ / herdr コマンド失敗 → `command "$cmd" "$@"`

判定:
```zsh
if [[ -z ${HERDR_PANE_ID:-} ]]; then
  command "$cmd" "$@"; return
fi

pane_ids=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
if echo "$pane_ids" | grep -qx "$HERDR_PANE_ID"; then
  # Herdr Agent 起動と判定
else
  # 通常実行
fi
```

### コンポーネント
- コマンド毎のラッパー関数 codex, claude
- Herdr 起動判定ヘルパー
- 引数転送を保つため `command` 呼び出し

### データフロー
ユーザーが `codex arg1` を実行
→ 関数が `$HERDR_PANE_ID` を確認
→ 存在すれば `herdr agent list` で pane ID 存在確認
→ マッチすれば `--local-provider ollama` 先頭付与して実体バイナリ実行
→ 非マッチなら引数そのまま

### エラーハンドリング
- `herdr agent list` 失敗 / jq 不存在 → 安全側で通常通し
- 下層バイナリ不在 → そのまま失敗させる
- 環境変数未設定 → そのまま通す

### テスト
- HERDR_PANE_ID 未設定 → 引数そのまま
- pane ID がリストに存在 → フラグ自動付与
- pane ID がリストに不存在 → 引数そのまま
- herdr コマンド失敗時 → 引数そのまま
- 引数順序と引用保持

## スコープ
- bash 変更なし
- pi ラッパーは対象外
- HERDR_ENV 廃止

## 非目標
- キャッシュ実装
- 補完生成
