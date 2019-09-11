#!/usr/bin/env bash
#
# Usage:
#   set_bash_completion.sh
#
# Description:
#   bash-completion の設定を追記します。
#
###########################################################################

# 最終行に記述があるのであれば、空白行を追加する
if [[ -e ~/.bash_profile ]] && [[ -n $(tail -1 ~/.bash_profile) ]]; then
  echo "" >> ~/.bash_profile
fi

# bash-completion の設定を追記
grep -q "bash_completion.sh" ~/.bash_profile \
|| cat >> ~/.bash_profile <<'EOF'
# bash-completion を使用
type brew > /dev/null 2>&1 && [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
EOF

# 反映
source ~/.bash_profile
