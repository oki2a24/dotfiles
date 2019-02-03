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
