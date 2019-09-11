#!/usr/bin/env bash
#
# Usage:
#   install.sh
#
# Description:
#   Mac または Linux へアプリをインストールするスクリプトを呼び出し、実行します。
#
###########################################################################

set -eu

readonly CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

is_osx() {
  [ $(uname) == "Darwin" ]
}

main() {
  if is_osx; then
    bash "${CURRENT_DIR}/install_brew.sh"
    bash "${CURRENT_DIR}/install_app.sh"
  else
    bash "${CURRENT_DIR}/install_linuxbrew.sh"
    bash "${CURRENT_DIR}/install_linuxapp.sh"
  fi
}
main
