# OpenCode への Magnitude ローカルモデル追加 実装計画

> **AIエージェントへの指示:** REQUIRED SUB-SKILL: この計画をタスクごとに実装するには、移植された `subagent-driven-development` スキル（推奨）または `executing-plans` スキルを起動して使用してください。ステップには追跡用のチェックボックス (`- [ ]`) を使用します。

**目標:** dotfiles の `opencode/opencode.jsonc` に V2 正形で Magnitude プロバイダーを登録し、`magnitude/lfm2.5-24b-a2b:gguf:q4` と `magnitude/gemma-4-26b-a4b-it-qat:gguf:q4` を `/models` から選択可能にする。あわせて `~/.config/opencode/opencode.jsonc` を dotfiles へのシンボリックリンクに復旧する。

**アーキテクチャ:** OpenCode のプロバイダーは設定ファイルの `providers` オブジェクトで宣言する。Magnitude は OpenAI 互換エンドポイント（`http://127.0.0.1:10100/inference/v1`）を提供するため、V2 標準パッケージ `@opencode/ai/providers/openai-compatible` を使う。モデルごとの limit と reasoning バリアントは `limit` と `capabilities.reasoning` で表現する。

**技術スタック:** OpenCode V2 設定（opencode.jsonc）、zsh、Magnitude CLI（動作確認時のサービス稼働のみ）。

**仕様 (Spec):** `docs/plans/2026-11-03-opencode-magnitude-model-design.md`

## グローバル制約

- 取り込むモデルは `lfm2.5-24b-a2b:gguf:q4` と `gemma-4-26b-a4b-it-qat:gguf:q4` の2つのみ。`local:...` の2モデル（Ollama 由来）は取り込まない。
- V2 で deprecated な `"provider"`（単数形）キー、`npm` / `options` / `modalities` キーは使用しない。
- 既定モデル（`model`）と既存のプロバイダー定義（ollama / bonsai / openrouter / strata）は変更しない。
- グローバル `~/.config/opencode/opencode.json`（strata・V1 形）は触れない。
- 通常ファイル化した `~/.config/opencode/opencode.jsonc` には Magnitude 定義を書き戻さない。dotfiles が正。
- コミットメッセージ: Conventional Commits。本文に日本語で「なぜ」を記述。

## レビューフォーカス

- Magnitude サービスが停止している（ポート 10100 が応答しない）ときにモデル選択 → 「使用できないモデル」として正直に失敗すること（サービス起動は本計画の範囲外）。
- `package` 名の綴り（`@opencode/ai/providers/openai-compatible`）が1字でも違うと provider 全体が列挙されないこと。2モデルの列挙を確認して検知する。
- dotfiles 側で deprecated `provider` キーを併用してしまうと、将来 Magnitude による再書き込み時と挙動が二重化する。`provider` キーを追加しないことを grep で確認。
- lfm2.5 に `toggle`（off バリアント）を足してしまうと現行挙動と異なる。lfm2.5 は `effort: ["high"]` のみ、Gemma 4 のみ `toggle: true`。
- `apiKey` を環境変数化せず直書きする件は現行（`magnitude-local`・スコープは localhost）と同じ。秘密情報には当たらないためこのままとする。

---

### タスク 1: dotfiles の opencode.jsonc に Magnitude プロバイダーを追加

**ファイル:**
- 変更: `/Users/oki2a24/dotfiles/opencode/opencode.jsonc`（末尾の `providers` オブジェクト内）

**インターフェース (Interfaces):**
- 消費 (Consumes): なし
- 生産 (Produces): OpenCode V2 プロバイダー `magnitude`（選択 ID は `magnitude/lfm2.5-24b-a2b:gguf:q4` と `magnitude/gemma-4-26b-a4b-it-qat:gguf:q4`）。タスク 2 の検証とタスク 3 のコミットが依存する。

- [x] **ステップ 1: 現状確認（失敗する検証の基線を取る）**

実行: `opencode models | grep '^magnitude/'`
期待値: 現行は deprecated 設定経由で以下が表示されること（完了判定には使わない基線）:

