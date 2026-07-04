# dotfiles
Windows および Mac の設定ファイルです。

## Windows でのセットアップ手順
Windows PowerShell (管理者) を起動 (Windows+X, A) します。

```bash
cd ~
git clone https://github.com/oki2a24/dotfiles.git
Set-ExecutionPolicy Bypass -Scope Process -Force; .\dotfiles\link.ps1
```

## Mac でのセットアップ手順
```bash
cd ~
git clone https://github.com/oki2a24/dotfiles.git
cd dotfiles/
bash link.sh
```

## tmux のセットアップ手順
tmux プラグインのインストールが必要です。 `tmux` で起動後、 `prefix` + <kbd>I</kbd> でプラグインをインストールしてください ([tpm/README.md at master · tmux-plugins/tpm](https://github.com/tmux-plugins/tpm/blob/master/README.md)) 。

## Ollama のセットアップ手順

`LaunchAgents/com.oki2a24.ollama-env.plist` は、ログイン時に `launchctl setenv` を実行し、Ollama が参照する環境変数を設定します。

現在は次の環境変数を設定しています。

- `OLLAMA_FLASH_ATTENTION=1`
- `OLLAMA_KV_CACHE_TYPE=q8_0`

`Ollama.app` の起動は LaunchAgent では行っていません。macOS によって起動された `Ollama.app` が、ログインセッションの環境変数を継承して動作します。

### 動作確認

以下のコマンドで環境変数が設定されていることを確認できます。

```bash
launchctl getenv OLLAMA_FLASH_ATTENTION
launchctl getenv OLLAMA_KV_CACHE_TYPE
```

期待する出力:

```text
1
q8_0
```

デバッグ時は `LaunchAgents/com.oki2a24.ollama-env.plist` 内のログ出力 (`echo ... >> /tmp/ollama-launchagent.log`) のコメントを外すことで、LaunchAgent の実行を確認できます。
