" Vundle {{{
  filetype off
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
  Bundle 'gmarik/vundle'

  Bundle 'ervandew/supertab'
  Bundle 'kien/ctrlp.vim'
  Bundle 'scrooloose/syntastic'
  Bundle 'scrooloose/nerdtree'
  Bundle 'tpope/vim-rails'
  Bundle 'tpope/vim-dispatch'
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-endwise'
  Bundle 'tpope/vim-commentary'
  Bundle 'gavinbeatty/dragvisuals.vim'
  Bundle 'kremso/vim-spectator'

  " Trial
  Bundle 'rking/ag.vim'
  Bundle 'bling/vim-airline'
  Bundle 'edkolev/tmuxline.vim'

  runtime plugin/rspec
" }}}
" Basics {{{
    set nocompatible
    filetype plugin indent on " load filetype plugins/indent settings
    syntax on
    set encoding=utf-8
    set exrc " read local .vimrc files
    set secure " do not allow autocmds and shell commands from local .vimrcs
    set backspace=indent,eol,start " make backspace a more flexible
    set backup " make backup files
    set backupdir=~/.vim/tmp/backup " where to put backup files
    set directory=~/.vim/tmp/swap " directory to place swap files in
    set undodir=~/.vim/tmp/undo " directory to place undo files in
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

    colorscheme tir_black
    set background=dark
    set t_Co=256
    if &term =~ '256color'
      " Disable Background Color Erase (BCE) so that color schemes
      " work properly when Vim is used inside tmux and GNU screen.
      " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
      set t_ut=
    endif
    set incsearch " incremental search aka search as you type
    set hlsearch " highlight search matches
    set ignorecase " ignore case
    set smartcase " but when the query starts with upper character be case sensitive
    set laststatus=2 " always show the status line
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
    set showcmd " show the command being typed
    set showmode " show current mode
    set showmatch " show matching brackets
    set scrolloff=5 " Keep 10 lines (top/bottom) for scope
    set sidescrolloff=10 " Keep 5 lines at the size
    set cursorline " visually mark current line
    set showbreak=↪ " indicate wrapped line
    set expandtab " no real tabs please!
    set wrap "wrap text
    set textwidth=79 " to 79 characters
    "set colorcolumn=85 " and warn me if my line gets over 85 characters
    set formatoptions=cqt " see :help fo-table
    set shiftround " round the indent to shiftwidth (when at 3 spaces, and I hit > go to 4, not 5)
    set shiftwidth=2 " auto-indent amount when using >> <<
    set softtabstop=2 " when hitting tab or backspace, how many spaces should a tab be (see expandtab)
    set tabstop=4 " real tabs should be 4, and they will show with set list on
    set autoindent
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$' " Highlight VCS conflict markers"
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

    normal! ?deff(yi(
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
" Language specific / filetype autocommands {{{
  " CSS, SCSS {{{
    augroup FTCss
      au!
      au BufRead,BufNewFile *.scss.erb set ft=scss
      autocmd FileType css,scss  silent! setlocal omnifunc=csscomplete#CompleteCSS
      autocmd FileType css,scss  setlocal iskeyword+=-
      autocmd FileType css,scss   setlocal ai et sta sw=2 sts=2
      autocmd FileType scss,sass  syntax cluster sassCssAttributes add=@cssColors
      " Use <leader>S to sort properties.
      au FileType css,scss nnoremap <buffer> <leader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>
      " Make {<cr> insert a pair of brackets in such a way that the cursor is
      " correctly positioned inside of them AND the following code doesn't get unfolded.
      au FileType css,scss inoremap <buffer> {<cr> {}<left><cr>.<cr><esc>k==A<bs>
    augroup END
  " }}}
  " HTML, XML {{{
    augroup FTHtml
      au!
      "au BufRead,BufNewFile *.html.erb set ft=html.erb
      autocmd FileType html,xhtml,wml,cf      setlocal ai et sta sw=2 sts=2
      autocmd FileType xml,xsd,xslt           setlocal ai et sta sw=2 sts=2 ts=2
      autocmd FileType html setlocal iskeyword+=~
      autocmd FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
    augroup END
  " }}}
  " JavaScript {{{
    augroup FTJavascript
      au!
      autocmd FileType javascript setlocal ai et sta sw=2 sts=2 ts=2 cin isk+=$

      " https://gist.github.com/725689
      au BufNewFile,BufRead *.js set makeprg=gjslint\ %
      au BufNewFile,BufRead *.js set errorformat=%-P-----\ FILE\ \ :\ \ %f\ -----,Line\ %l\\,\ E:%n:\ %m,%-Q,%-GFound\ %s,%-GSome\ %s,%-Gfixjsstyle%s,%-Gscript\ can\ %s,%-G
    augroup END
  " }}}
  " TEX {{{
    augroup FTTex
      au!
      autocmd FileType tex                    setlocal fo+=t " autowrap text
      autocmd FileType tex  silent! compiler tex | setlocal makeprg=latex\ -interaction=nonstopmode\ % formatoptions+=l
      autocmd FileType context set spell spelllang=en_US
    augroup END
  " }}}
  " Ruby {{{
    augroup FTRuby
      au!
      autocmd FileType ruby silent! compiler ruby | setlocal tw=79 isfname+=: makeprg=rake comments=:#\  | let &includeexpr = 'tolower(substitute(substitute('.&includeexpr.',"\\(\\u\\+\\)\\(\\u\\l\\)","\\1_\\2","g"),"\\(\\l\\|\\d\\)\\(\\u\\)","\\1_\\2","g"))'
      autocmd FileType eruby,yaml,ruby        setlocal ai et sta sw=2 sts=2
      autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    augroup END
  " }}}
  " Cucumber {{{
    augroup FTCucumber
      au!
      autocmd FileType cucumber               setlocal ai et sta sw=2 sts=2 ts=2
      autocmd FileType cucumber silent! compiler cucumber | imap <buffer><expr> <Tab> pumvisible() ? "\<C-N>" : (CucumberComplete(1,'') >= 0 ? "\<C-X>\<C-O>" : (getline('.') =~ '\S' ? ' ' : "\<C-I>"))
      autocmd FileType ruby iabbr $p "([^"]*)"
    augroup END

    " Cucumber navigation commands
    autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
    " :Cuc my text (no quotes) -> runs cucumber scenarios containing "my text"
    command! -nargs=+ Cuc :!ack --no-heading --no-break <q-args> | cut -d':' -f1,2 | xargs bundle exec cucumber --no-color
  " }}}
  " Plain text {{{
    augroup FTText
      au!
      autocmd FileType text,txt,mail          setlocal ai com=fb:*,fb:-,n:>
      autocmd FileType text,txt setlocal tw=78 linebreak nolist
    augroup END
  " }}}
  " Git {{{
    augroup FTGit
      au!
      autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
      autocmd FileType gitcommit setlocal spell
    augroup END
  " }}}
  " Rails {{{
  map <leader>gr :topleft :split config/routes.rb<cr>
  map <leader>gg :topleft 100 :split Gemfile<cr>

  function! ShowRoutes()
    " Requires 'scratch' plugin
    :topleft 100 :split __Routes__
    " Make sure Vim doesn't write __Routes__ as a file
    :set buftype=nofile
    " Delete everything
    :normal 1GdG
    " Put routes output in buffer
    :0r! rake -s routes
    " Size window to number of lines (1 plus rake output length)
    :exec ":normal " . line("$") . "_ "
    " Move cursor to bottom
    :normal 1GG
    " Delete empty trailing line
    :normal dd
  endfunction
  map <leader>gR :silent call ShowRoutes()<cr>
  " }}}
" }}}
" Miscelancous autocommands {{{
    augroup FTMics
      autocmd!
      au FocusLost * :wall
      " Resize splits when the window is resized
      au VimResized * exe "normal! \<c-w>="
      autocmd BufReadCmd *.jar call zip#Browse(expand("<amatch>"))
      autocmd BufReadPre *.pdf setlocal binary
    augroup END

    augroup FTCheck
      autocmd!
      autocmd BufNewFile,BufRead *.pig set filetype=pig syntax=pig
      autocmd BufNewFile,BufRead */apache2/[ms]*-*/* set ft=apache
      autocmd BufNewFile,BufRead */httpd/[ms]*-*/* set ft=apache
      autocmd BufNewFile,BufRead *named.conf*       set ft=named
      autocmd BufNewFile,BufRead *.feature,*.story  set ft=cucumber
      autocmd BufNewFile,BufRead /etc/udev/*.rules set ft=udev
    augroup END

    augroup FTOptions
      autocmd!
      autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    augroup END

    augroup FTQuickfix
      au!
      au Filetype qf setlocal colorcolumn=0 nolist nocursorline wrap linebreak
    augroup END

    augroup NoSimultaneousEdits
      autocmd!
      autocmd SwapExists * call HandleSwapFile(expand('<afile>:p'))
    augroup END
" }}}
" Create interim directories if necessary {{{
  function! AskQuit (msg, options, quit_option)
    if confirm(a:msg, a:options) == a:quit_option
      exit
    endif
  endfunction

  function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
      call AskQuit("Parent directory '" . required_dir . "' doesn't exist.",
            \       "&Create it\nor &Quit?", 2)

      try
        call mkdir( required_dir, 'p' )
      catch
        call AskQuit("Can't create '" . required_dir . "'",
              \            "&Quit\nor &Continue anyway?", 1)
      endtry
    endif
  endfunction

  augroup AutoMkdir
    autocmd!
    autocmd  BufNewFile  *  :call EnsureDirExists()
  augroup END
" }}}
" Plugins settings {{{
    runtime macros/matchit.vim

    " supertab {{{
      let g:SuperTabDefaultCompletionType = 'context'
      let g:SuperTabContextDefaultCompletionType = '<c-n>'
    " }}}

    " syntastic {{{
    let g:syntastic_auto_loc_list=1
    let g:syntastic_enable_signs=1
    let g:synastic_quiet_warnings=1
    " }}}

    " YankRing {{{
       nnoremap <silent> <F11> :YRShow<CR>
       inoremap <silent> <F11> <esc>:YRShow<CR>
       let g:yankring_history_dir = '~/.vim'
    " }}}

    " Rubycomplete {{{
        let g:rubycomplete_rails=1
        let g:rubycomplete_classes_in_global=1
        let g:rubycomplete_buffer_loading=1
        let g:rubycomplete_include_object=1
        let g:rubycomplete_include_objectspace=1
    " }}}

    " Gundo {{{
      nnoremap <leader>g :GundoToggle<cr>
    " }}}

    " Fugitive {{{
      nnoremap <leader>gs :Gstatus<cr>
      nnoremap <leader>gc :Gcommit<cr>
      nnoremap <leader>gd :Gdiff<cr>
    " }}}

    " NERDTree {{{
      nnoremap <silent> <F12> :NERDTreeToggle <CR> " F12 toggles file explorer
      let g:NERDTreeMinimalUI=1
      let g:NERDTreeDirArrows=1
      let g:NERTreeHighlightCursorLine=1
    "}}}

    " Ctrl-P {{{
    map <leader>f :CtrlP<cr>
    map <leader>b :CtrlPMRU<cr>
    map <leader>gv :CtrlP app/views<cr>
    map <leader>gc :CtrlP app/controllers<cr>
    map <leader>gm :CtrlP app/models<cr>
    " }}}

    " drag visuals {{{
      vmap  <expr>  <LEFT>   DVB_Drag('left')
      vmap  <expr>  <RIGHT>  DVB_Drag('right')
      vmap  <expr>  <DOWN>   DVB_Drag('down')
      vmap  <expr>  <UP>     DVB_Drag('up')
      vmap  <expr>  D        DVB_Duplicate()
    " }}}

    " airline {{{
    let g:airline_powerline_fonts = 1
    " }}}

    " rspec {{{
      map <leader>t :RspecRunFile<cr>
      map <leader>T :RspecRunFocused<cr>
    " }}}
" }}}
" Commands {{{
" Print a message after the autocommand completes
" (so you can see it, but don't have to hit <ENTER> to continue)...
function! DelayedMsg(msg)
    " A sneaky way of injecting a message when swapping into the new buffer...
    augroup DelayedMsg
      autocmd!
      " Print the message on finally entering the buffer...
      autocmd BufWinEnter *  echohl WarningMsg
      exec 'autocmd BufWinEnter *  echon "\r'.printf("%-60s", a:msg).'"'
      autocmd BufWinEnter *  echohl NONE

      " And then remove these autocmds, so it's a "one-shot" deal...
      autocmd BufWinEnter *  augroup AutoSwap_Mac_Msg
      autocmd BufWinEnter *  autocmd!
      autocmd BufWinEnter *  augroup END
    augroup END
endfunction

function! HandleSwapFile(filename)
  " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
    call DelayedMsg("Old swapfile detected...and deleted")
    call delete(v:swapname)
    let v:swapchoice = 'e'
  " otherwise, open file read-only
  else
    call DelayedMsg("Swapfile detected...opening read-only")
    let v:swapchoice = 'o'
  endif
endfunction
" }}}
