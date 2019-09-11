[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias ls='ls -F -G'
alias ll='ls -l'

# WSL で Homebrew インストール済みならば使用
[[ -r "/home/linuxbrew/.linuxbrew/bin/brew" ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# bash-completion を使用
type brew > /dev/null 2>&1 && [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# ターミナルでタブ補完を有効
type brew > /dev/null 2>&1 && source $(brew --prefix)/etc/bash_completion.d/git-completion.bash

[[ -d ~/.composer/vendor/bin/ ]] && export PATH=$HOME/.composer/vendor/bin:$PATH

type starship > /dev/null 2>&1 && eval "$(starship init bash)"
