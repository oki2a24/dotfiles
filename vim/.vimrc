""""""""""""""""""""""""""""""""""""""""""""""""""
" # コンセプト
" - バニラ Vim プラスアルファを心がける。
" - 操作に関しては既存の状態を保ち、変更しないでそのままとすることを心がける。
" - UI は自らの好みで好きなタイミングでカスタマイズする。

""""""""""""""""""""""""""""""""""""""""""""""""""
" https://vim-jp.org/vimdoc-ja/starting.html#defaults.vim
" https://vim-jp.org/vimdoc-ja/usr_05.html#defaults.vim-explained
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" キーマッピング
" プラグインで <Leader> 設定を有効にするためにここで定義
let g:mapleader = "\<Space>"

""""""""""""""""""""""""""""""""""""""""""""""""""
" 全角スペースを可視化 (colorscheme の指定が必要な点に注意)
" https://vim-jp.org/vim-users-jp/2009/07/12/Hack-40.html
augroup highlightIdegraphicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme に関連する項目
" カーソルがあるテキスト行を CursorLine hl-CursorLine で強調する。
set cursorline
" 表示に使われる文字を設定
set list
set listchars=tab:>-

""""""""""""""""""""""""""""""""""""""""""""""""""
" ビープ音に、実際は音でなくビジュアルベル {訳注: 画面フラッシュ} を使う。
set visualbell

" 前回の検索パターンが存在するとき、それにマッチするテキストを全て強調表示する。
set hlsearch

""""""""""""""""""""""""""""""""""""""""""""""""""
" プラグイン管理
" https://github.com/tani/vim-jetpack#automatic-installation-on-startup
" vimrc 配置場所は "$HOME/.vimrc" としているため、プラグイン格納場所として先頭に ".vim/" を追加している。
let s:jetpackfile = expand('<sfile>:p:h') .. '/.vim/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
let s:jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if !filereadable(s:jetpackfile)
  call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpackfile, s:jetpackurl))
endif

" https://github.com/tani/vim-jetpack#vim-plug-style
packadd vim-jetpack
call jetpack#begin()
""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme 以外
""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""
Jetpack 'luochen1990/rainbow'
let g:rainbow_active = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
Jetpack 'neoclide/coc.nvim', {'branch': 'release'}
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#install-extensions
let g:coc_global_extensions = [
  \ 'coc-docker',
  \ 'coc-git',
  \ 'coc-json',
  \ 'coc-phpls',
  \ 'coc-tabnine',
  \ 'coc-tsserver',
  \ 'coc-yaml',
  \ ]
" https://github.com/neoclide/coc.nvim#example-vim-configuration
nmap <Leader>c [coc.nvim]
nnoremap [coc.nvim] <Nop>

" GoTo code navigation
nmap <silent> [coc.nvim]d <Plug>(coc-definition)
nmap <silent> [coc.nvim]y <Plug>(coc-type-definition)
nmap <silent> [coc.nvim]i <Plug>(coc-implementation)
nmap <silent> [coc.nvim]r <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> [coc.nvim]K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" ?????????? 使い方がよくわかっていない
" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap [coc.nvim]rn <Plug>(coc-rename)

" ?????????? 使い方がよくわかっていない
" Remap keys for applying refactor code actions
nmap <silent> [coc.nvim]re <Plug>(coc-codeaction-refactor)
xmap <silent> [coc.nvim]r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> [coc.nvim]r  <Plug>(coc-codeaction-refactor-selected)

" ?????????? 使い方がよくわかっていない
" Run the Code Lens action on the current line
nmap [coc.nvim]cl  <Plug>(coc-codelens-action)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

""""""""""""""""""""""""""""""""""""""""""""""""""
let g:polyglot_disabled = ['sensible']
Jetpack 'sheerun/vim-polyglot'

""""""""""""""""""""""""""""""""""""""""""""""""""
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap

""""""""""""""""""""""""""""""""""""""""""""""""""
Jetpack 'vim-jp/vimdoc-ja'

""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme
""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""
" Jetpack 'aereal/vim-colors-japanesque'
" colorscheme japanesque

""""""""""""""""""""""""""""""""""""""""""""""""""
Jetpack 'joshdick/onedark.vim'
syntax on
" https://github.com/joshdick/onedark.vim/issues/110#issuecomment-345599864
packadd! onedark.vim
colorscheme onedark

""""""""""""""""""""""""""""""""""""""""""""""""""
"Jetpack 'rhysd/vim-color-spring-night'
"colorscheme spring-night

""""""""""""""""""""""""""""""""""""""""""""""""""
" Jetpack 'sainnhe/everforest'
" colorscheme everforest
call jetpack#end()
