#!/usr/bin/env bash
#
# Usage:
#   install_linuxbrew.sh
#
# Description:
#   Linux へ Homebrew をインストールします。
#
###########################################################################

# Homebrew on Linux — Homebrew Documentation https://docs.brew.sh/Homebrew-on-Linux
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential curl file git -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
#test -r ~/.profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
