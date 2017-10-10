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
  call dein#add('w0rp/ale')
  call dein#add('qpkorr/vim-renamer')
  call dein#add('scrooloose/nerdtree')
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('itchyny/lightline.vim')
  call dein#add('tpope/vim-fugitive')
  call dein#add('airblade/vim-gitgutter')

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



" カラースキーム -------------------------
syntax enable
set background=dark
" If you are using a terminal emulator that supports 256 colors and don't want to use the custom Solarized terminal colors, you will need to use the degraded 256 colorscheme.
" https://github.com/altercation/vim-colors-solarized/blob/master/README.mkd#important-note-for-terminal-users
let g:solarized_termcolors=256
colorscheme solarized



" 設定 -------------------------
" Vim内部で使われる文字エンコーディング
set encoding=utf-8
" カレントバッファのファイルの文字エンコーディング
set fileencodings=sjis,utf-8

" 行番号を表示
set number
" タブや改行を表示
set list
" タブや改行を表示する文字
set listchars=tab:>-,extends:<,trail:-,eol:<

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

" 改行での自動コメントアウトをオフ
autocmd FileType * setlocal formatoptions-=ro

" ビープ音を可視化
set visualbell

" ヤンクでクリップボードにコピー
set clipboard=unnamed,autoselect

" カーソルが何行目の何列目に置かれているかを表示
set ruler

" 検索パターンにマッチするテキストを全て強調表示
set hlsearch

" 挿入モードでの <BS> キー動作制御
set backspace=indent,eol,start
