"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/tomas/.local/share/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/tomas/.local/share/dein')
  call dein#begin('/home/tomas/.local/share/dein')

  call dein#add('mhinz/vim-startify')
  "call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
  "call dein#add('bogado/file-line')
  "call dein#add('itchyny/vim-cursorword')
  "call dein#add('vim-airline/vim-airline')
  " call dein#add('Shougo/deoplete.nvim')
  call dein#add('zxqfl/tabnine-vim')
  call dein#add('janko-m/vim-test')

  call dein#add('kern/vim-es7')
  call dein#add('hail2u/vim-css3-syntax')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('hashivim/vim-terraform')
  call dein#add('wavded/vim-stylus.git')
  call dein#add('kchmck/vim-coffee-script')
  call dein#add('groenewege/vim-less')
  call dein#add('vim-ruby/vim-ruby')

  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-ragtag')
  "call dein#add('mattn/emmet-vim')
  call dein#add('tpope/vim-commentary')
  "call dein#add('tmux-plugins/vim-tmux-focus-events')
  "call dein#add('mbbill/undotree')

  call dein#add('tomasr/molokai')
  call dein#add('goatslacker/mango.vim')
  call dein#add('trevordmiller/nova-vim')

  "call dein#add('tpope/vim-projectionist')
  "call dein#add('gavinbeatty/dragvisuals.vim')
  call dein#add('tpope/vim-fugitive')
  call dein#add('tpope/vim-rhubarb')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-rails')
  call dein#add('tpope/vim-endwise')
  " include gems in path (for navigation etc.)
  call dein#add('tpope/vim-eunuch')
  call dein#add('tpope/vim-bundler')
  call dein#add('tpope/vim-dispatch')
  call dein#add('thoughtbot/vim-rspec')
  "call dein#add('t9md/vim-ruby-xmpfilter')
  "call dein#add('christoomey/vim-tmux-navigator')
  "call dein#add('Shougo/denite.nvim')
  set rtp+=~/.fzf
  call dein#add('junegunn/fzf')
  call dein#add('junegunn/fzf.vim')
  call dein#add('Shougo/neomru.vim')
  "call dein#add('tpope/vim-vinegar')
  call dein#add('justinmk/vim-dirvish')

  "call dein#add('majutsushi/tagbar')
  "call dein#add('shime/vim-livedown')
  "call dein#add('w0rp/ale')

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
"
" Basics {{{
    set nocompatible
    set shell=/bin/bash\ --login
    filetype plugin indent on " load filetype plugins/indent settings
    syntax on
    set encoding=utf-8
    set exrc " read local .vimrc files
    set secure " do not allow autocmds and shell commands from local .vimrcs
    set backspace=indent,eol,start " make backspace a more flexible
    set nobackup " don't make backup files
    set directory=~/.config/nvim/temp/swap " directory to place swap files in
    set undodir=~/.config/nvim/temp/undo " directory to place undo files in
    set clipboard=unnamedplus " share clipboard with X
    set hidden " you can change buffers without saving
    set mouse=a " use mouse everywhere
    set noerrorbells " don't make noise
    set wildmenu " turn on command line completion wild style
    " ignore these list file extensions
    set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,
                    \*.jpg,*.gif,*.png
    set wildmode=full
    set ttyfast " I have a fast terminal
    set undofile " make undo possible after the file is closed and reopened
    set gdefault " global substitutions are default s/a/b/g
    set ttimeoutlen=50  " Make Esc work faster

    " Make the current window big, but leave others context
    set winwidth=84
    " We have to have a winheight bigger than we want to set winminheight. But if
    " we set winheight to be huge before winminheight, the winminheight set will
    " fail.
    set winheight=5
    set winminheight=5
    set winheight=999

    set lazyredraw " do not redraw while running macros
    set linespace=0 " don't insert any extra pixel lines between rows
    set list " show traling listchars
    set listchars=tab:▸\ ,trail:¬,extends:❯,precedes:❮,nbsp:~
    set nostartofline " don't move the cursor to first non-blank character after some commands (:25 e.g.)
    set novisualbell " don't blink
    set relativenumber " turn on line numbers
    set report=0 " tell us when anything is changed
    set ruler " Always show current positions along the bottom
    set shortmess=atToOI " shortens messages to avoid 'press a key' prompt
    set showmatch " show matching brackets
    set scrolloff=5 " Keep 10 lines (top/bottom) for scope
    set sidescrolloff=10 " Keep 5 lines at the size
    set cursorline " visually mark current line
    set showbreak=↪ " indicate wrapped line
    set expandtab " no real tabs please!
    set wrap "wrap text
    set textwidth=0 " don't wrap text with newlines
    "set colorcolumn=85 " and warn me if my line gets over 85 characters
    set formatoptions=cqt " see :help fo-table
    set shiftround " round the indent to shiftwidth (when at 3 spaces, and I hit > go to 4, not 5)
    set shiftwidth=2 " auto-indent amount when using >> <<
    set softtabstop=2 " when hitting tab or backspace, how many spaces should a tab be (see expandtab)
    set tabstop=4 " real tabs should be 4, and they will show with set list on
    set autoindent
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$' " Highlight VCS conflict markers"
" }}}
" Searching {{{
    set incsearch " incremental search aka search as you type
    set hlsearch " highlight search matches
    set ignorecase " ignore case
    set smartcase " but when the query starts with upper character be case sensitive
" }}}
" Statusline {{{
    set laststatus=2 " always show the status line
    set showmode " show current mode
    set showcmd " show the command being typed
