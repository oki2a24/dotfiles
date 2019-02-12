#!/bin/sh

DOTPATH=${HOME}/dotfiles

echo "\$DOTPATH : ${DOTPATH}"
echo "Creat dotfile symbolic links."
for f in .??*
do
  # Exclude dot files
  [[ ${f} = ".bashrc_win_git_bash" ]] && continue
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".mintty" ]] && continue
  [[ ${f} = ".minttyrc" ]] && continue

  ln -sfv ${DOTPATH}/${f} ${HOME}/${f}
done
echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
