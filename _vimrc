"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" �v���O�C���̃C���X�g�[����
let s:dein_dir = expand('~/.cache/dein')
" dein.vim �{�̃C���X�g�[����
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim ���Ȃ���� github �������
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  "execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
  "Windows
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" �v���O�C���ݒ�
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



" ���̑��A���h���Ɋւ���ݒ�:
" ��Ƀ^�u���C����\��
set showtabline=2

" GUI �ŗL�ł͂Ȃ���ʕ\���̐ݒ�:
" �s�ԍ���\��
set number
" �^�u����s��\��
set list
" �ǂ̕����Ń^�u����s��\�����邩��ݒ�
set listchars=tab:>-,extends:<,trail:-,eol:<

" �t�@�C������Ɋւ���ݒ�:
" �o�b�N�A�b�v�t�@�C�����쐬���Ȃ�
set nobackup

" ���͂���Ă���e�L�X�g�̍ő啝�B�s�������蒷���Ȃ�ƁA���̕��𒴂��Ȃ��悤�ɋ󔒂̌�ŉ��s�����B�l�� 0 �ɐݒ肷��Ɩ���
set textwidth=0

" undo �t�@�C�����쐬���Ȃ�
set noundofile

" markdown �̃n�C���C�g��L�\�ɂ���
set syntax=markdown
au BufRead,BufNewFile *.md set filetype=markdown
