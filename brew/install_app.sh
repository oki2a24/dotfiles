#!/usr/bin/env bash
#
# Usage:
#   install_app.sh
#
# Description:
#   Mac へアプリをインストールします。
#
###########################################################################

set -eux

readonly CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

brew bundle install --file=${CURRENT_DIR}/bundle/mac/Brewfile
bash "${CURRENT_DIR}/set_docker_bash_completion.sh"
bash "${CURRENT_DIR}/set_docker_zsh_completion.sh"
bash "${CURRENT_DIR}/set_fzf.sh"
