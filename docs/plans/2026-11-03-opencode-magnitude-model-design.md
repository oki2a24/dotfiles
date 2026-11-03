# 設計メモ: OpenCode への Magnitude ローカルモデル追加

日付: 2026-11-03
スコープ: 小さな変更（設定1ファイル + シンボリックリンク復旧）

## 意図となぜ

`opencode --standalone` 時に `OPENCODE_CONFIG_CONTENT` で `magnitude/lfm2.5-24b-a2b:gguf:q4` を一時指定する運用をやめ、設定ファイルに恒久登録して TUI の `/models` から後から選べるようにする。

## 現状と問題

- Magnitude の接続フロー（`magnitude connections connect opencode`、実行済み・Connected）が今日 09:19 に `~/.config/opencode/opencode.jsonc` を丸ごと置換した。
  - (a) V2 で deprecated な `"provider"`（単数形）キーと古い形状（`npm` / `options` / `modalities` / map 形 `variants`）で書かれた。
  - (b) 置換により `link.sh` が張る dotfiles へのシンボリックリンクが切れ、通常ファイルになった。
- dotfiles 側 `opencode/opencode.jsonc` には magnitude 定義がない。

## ゴール / 非ゴール / アンチゴール

- ゴール: dotfiles の `opencode/opencode.jsonc` に V2 正形で magnitude プロバイダーを追加し、`lfm2.5-24b-a2b:gguf:q4` と `gemma-4-26b-a4b-it-qat:gguf:q4` が `/models` で選べること。`~/.config/opencode/opencode.jsonc` が dotfiles へのシンボリックリンクに戻ること。
- 非ゴール: 既定モデル（`model`）の変更、Ollama 由来残り2モデルの取り込み、Magnitude 側ワークフローの変更。
- アンチゴール: 目的は達したのに dotfiles と実運用設定が乖離し続ける状態、deprecated 形を正規設定として残すこと。

## 手法

検討した案:

- **A案（採用）: dotfiles に V2 正形で手書き** — 非推奨形を排除し、dotfiles 管理に戻せる。手間は上記の形の変換分。
- B案: Magnitude が書いた deprecated 形ブロックをそのまま移す — 手間最小だが非推奨形を正規化する問題は残る。
- 捨てた案: `magnitude connections sync` に任せて何もしない — 通常ファイルのまま dotfiles と乖離が続くため不採用。

## 決定済みの内容

1. 既存 `"providers"` オブジェクトに `"magnitude"` を追加。V2 形:
   - `name`: `"Magnitude"`
   - `package`: `"@opencode/ai/providers/openai-compatible"`
   - `settings`: `baseURL: http://127.0.0.1:10100/inference/v1`、`apiKey: magnitude-local`
2. 取り込むモデルは2つ:
   - `lfm2.5-24b-a2b:gguf:q4`: 名称 `Liquid LFM2.5 24B-A2B (Q4)`、limit context 131072 / output 32768、入出力とも text。reasoning は `effort: ["high"]` のみ（元の定義に `off` バリアントはない）。
   - `gemma-4-26b-a4b-it-qat:gguf:q4`: 名称 `Gemma 4 26B-A4B (Q4 QAT)`、limit context 262144 / output 32768、入力 text+image / 出力 text。reasoning は `toggle: true` かつ `effort: ["high"]`（元の `off`/`high` を再現）。
3. 取り込まない: `local:...` の2モデル（Ollama 由来。`gemma4:26b-a4b-it-qat` は既存 ollama プロバイダー定義で選択可能）。
4. `~/.config/opencode/opencode.jsonc` の通常ファイルを削除し、`link.sh` の opencode 部分相当（jsonc と AGENTS.md のリンク、既に貼れているものは冪等）でシンボリックリンクを復旧。`magnitude` 定義は書き戻さない（dotfiles が正）。
5. グローバル `~/.config/opencode/opencode.json`（strata・V1 形）には触れない。

## ビルダーに残された部分

- `capabilities` の正確な記述（未指定項目は現行と同じ挙動にする。tools は現行定義にないため明示しない）。
- 動作確認方法: `opencode models`（または同等のコマンド）で `magnitude/...` の2モデルが列挙されること。Magnitude サービス稼働下で実行。
- コミット: Conventional Commits。本文で「なぜ deprecated 形を受け入れず V2 正形で dotfiles に取り込むか」を日本語で説明。

## 既知の留意点

- 将来 `magnitude connections connect/sync opencode` を再実行すると、設定を丸ごと置換してシンボリックリンクが再び切れる可能性がある。その場合はこの設計の復旧手順（削除 → 再リンク）を繰り返す。
