#!/bin/sh

DOTPATH=${HOME}/dotfiles

echo "\$DOTPATH : ${DOTPATH}"
echo "Creat dotfile symbolic links."
for f in .??*
do
  # Exclude files
  [[ ${f} = ".bashrc_win_git_bash" ]] && continue
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".minttyrc" ]] && continue
  [[ ${f} = "LICENSE" ]] && continue
  [[ ${f} = "README.md" ]] && continue
  [[ ${f} = "_gvimrc" ]] && continue
  [[ ${f} = "_vimrc" ]] && continue
  [[ ${f} = "link.ps1" ]] && continue

  ln -sfv ${DOTPATH}/${f} ${HOME}/${f}
done
echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
