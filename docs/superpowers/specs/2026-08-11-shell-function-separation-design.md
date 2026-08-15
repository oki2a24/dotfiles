# シェル関数分離設計

## 概要
`codex`、`claude`、`pi` コマンド用のシェル関数を分離し、HERDR_ENV 対応のプロバイダ注入を行う。人間が直接実行時は引数をそのまま渡し、HERDR_ENV=1 の場合は `--provider ollama` を自動付与する。

## 要件
- 対象コマンド: codex, claude, pi のみ。hermes と opencode は除外。
- シェル: zsh のみ。
- 配置: 既存の `zsh/.zshrc` に統合。
- 動作:
  - 通常実行: 引数をそのまま下層コマンドに渡す。
  - HERDR_ENV=1 が設定されている場合: `--provider ollama` を自動で先頭に付与。
- HERDR_ENV の判定は存在確認だけでなく値が `1` であることのチェックも含む。
- 実装は TDD Red-Green-Refactor で行う。

## 設計
### アーキテクチャ
`.zshrc` に次のラッパー関数を定義する:
- `codex()`
- `claude()`
- `pi()`

ヘルパー:
- `__with_provider_if_herdr` が条件付きで最終引数リストを構築する。

条件:
```zsh
if [[ -n $HERDR_ENV && $HERDR_ENV == 1 ]]; then
  args=(--provider ollama "$@")
else
  args=("$@")
fi
```

実行:
```zsh
command codex "${args[@]}"
```
claude と pi も同様。

### コンポーネント
- コマンド毎のラッパー関数。
- プロバイダ注入用の共有ヘルパー。
- 引数転送を保つためエイリアスは使用しない。

### データフロー
ユーザーが `codex arg1 arg2` を実行
→ 関数が HERDR_ENV を確認
→ `--provider ollama` の有無で引数を構築
→ `command` 経由で実体バイナリを実行

### エラーハンドリング
- 下層バイナリが存在しない場合はそのまま失敗させる。
- エラーを飲み込まない。
- 副作用なし。

### テスト
- シェルでの単体テスト: 関数定義を source し構築された argv を検証。
- テストケース:
  - HERDR_ENV 未設定 → 引数そのまま。
  - HERDR_ENV=1 → `--provider ollama` が先頭に追加。
  - HERDR_ENV=0 または他値 → 引数そのまま。
  - 引数の順序と引用の保持。

## スコープ
- bash の変更なし。
- hermes/opencode のラッパーなし。
- CI 統合はローカル検証のみ。

## 非目標
- 補完生成。
- コマンド存在の自動インストール。
