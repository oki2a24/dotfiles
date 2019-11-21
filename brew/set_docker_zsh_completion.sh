#!/usr/bin/env bash
#
# Usage:
#   set_docker_zsh_completion.sh
#
# Description:
#   docker、 docker-machine、 および docker-compose の Zsh タブ補完設定を行います。
#
###########################################################################

# https://docs.docker.com/docker-for-mac/#zsh
etc=/Applications/Docker.app/Contents/Resources/etc
[[ -e $(brew --prefix)/share/zsh/site-functions/_docker ]] || ln -s $etc/docker.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker
[[ -e $(brew --prefix)/share/zsh/site-functions/_docker-machine ]] || ln -s $etc/docker-machine.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker-machine
[[ -e $(brew --prefix)/share/zsh/site-functions/_docker-compose ]] || ln -s $etc/docker-machine.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker-compose
