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
bash "${CURRENT_DIR}/set_bash_completion.sh"
bash "${CURRENT_DIR}/set_composer.sh"
bash "${CURRENT_DIR}/set_docker_bash_completion.sh"
bash "${CURRENT_DIR}/set_fzf.sh"
bash "${CURRENT_DIR}/set_git_completion.sh"
