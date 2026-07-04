#!/usr/bin/env bash

readonly DOTPATH=${HOME}/dotfiles

echo "\$DOTPATH : ${DOTPATH}"
echo "Creat dotfile symbolic links."

ln -sfv ${DOTPATH}/bash/.bash_profile_mac ${HOME}/.bash_profile
ln -sfv ${DOTPATH}/bash/.bashrc ${HOME}/.bashrc
ln -sfv ${DOTPATH}/git/.gitconfig ${HOME}/.gitconfig
ln -sfv ${DOTPATH}/git/.gitignore ${HOME}/.gitignore
mkdir -p ${HOME}/.config/
ln -sfv ${DOTPATH}/starship/starship.toml ${HOME}/.config/starship.toml
ln -sfv ${DOTPATH}/tmux/.tmux.conf ${HOME}/.tmux.conf
mkdir -p ${HOME}/.vim/
ln -sfv ${DOTPATH}/vim/coc-settings.json ${HOME}/.vim/coc-settings.json
ln -sfv ${DOTPATH}/vim/.vimrc ${HOME}/.vimrc
ln -sfv ${DOTPATH}/zsh/.zshrc ${HOME}/.zshrc
mkdir -p ${HOME}/.gemini/
ln -sfv ${DOTPATH}/.gemini/GEMINI.md ${HOME}/.gemini/GEMINI.md
ln -sfv ${DOTPATH}/.gemini/settings.json ${HOME}/.gemini/settings.json
mkdir -p ${HOME}/.hermes/profiles/
ln -sfv ${DOTPATH}/hermes_profiles/softwareengineer ${HOME}/.hermes/profiles/software-engineer
mkdir -p ${HOME}/.config/zellij/
ln -sfv ${DOTPATH}/zellij/config.kdl ${HOME}/.config/zellij/config.kdl

mkdir -p ${HOME}/Library/LaunchAgents
ln -sfv \
  ${DOTPATH}/LaunchAgents/com.oki2a24.ollama-env.plist \
  ${HOME}/Library/LaunchAgents/com.oki2a24.ollama-env.plist

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  echo "Clone TPM."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