" }}}
" Folding {{{
    set foldenable " Turn on folding
    set foldmethod=marker " Fold on the marker
    " set foldlevel=100 " Don't autofold anything (but I can still fold manually)
    set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds

    function! MyFoldText() " {{{
      let line = getline(v:foldstart)

      let nucolwidth = &fdc + &number * &numberwidth
      let windowwidth = winwidth(0) - nucolwidth - 3
      let foldedlinecount = v:foldend - v:foldstart

      " expand tabs into spaces
      let onetab = strpart('          ', 0, &tabstop)
      let line = substitute(line, '\t', onetab, 'g')

      let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
      let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 6
      return line . '  …' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
    endfunction " }}}

    set foldtext=MyFoldText()
" }}}
" Completions {{{
set completeopt=longest,menu,preview
"                   |      |    |
"                   |      |    +-- show extra information
"                   |      |
"                   |      +-- do not display 1 line menu
"                   +-- display completion popup menu
" }}}
" Mappings {{{
    " I hit F1 too often when reaching for esc
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>

    " Make ' remember line/column
    nnoremap ' `
    nnoremap ` '

    " convenient window switching
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

    " Treat long softwrapped lines as multiple lines
    nmap j gj
    nmap k gk
    vmap j gj
    vmap k gk

    " jj exits insert mode
    inoremap jj <esc>

    " fix vim's regexps
    nnoremap / /\v
    vnoremap / /\v

    " sudo save
    cmap w!! w !sudo tee % >/dev/null

    noremap <c-u> <c-u>zz
    noremap <c-d> <c-d>zz

    map <tab> % " move between pair characters by using tab

    " Keep search matches in the middle of the window.
    nnoremap n nzzzv
    nnoremap N Nzzzv

    " Same when jumping around
    nnoremap g; g;zz
    nnoremap g, g,zz

    " Don't move on *
    nnoremap * *<c-o>

    " Easier to type, and I never use the default behavior.
    noremap H ^
    noremap L $

    " Goodbye manual key
    nnoremap K <nop>

    " Record macros with Q and ditch the Ex mode that is bound to Q by default
    nnoremap q <nop>
    nnoremap Q q
" }}}
" Operator Mappings {{{
  onoremap imp :<c-u>execute "normal! ?def\r:nohlsearch\rf(lvt)"<cr>
" }}}
" Leader Mappings {{{
  let mapleader = ","

  " this key combination gets rid of the search highlights
  nnoremap <leader><space> :noh<cr>

  " strip all trailing whitespace in the current file
  nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

  " start ag search
  nnoremap <leader>a :Ag

  " edit .vimrc
  nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

  " source .vimrc
  nnoremap <leader>sv :source $MYVIMRC<cr>

  " open vertical split and switch to it
  nnoremap <leader>w <C-w>v<C-w>l

  " reformat whole file
  nnoremap <leader>= ggVG=

  " initialize object from parameters
  function! InitializeFromParameters()
    let saved_unnamed_register = @@

    normal! ?def
f(yi(
    let params = split(@@, ",")
    let lines = []
    for param in params
      let cleaned_param = substitute(param, '^\s*\(.\{-}\)\s*$', '\1', '')
      call add(lines, "@" . cleaned_param . " = " . cleaned_param)
    endfor
    call append(line('.'), lines)
    nohlsearch

    let @@ = saved_unnamed_register
  endfunction

  nnoremap <leader>i :call InitializeFromParameters()<cr>
  inoremap <leader>i <esc>:call InitializeFromParameters()<cr>

  " Switch between the last two files
  nnoremap <leader><leader> <c-^>
" }}}
" Find matching pair characters {{{
  runtime macros/matchit.vim
" }}}
" Resize splits when the window is resized {{{
  augroup FTResizeSplits
    autocmd!
    au VimResized * exe "normal! \<c-w>="
  augroup END
" }}}
" Manipulate pair characters {{{
" }}}
" Autoclose HTML elements {{{
" }}}
" Comment/uncomment {{{
" }}}


" let g:deoplete#enable_at_startup = 1
" " Let <Tab> also do completion
" inoremap <silent><expr> <Tab>
" \ pumvisible() ? "\<C-n>" :
" \ deoplete#mappings#manual_complete()


source ~/.config/nvim/colors.vim
source ~/.config/nvim/autosave.vim
source ~/.config/nvim/colors.vim
source ~/.config/nvim/css.vim
source ~/.config/nvim/directories.vim
source ~/.config/nvim/drag_visuals.vim
source ~/.config/nvim/file_explorer.vim
source ~/.config/nvim/git.vim
source ~/.config/nvim/quickfix.vim
source ~/.config/nvim/rails.vim
source ~/.config/nvim/ruby.vim
source ~/.config/nvim/swapfiles.vim
source ~/.config/nvim/tmux.vim
source ~/.config/nvim/vagrant.vim
source ~/.config/nvim/fzf.vim

" Escape/unescape & < > HTML entities in range (default current line).
function! HtmlEntities(line1, line2, action)
  let search = @/
  let range = 'silent ' . a:line1 . ',' . a:line2
  if a:action == 0  " must convert &amp; last
    execute range . 'sno/&lt;/</e'
    execute range . 'sno/&gt;/>/e'
    execute range . 'sno/&amp;/&/e'
  else              " must convert & first
    execute range . 'sno/&/&amp;/e'
    execute range . 'sno/</&lt;/e'
    execute range . 'sno/>/&gt;/e'
    execute range . 'sno/”/"/e'
  endif
  nohl
  let @/ = search
endfunction
command! -range -nargs=1 Entities call HtmlEntities(<line1>, <line2>, <args>)
noremap <silent> \h :Entities 0<CR>
noremap <silent> \H :Entities 1<CR>

function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

noremap <F12> :call SynGroup()<cr>
