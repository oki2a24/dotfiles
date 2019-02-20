set encoding=utf-8
scriptencoding utf-8

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
  call dein#add('w0rp/ale')
  call dein#add('qpkorr/vim-renamer')
  call dein#add('scrooloose/nerdtree')
  call dein#add('itchyny/lightline.vim')
  call dein#add('tpope/vim-fugitive')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('posva/vim-vue', { 'on_ft' : [ 'vue' ] })
  call dein#add('luochen1990/rainbow')

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

" Start lightline Scripts------------------
set laststatus=2
" https://github.com/itchyny/lightline.vim#introduction
if !has('gui_running')
  set t_Co=256
endif
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
" End lightline Scripts--------------------

" Start rainbow Scripts------------------
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
" End rainbow Scripts--------------------

" 全角スペースを可視化
" https://vim-jp.org/vim-users-jp/2009/07/12/Hack-40.html
augroup highlightIdegraphicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

" カラースキーム -------------------------
" なし
colorscheme default

" 設定 -------------------------
" カレントバッファのファイルの文字エンコーディング
set fileencodings=utf-8,sjis

" 行番号を表示
set number
" タブや改行を表示
set list
" タブや改行を表示する文字
set listchars=tab:>-,extends:<,trail:-,eol:<

" 常にタブラインを表示
set showtabline=2
" タブ入力を複数の空白入力に置き換え
set expandtab
" タブ表示時の幅
set tabstop=2
" (自動)インデントの各段階に使われる空白の数
set shiftwidth=2
" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=2
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
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

" ウィンドウの最後の行ができる限りまで表示
set display=lastline

" マウスを5モード全てで利用可能にする。
" ノーマルモードおよび端末モード
" ビジュアルモード
" 挿入モード
" コマンドラインモード
" ヘルプファイルを閲覧しているときの上記のモード全て
if has("mouse")
  set mouse=a
endif

" Vim 起動時に非点滅のブロックタイプのカーソル
let &t_te .= "\e[2 q"
" 挿入モード時に非点滅の縦棒タイプのカーソル
let &t_SI .= "\e[6 q"
" ノーマルモード時に非点滅のブロックタイプのカーソル
let &t_EI .= "\e[2 q"
" 置換モード時に非点滅の下線タイプのカーソル
let &t_SR .= "\e[4 q"
" vim 終了時にカーソルを mintty のデフォルトに設定
let &t_te .= "\e[0 q"
