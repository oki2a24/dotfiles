"dein Scripts-----------------------------
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
  "execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
  "Windows
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" プラグイン設定
" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " Let dein manage dein
  " Required:
  call dein#add('Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('w0rp/ale')
  call dein#add('qpkorr/vim-renamer')
  call dein#add('scrooloose/nerdtree')
  call dein#add('altercation/vim-colors-solarized')

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

"End dein Scripts-------------------------



" その他、見栄えに関する設定:
" 常にタブラインを表示
set showtabline=2
"タブ入力を複数の空白入力に置き換え
set expandtab
" タブ表示時の幅
set tabstop=2
" (自動)インデントの各段階に使われる空白の数
set shiftwidth=2
"連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=2
"改行時に前の行のインデントを継続する
set autoindent
"改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent

" GUI 固有ではない画面表示の設定:
" 行番号を表示
set number
" タブや改行を表示
set list
" どの文字でタブや改行を表示するかを設定
set listchars=tab:>-,extends:<,trail:-,eol:<

" ファイル操作に関する設定:
" バックアップファイルを作成しない
set nobackup

" 入力されているテキストの最大幅。行がそれより長くなると、この幅を超えないように空白の後で改行される。値を 0 に設定すると無効
set textwidth=0

" undo ファイルを作成しない
set noundofile

" 無名レジスタに入るデータを、*レジスタにも入れる。
set clipboard+=unnamed
