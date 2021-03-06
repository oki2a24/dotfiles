set encoding=utf-8
scriptencoding utf-8

" キーマッピング
" プラグインで <Leader> 設定を有効にするためにここで定義
let g:mapleader = "\<Space>"

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/dotfiles/vim/dein.rc.vim'

" 全角スペースを可視化
" https://vim-jp.org/vim-users-jp/2009/07/12/Hack-40.html
augroup highlightIdegraphicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

" 設定 -------------------------
" カレントバッファのファイルの文字エンコーディング
set fileencodings=utf-8,sjis
" □や○文字が崩れる問題を解決
set ambiwidth=double

" 行番号を表示
set number
" カーソルラインをハイライト
set cursorline
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
" 拡張子によってインデントの幅を設定
augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.php setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

" 改行での自動コメントアウトをオフ
autocmd FileType * setlocal formatoptions-=ro

" ビープ音を可視化
set visualbell

" ヤンクでクリップボードにコピー
set clipboard=unnamed,autoselect
" Windows Subsystem for Linux で、ヤンクでクリップボードにコピー
if system('uname -a | grep Microsoft') != ''
  augroup myYank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe', @")
  augroup END
endif

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

" Bash の構文ハイライトをカバー
let g:is_bash = 1

" Markdown 内に書かれているプログラミング言語をハイライト
" http://mattn.kaoriya.net/software/vim/20140523124903.htm
let g:markdown_fenced_languages = [
\ 'bash=sh',
\ 'css',
\ 'html',
\ 'javascript',
\ 'js=javascript',
\ 'json=javascript',
\ 'php',
\]