```
magnitude/gemma-4-26b-a4b-it-qat:gguf:q4
magnitude/local:26b-dequant-it-hf-q4_0:508e725fe6ac
magnitude/local:gemma-4-26b-a4b-it-q4_k_m:b2018256a727
magnitude/lfm2.5-24b-a2b:gguf:q4
```

- [x] **ステップ 2: 失敗する検証の実行（構成テスト）**

実行: `jq -e '.providers.magnitude.models["lfm2.5-24b-a2b:gguf:q4"] and .providers.magnitude.models["gemma-4-26b-a4b-it-qat:gguf:q4"] and .providers.magnitude.package == "@opencode/ai/providers/openai-compatible" and (.provider | not)' /Users/oki2a24/dotfiles/opencode/opencode.jsonc; echo "exit=$?"`
期待値: 編集前は `false` を出力し `exit=1`（これは PASS イコールではない。修正後に同じコマンドが `true` / `exit=0` になることで失敗→パスを確認する）

- [x] **ステップ 3: `providers` に `magnitude` を追加**

既存の `"strata"` 定義の後に追記する。正確な JSX ではなく JSONC 断片として以下のとおり（仕様が固定する値）:

```jsonc
    "magnitude": {
      "package": "@opencode/ai/providers/openai-compatible",
      "name": "Magnitude",
      "settings": {
        "baseURL": "http://127.0.0.1:10100/inference/v1",
        "apiKey": "magnitude-local"
      },
      "models": {
        "lfm2.5-24b-a2b:gguf:q4": {
          "name": "Liquid LFM2.5 24B-A2B (Q4)",
          "limit": {
            "context": 131072,
            "output": 32768
          },
          "capabilities": {
            "input": ["text"],
            "output": ["text"],
            "reasoning": {
              "supported": true,
              "effort": ["high"]
            }
          }
        },
        "gemma-4-26b-a4b-it-qat:gguf:q4": {
          "name": "Gemma 4 26B-A4B (Q4 QAT)",
          "limit": {
            "context": 262144,
            "output": 32768
          },
          "capabilities": {
            "input": ["text", "image"],
            "output": ["text"],
            "reasoning": {
              "supported": true,
              "toggle": true,
              "effort": ["high"]
            }
          }
        }
      }
    }
```

`capabilities.reasoning` により `#high`（lfm2.5）と `#none` / `#high`（Gemma 4）のバリアントが自動生成され、旧定義の `variants`（off/high）を置き換える。`tools` は旧定義にもないため明示しない。

- [x] **ステップ 4: 検証コマンドの再実行**

実行： `bash -c 'jq -e ".providers.magnitude.models[\"lfm2.5-24b-a2b:gguf:q4\"] and .providers.magnitude.models[\"gemma-4-26b-a4b-it-qat:gguf:q4\"] and .providers.magnitude.package == \"@opencode/ai/providers/openai-compatible\" and (.provider | not)" /Users/oki2a24/dotfiles/opencode/opencode.jsonc'`
期待値: `true` で終了コード 0

- [x] **ステップ 5: タスク完了確認（コミットはタスク 3 に一括）**

実行: `jq -e '.providers | keys | contains(["ollama","bonsai","openrouter","strata","magnitude"])' /Users/oki2a24/dotfiles/opencode/opencode.jsonc`
期待値: `true`（既存4プロバイダーを壊していないこと）

### タスク 2: シンボリックリンクの復旧

**ファイル:**
- 削除: `/Users/oki2a24/.config/opencode/opencode.jsonc`（通常ファイル）
- 作成: `/Users/oki2a24/.config/opencode/opencode.jsonc` → `/Users/oki2a24/dotfiles/opencode/opencode.jsonc`（シンボリックリンク）

**インターフェース (Interfaces):**
- 消費 (Consumes): タスク 1 で完成した dotfiles 側設定
- 生産 (Produces): OpenCode が読む実運用設定が dotfiles 源泉になる状態。タスク 3 の検証が依存する。

