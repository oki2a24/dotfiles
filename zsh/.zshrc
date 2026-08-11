autoload -U compinit && compinit

alias ls='ls -F -G'
alias ll='ls -l'

[[ -d ~/.composer/vendor/bin/ ]] && export PATH=$HOME/.composer/vendor/bin:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
export PATH="/usr/local/sbin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/oki2a24/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

fpath=(~/.zfunc $fpath)
autoload -Uz compinit
compinit

# Pi
export PATH="/Users/oki2a24/.hermes/node/bin:$PATH"

# シェル関数分離: codex/claude/pi with HERDR_ENV provider injection
__run_with_provider_if_herdr() {
  local cmd=$1
  shift
  if [[ -n ${HERDR_ENV:-} && ${HERDR_ENV:-} == 1 ]]; then
    command "$cmd" --provider ollama "$@"
  else
    command "$cmd" "$@"
  fi
}

codex() { __run_with_provider_if_herdr codex "$@"; }
claude() { __run_with_provider_if_herdr claude "$@"; }
pi() { __run_with_provider_if_herdr pi "$@"; }

