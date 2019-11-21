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
