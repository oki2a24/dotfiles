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

# Herdr Agent 起動判定によるローカル LLM 強制ロジック
__herdr_pane_exists() {
  local target=$1
  if [[ -z ${HERDR_PANE_ID:-} ]]; then
    return 1
  fi
  local pane_ids
  pane_ids=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
  [[ -n $pane_ids ]] && echo "$pane_ids" | grep -qx "$target"
}

__run_with_provider_if_herdr() {
  local cmd=$1
  shift
  local provider_args=()
  if [[ $# -gt 0 ]]; then
    # collect provider args until we hit first non-option arg? For now assume provider is --local-provider ollama or --provider ollama
    provider_args=("$1" "$2")
    shift 2
  fi
  if [[ -z ${HERDR_PANE_ID:-} ]]; then
    command "$cmd" "$@"
    return
  fi
  if __herdr_pane_exists "$HERDR_PANE_ID"; then
    command "$cmd" "${provider_args[@]}" "$@"
  else
    command "$cmd" "$@"
  fi
}

codex() { __run_with_provider_if_herdr codex --local-provider ollama "$@"; }
claude() { __run_with_provider_if_herdr claude --provider ollama "$@"; }

