#!/usr/bin/env bash
#
# Usage:
#   set_composer.sh
#
# Description:
#   Composer の設定を追記します。
#
###########################################################################

# 最終行に記述があるのであれば、空白行を追加する
if [[ -e ~/.bash_profile ]] && [[ -n $(tail -1 ~/.bash_profile) ]]; then
  echo "" >> ~/.bash_profile
fi

# bash-completion の設定を追記
grep -q 'export PATH=$HOME/.composer/vendor/bin:$PATH' ~/.bash_profile \
|| cat >> ~/.bash_profile <<'EOF'
[[ -d ~/.composer/vendor/bin/ ]] && export PATH=$HOME/.composer/vendor/bin:$PATH
EOF

# 反映
source ~/.bash_profile
