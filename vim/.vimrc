    set nocompatible              " be iMproved, required
    filetype off                  " required

    set tabstop=4
    set shiftwidth=4
    set expandtab
    set smarttab
    set number
    set ignorecase
    set autoindent
    set showmatch
    set mouse=a
    set autoread
    set ruler
    set relativenumber

    filetype plugin indent on
    syntax on

    let g:netrw_liststyle=3
    let mapleader=" "

    map J <C-e>
    map K <C-y>
    map H <C-u>
    map L <C-d>


" Do not indent public, private, ...
set cindent
set cinoptions=g0

set foldmethod=syntax


set hidden "for lusty explorer



" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
let g:ycm_extra_conf_globlist = [ '/home/anton/ClionProjects/xpt-cpp/*' ]
" Jump commands
nnoremap <leader>jj :YcmCompleter GoTo<CR>
nnoremap <leader>jn :YcmCompleter GoToImprecise<CR>
" Switch .h - .cpp
nnoremap <leader>jh :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
" Help commands
nnoremap <leader>hh :YcmCompleter GetDoc<CR>
nnoremap <leader>hl :YcmDiags<CR>
nnoremap <leader>hf :YcmCompleter FixIt<CR>
nnoremap <leader>ht :YcmCompleter GetType<CR>


Plugin 'xuhdev/vim-latex-live-preview'
let g:livepreview_previewer = 'zathura'

Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

Plugin 'scrooloose/nerdtree'
nnoremap <C-n> :NERDTreeToggle<CR>
" Start NERDTree if no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close vim is NERDTree is last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

Plugin 'majutsushi/tagbar'
nnoremap <leader>t :TagbarOpen [fj]<CR>

Plugin 'fholgado/minibufexpl.vim'
" Buffer commands
nnoremap <C-h> :MBEbp<CR>
nnoremap <C-l> :MBEbn<CR>
nnoremap <C-k> :MBEbd<CR>
nnoremap <leader>bqq :MBEbd!<CR>

Plugin 'rust-lang/rust.vim'
Plugin 'vim-scripts/Conque-GDB'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
