## ディレクトリ概要

このディレクトリには、Windows、macOS、およびLinux環境の構成を行うためのドットファイルが格納されています。セットアップスクリプトは、これらの構成ファイルをユーザーのホームディレクトリにシンボリックリンクとして作成します。

リポジトリはアプリケーションごとに（例: `git`、`vim`、`zsh`、`zellij`、`starship`）構造化されています。Vimプラグイン管理には`vim-jetpack`を、tmuxプラグイン管理には`tpm`を使用しています。

## 主要ファイル

*   `link.sh`: macOSおよびLinux用のシンボリックリンクを設定します。
*   `link.ps1`: Windows用のシンボリックリンクを設定します。
*   `brew/install.sh`: macOSまたはLinuxでHomebrewを使用してアプリケーションをインストールします。
*   `git/.gitconfig`: エイリアスやユーザー情報を含むGitの構成ファイルです。
*   `zsh/.zshrc`: Zshの構成ファイルです。
*   `bash/.bashrc`: Bashの構成ファイルです。
*   `starship/starship.toml`: Starshipクロスシェルプロンプトの構成ファイルです。
*   `tmux/.tmux.conf`: `tpm`によるプラグイン管理を含むtmuxの構成ファイルです。
*   `zellij/config.kdl`: Zellijターミナルマルチプレクサの構成ファイルです。
*   `vim/.vimrc`: `vim-jetpack`によるプラグイン管理を含むVimの構成ファイルです。

## 使用方法

### macOSまたはLinuxでのセットアップ

1.  リポジトリをクローンします。
2.  `link.sh`スクリプトを実行してシンボリックリンクを作成します。
3.  `brew/install.sh`を実行してアプリケーションをインストールします。

### Windowsでのセットアップ

1.  リポジトリをクローンします。
2.  管理者権限のPowerShellで`link.ps1`スクリプトを実行してシンボリックリンクを作成します。

### Vimのセットアップ

Vimプラグインは`vim-jetpack`で管理されます。`.vimrc`は、`vim-jetpack`と`.vimrc`ファイル自体に記載されているプラグインを自動的にインストールするように構成されています。

### Tmuxのセットアップ

Tmuxプラグインは`tpm`で管理されます。`tmux`を起動した後、`prefix + I`を押してプラグインをインストールします。

### 開発規約

*   **Git**: `.gitconfig`は、デフォルトブランチを`main`に設定し、プッシュURLをSSHを使用するように構成しています。また、`vscode`をデフォルトのdiffツールおよびマージツールとして設定しています。
*   **エディター**: `vim`がデフォルトのエディターです。`.vimrc`は、より良い開発体験のためにプラグインで extensively に構成されています。
*   **シェル**: `zsh`と`bash`は、一貫したプロンプト体験のために`starship`で構成されています。`fzf`もファジー検索のために統合されています。
