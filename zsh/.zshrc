autoload -U compinit && compinit

alias ls='ls -F -G'
alias ll='ls -l'

[[ -d ~/.composer/vendor/bin/ ]] && export PATH=$HOME/.composer/vendor/bin:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
export PATH="/usr/local/sbin:$PATH"
