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

  basicRC = ''
      " Must have for vim
      set nocompatible

      " Display nbsp and tab
      set listchars=tab:\|\ ,nbsp:·
      set list

      scriptencoding utf-8

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

      " Hightlight search
      set hlsearch

      " NERD Tree
      map <C-n> :NERDTreeToggle<CR>

      " Start NERD Tree if no file opened at start
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

      " Ack
      map <leader>a :Ack<space>

      " Buffer switching
      nnoremap <C-l> :bnext<CR>
      nnoremap <C-h> :bprev<CR>
      nnoremap <C-c> :bp<bar>bd#<CR> " switch to previous and close last buffer (closing current closes window)
      set hidden  " allow switching out of unsaved buffer

      let g:buftabline_indicators=1

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

      " Jumps
      nnoremap <leader>jh :call <SID>SwitchSourceHeader()<CR>

      " Allow saving of files as sudo
      if !exists(":SudoW")
          command SudoW w !sudo tee % > /dev/null
      endif

      " Path for snippets
      " let &runtimepath.=','."~/.config/vim"

  '';

  ideRC = ''
        " Jumps
        nnoremap <leader>jd :call LanguageClient#textDocument_definition()<CR>
        nnoremap <leader>ji :call LanguageClient_textDocument_implementation()<CR>

        " Languange Client
        nnoremap <leader>ll :call LanguageClient_contextMenu()<CR>
        nnoremap <leader>lr :call LanguageClient_textDocument_rename()<CR>
        nnoremap <leader>lh :call LanguageClient_textDocument_hover()<CR>
        nnoremap <leader>la :call LanguageClient_textDocument_codeAction()<CR>

        let g:LanguageClient_serverCommands = {
          \ 'cpp': ['cquery'],
          \ }

        " This will show the popup menu even if there's only one match (menuone),
        " and prevent automatic text injection
        " into the current line (noinsert).
        set completeopt=noinsert,menuone
        
        set completefunc=LanguageClient#complete

        " Insert tab only after nothing but whitespace, else complete
        function! Tab_Or_Complete()
          "if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
          if col('.')>1 && strpart( getline('.'), 0, col('.')+1) !~ '^\s*$'
            return "\<C-X>\<C-O>"
          else
            return "\<Tab>"
          endif
        endfunction
        :inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

  '';
in
{
  my_nvim = super.neovim.override {
    configure = {
      customRC = basicRC + ideRC;
      packages.myVimPackage = with super.vimPlugins // customPlugins; {
        start = [
          ctrlp
          The_NERD_tree
          ack-vim
          vim-buftabline
          editorconfig-vim
          vim-gitgutter
          #snipmate
          LanguageClient-neovim
        ];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [
        ];
        # To automatically load a plugin when opening a filetype, add vimrc lines like:
        # autocmd FileType php :packadd phpCompletion
      };
    };
  };

  my_vim = super.vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = basicRC;
    vimrcConfig.packages.myVimPackage = with super.vimPlugins // customPlugins; {
      start = [
        ctrlp
        The_NERD_tree
        ack-vim
        vim-buftabline
        editorconfig-vim
        vim-gitgutter
        #snipmate
      ];
      # manually loadable by calling `:packadd $plugin-name`
      opt = [
      ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
    };
  };
}
