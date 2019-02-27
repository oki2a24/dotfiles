#!/bin/sh

readonly DOTPATH=${HOME}/dotfiles

echo "\$DOTPATH : ${DOTPATH}"
echo "Creat dotfile symbolic links."

ln -sfv ${DOTPATH}/.bash_profile_mac ${HOME}/.bash_profile
ln -sfv ${DOTPATH}/.gitconfig ${HOME}/.gitconfig
ln -sfv ${DOTPATH}/.gitignore ${HOME}/.gitignore
ln -sfv ${DOTPATH}/.vimrc ${HOME}/.vimrc

echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
