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
      nnoremap <C-c> :bp<bar>bd#<CR> " switch to previous and close last buffer (closing current closes window)

      " Switch between header and implementation
      "
      command! CtrlPSameName call feedkeys(":CtrlP\<cr>".expand('%:t:r'), "t")
      " Source: http://vim.wikia.com/wiki/Easily_switch_between_source_and_header_file#By_modifying_ftplugins
      function <SID>SwitchSourceHeader()
          try
              if (expand("%:t") == expand("%:t:r") . ".h")
                  try
                      find %:t:r.cpp
                  catch /^Vim\%((\a\+)\)\=:E345/
                      " Error: Can't find file. Try inline instead.
                      find %:t:r.inl
                  endtry
              else
                  find %:t:r.h
              endif
          catch /^Vim\%((\a\+)\)\=:E345/
              " If we can't find it in the path, see if it's in ctrlp.
              if exists(":CtrlPSameName") == 2
                  CtrlPSameName
              endif
          endtry
      endfunction

      nnoremap <leader>h :call <SID>SwitchSourceHeader()<CR>
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
            "editorconfig-vim"
        ]; }
    ];
  };
}