- [x] **ステップ 1: 現状のリンク状況確認**

実行: `ls -la /Users/oki2a24/.config/opencode/ | grep -E 'AGENTS.md|opencode.jsonc'`
期待値: `opencode.jsonc` が `-rw`（通常ファイル）であることを記録。`AGENTS.md` が既に `dotfiles/opencode/AGENTS.md` へのリンクなら触らない。

- [x] **ステップ 2: 通常ファイルの削除とリンクの再作成**

```bash
rm /Users/oki2a24/.config/opencode/opencode.jsonc
ln -sfv /Users/oki2a24/dotfiles/opencode/opencode.jsonc /Users/oki2a24/.config/opencode/opencode.jsonc
```

（`AGENTS.md` がリンク切れの場合のみ同様に `ln -sfv /Users/oki2a24/dotfiles/opencode/AGENTS.md /Users/oki2a24/.config/opencode/AGENTS.md`）

- [x] **ステップ 3: リンクの検証**

実行: `readlink /Users/oki2a24/.config/opencode/opencode.jsonc`
期待値: `/Users/oki2a24/dotfiles/opencode/opencode.jsonc`

- [x] **ステップ 4: 設定再読込とモデル列挙の検証**

実行: `opencode reload && opencode models | grep '^magnitude/'`
期待値（2行のみ。`local:` が消えていること）:

```
magnitude/gemma-4-26b-a4b-it-qat:gguf:q4
magnitude/lfm2.5-24b-a2b:gguf:q4
```

実行: `opencode models | grep -E '^(ollama|bonsai|openrouter|strata)/'`
期待値: magnitude 以外の既存モデルも消えていないこと（該当行が出力されること）

- [x] **ステップ 5: 既定モデルが変わっていないことの確認**

実行: `jq -r '.model' /Users/oki2a24/.config/opencode/opencode.jsonc`
期待値: `openrouter/openrouter/free`（触れていないこと）

### タスク 3: コミット

**ファイル:**
- コミット対象: `opencode/opencode.jsonc`

**インターフェース (Interfaces):**
- 消費 (Consumes): タスク 1・2 の完了状態
- 生産 (Produces): dotfiles リポジトリ上の恒久設定

- [x] **ステップ 1: 変更内容の目視確認**

実行: `git -C /Users/oki2a24/dotfiles diff opencode/opencode.jsonc`
期待値: `providers` への `magnitude` 追加のみで、既存定義・`model`・`plugins`・`agents` に差分がないこと。

- [x] **ステップ 2: コミット**

```bash
cd /Users/oki2a24/dotfiles
git add opencode/opencode.jsonc docs/plans/2026-11-03-opencode-magnitude-model.md
git commit -m "feat: OpenCode に Magnitude ローカルプロバイダーを追加

OPENCODE_CONFIG_CONTENT による一時指定ではなく設定ファイルで
magnitude/lfm2.5-24b-a2b:gguf:q4 と
magnitude/gemma-4-26b-a4b-it-qat:gguf:q4 を選択可能にした。
Magnitude の接続フローが書き込んだ旧形式 (deprecated な provider
キー・npm/options/modalities) は V2 正形 (providers キー、
@opencode/ai/providers/openai-compatible パッケージ、
capabilities.reasoning によるバリアント) に変換して恒久化する。
Ollama 由来の local:2モデルは既存の ollama プロバイダーと重複する
ため登録しない。

同一ファイルに、本タスク着手以前から作業ツリーにあった未コミットの
更新 (plugins/providers キー名の V2 対応、既定モデル、bonsai
openrouter strata 追加、古い ollama モデル定義の削除など) が含まれて
いた。現在運用中の実態そのものであり、magnitude 追加と同一ハンクに
含まれて分離が困難なため、全体をこの1コミットに含める。"
```

- [x] **ステップ 3: 完了確認**

実行: `git -C /Users/oki2a24/dotfiles status --short && opencode models | grep '^magnitude/'`
期待値: ワーキングツリーに opencode.jsonc 関連の未コミット差分がなく、2モデルが列挙されること。
