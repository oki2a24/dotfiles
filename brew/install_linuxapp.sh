#!/usr/bin/env bash
#
# Usage:
#   install_linuxapp.sh
#
# Description:
#   Linux へアプリをインストールします。
#
###########################################################################

set -eux

readonly CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

brew bundle install --file=${CURRENT_DIR}/bundle/linux/Brewfile
