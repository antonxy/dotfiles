self: super:
let
  customPlugins.vim-buftabline = super.vimUtils.buildVimPlugin {
    name = "vim-buftabline";
    src = super.fetchFromGitHub {
      owner = "ap";
      repo = "vim-buftabline";
      rev = "12f29d2cb11d79c6ef1140a0af527e9231c98f69";
      sha256 = "1m2pwjagpbwalrckbyj2w5llqv6nzdkc5nfblwvj5fwkdiy8lmsn";
    };
  };

in
{
  my_vim = super.vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = ''
      " Must have for vim
      set nocompatible

      " Display nbsp
      set listchars=tab:\|\ ,nbsp:·
      set list

      " Remap ESC on ,,
      map ,, <ESC>
      imap ,, <ESC>

      scriptencoding utf-8

      " Must be *after* pathogen
      filetype plugin indent on

      " Leader
      let mapleader=" "
      " let maplocalleader = "-"

      " Highlighting
      syntax enable

      " Set line numbering
      set number

      " Deal with tabs
      set softtabstop=2
      set tabstop=2    " 1 tab = 2 spaces
      set shiftwidth=2 " Indent with 2 spaces

      " Set mouse on
      set mouse=a

      " Don't set timeout - this breaks the leader use
      set notimeout
      set ttimeout

      " Color lines in a different shade up to 80 columns
      " let &colorcolumn=join(range(101,999),",")

      " Normal backspace
      set backspace=indent,eol,start

      " NERD Tree
      map <C-n> :NERDTreeToggle<CR>

      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

      " Ack
      map <leader>a :Ack<space>

      " Buffer switching
      nnoremap <C-l> :bnext<CR>
      nnoremap <C-h> :bprev<CR>
      nnoremap <C-c> :bn<bar>bd#<CR> " switch to next and close last buffer
    '';

    vimrcConfig.vam.knownPlugins = super.vimPlugins // customPlugins;
    vimrcConfig.vam.pluginDictionaries = [
        { names = [
            # Here you can place all your vim plugins
            # They are installed managed by `vam` (a vim plugin manager)
            "ctrlp"
            "The_NERD_tree"
            "ack-vim"
            "vim-buftabline"
        ]; }
    ];
  };
}
