" dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" プラグインのインストール先
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体インストール先
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim' 

" dein.vim がなければ github から入手
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" プラグイン設定
" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " Let dein manage dein
  " Required:
  call dein#add('Shougo/dein.vim')

  " Add or remove your plugins here:
  let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
  call dein#load_toml(s:toml_file)

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" End dein Scripts-------------------------
