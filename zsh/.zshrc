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
__herdr_current_pane_id() {
  local pane_id
  pane_id=$(herdr pane current --current 2>/dev/null | jq -r '.result.pane_id // empty' 2>/dev/null)
  if [[ -z $pane_id ]]; then
    return 1
  fi
  echo "$pane_id"
}

__herdr_pane_is_agent() {
  local pane_id=$1
  if [[ -z $pane_id ]]; then
    return 1
  fi
  local agents
  agents=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
  [[ -n $agents ]] && printf '%s\n' "$agents" | grep -Fxq "$pane_id"
}

__herdr_pane_exists() {
  local target=$1
  if [[ -z $target ]]; then
    return 1
  fi
  local pane_ids
  pane_ids=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
  [[ -n $pane_ids ]] && printf '%s\n' "$pane_ids" | grep -Fxq "$target"
}

__run_with_provider_if_herdr() {
  local cmd=$1 provider_flag=$2 provider_val=$3
  shift 3
  local pane_id
  pane_id=$(__herdr_current_pane_id 2>/dev/null)
  if [[ -z $pane_id ]]; then
    command "$cmd" "$@"
    return
  fi
  if __herdr_pane_is_agent "$pane_id"; then
    command "$cmd" "$provider_flag" "$provider_val" "$@"
  else
    command "$cmd" "$@"
  fi
}

codex() { __run_with_provider_if_herdr codex --local-provider ollama "$@"; }
claude() { __run_with_provider_if_herdr claude --provider ollama "$@"; }

