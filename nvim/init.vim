""""""""""""""""""""""""""""""""""""""""""""""""""
" # コンセプト
" - バニラ Neovim プラスアルファを心がける。
" - 操作に関しては既存の Vim 設定を維持し、変更しないでそのままとする。
" - UI は自らの好みで好きなタイミングでカスタマイズする。

""""""""""""""""""""""""""""""""""""""""""""""""""
" デフォルト設定の読み込み
" Neovim では $VIMRUNTIME/defaults.vim の代わりに以下を利用
set nocompatible
filetype plugin indent on
syntax on

" キーマッピング
let mapleader = "\<Space>"

" 自動保存・自動読み込みの設定
set autoread
augroup AutoSaveAndRead
  autocmd!
  " フォーカス時やバッファ移動時に外部での変更を検知
  autocmd FocusGained,BufEnter * checktime
  " フォーカスを失った時に自動保存
  autocmd FocusLost * wall
augroup END

" ヤンク時にクリップボードにもコピーする
set clipboard=unnamedplus

""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme に関連する項目
" カーソルがあるテキスト行を CursorLine で強調する。
set cursorline
" 表示に使われる文字を設定
set list
set listchars=tab:>-

""""""""""""""""""""""""""""""""""""""""""""""""""
" ビープ音に、実際は音でなくビジュアルベルを使う。
set visualbell

" 前回の検索パターンが存在するとき、それにマッチするテキストを全て強調表示する。
set hlsearch
