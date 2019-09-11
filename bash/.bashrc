[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias ls='ls -F -G'
alias ll='ls -l'

readonly PS1PC_START='\[\e[1;32m\]\u@\h\[\e[m\]:\[\e[1;34m\]\W\[\e[m\]'
readonly PS1PC_END='\$ '
export PS1="${PS1PC_START}${PS1PC_END}"

# WSL で Homebrew インストール済みならば使用
[[ -r "/home/linuxbrew/.linuxbrew/bin/brew" ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# bash-completion を使用
type brew > /dev/null 2>&1 && [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# ターミナルでタブ補完を有効
type brew > /dev/null 2>&1 && source $(brew --prefix)/etc/bash_completion.d/git-completion.bash

# プロンプトに各種追加情報を表示
type brew > /dev/null 2>&1 && source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
if type __git_ps1 > /dev/null 2>&1 ; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_SHOWCOLORHINTS=true
  PROMPT_COMMAND='\
    __git_ps1 \
    "${PS1PC_START}" \
    "${PS1PC_END}" \
  '
fi

[[ -d ~/.composer/vendor/bin/ ]] && export PATH=$HOME/.composer/vendor/bin:$PATH
