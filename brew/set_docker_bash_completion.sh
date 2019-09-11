#!/usr/bin/env bash
#
# Usage:
#   set_docker_bash_completion.sh
#
# Description:
#   docker、 docker-machine、 および docker-compose のタブ補完設定を行います。
#
###########################################################################

# https://docs.docker.com/docker-for-mac/#install-shell-completion
etc=/Applications/Docker.app/Contents/Resources/etc
[[ -e $(brew --prefix)/etc/bash_completion.d/docker ]] || ln -s $etc/docker.bash-completion $(brew --prefix)/etc/bash_completion.d/docker
[[ -e $(brew --prefix)/etc/bash_completion.d/docker-machine ]] || ln -s $etc/docker-machine.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-machine
[[ -e $(brew --prefix)/etc/bash_completion.d/docker-compose ]] || ln -s $etc/docker-compose.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-compose
