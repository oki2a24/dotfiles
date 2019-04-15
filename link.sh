#!/bin/sh

readonly DOTPATH=${HOME}/dotfiles

echo "\$DOTPATH : ${DOTPATH}"
echo "Creat dotfile symbolic links."

ln -sfv ${DOTPATH}/bash/.bash_profile_mac ${HOME}/.bash_profile
ln -sfv ${DOTPATH}/git/.gitconfig ${HOME}/.gitconfig
ln -sfv ${DOTPATH}/git/.gitignore ${HOME}/.gitignore
ln -sfv ${DOTPATH}/tmux/.tmux.conf ${HOME}/.tmux.conf
ln -sfv ${DOTPATH}/vim/.vimrc ${HOME}/.vimrc

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  echo "Clone TPM."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
