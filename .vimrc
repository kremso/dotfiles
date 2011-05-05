call pathogen#runtime_append_all_bundles()

" Basics {{{
    set nocompatible
    syntax on
    set encoding=utf-8
" }}}

" General {{{
    filetype plugin indent on " load filetype plugins/indent settings
    " set autochdir " always switch to the current file directory
    set backspace=indent,eol,start " make backspace a more flexible
    set backup " make backup files
    set backupdir=~/.vim/tmp/backup " where to put backup files
    set directory=~/.vim/tmp/swap " directory to place swap files in
    set undodir=~/.vim/tmp/undo " directory to place undo files in
    set clipboard+=unnamed,unnamedplus,autoselect " share clipboard
    set hidden " you can change buffers without saving
    set mouse=a " use mouse everywhere
    set noerrorbells " don't make noise
    set wildmenu " turn on command line completion wild style
    " ignore these list file extensions
    set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,
                    \*.jpg,*.gif,*.png
    set wildmode=list:longest " turn on wild mode huge list
    set ttyfast " I have a fast terminal
    set undofile " make undo possible after the file is closed and reopened
    set gdefault " global substitutions are default s/a/b/g
    set ttimeoutlen=50  " Make Esc work faster
    if has("balloon_eval") && has("unix")
      set ballooneval
    endif
" }}}

" Vim UI {{{
    set background=dark
    colorscheme molokai
    set incsearch " incremental search aka search as you type
    set hlsearch " highlight search matches
    nnoremap <leader><space> :noh<cr> " this key combination gets rid of the search highlights
    set ignorecase " ignore case
    set smartcase " but when the query starts with upper character be case sensitive

    set laststatus=2 " always show the status line
    set lazyredraw " do not redraw while running macros
    set linespace=0 " don't insert any extra pixel lines between rows
    set list " show traling listchars
    set listchars=tab:▸\ ,trail:¬
    set nostartofline " move the cursor to first non-blank character after some commands (:25 e.g.)
    set novisualbell " don't blink
    set number " turn on line numbers
    set report=0 " tell us when anything is changed
    set ruler " Always show current positions along the bottom
    set shortmess=atToOI " shortens messages to avoid 'press a key' prompt
    set showcmd " show the command being typed
    set showmatch " show matching brackets
    set scrolloff=5 " Keep 10 lines (top/bottom) for scope
    set sidescrolloff=10 " Keep 5 lines at the size
    set cursorline " visually mark current line
"}}}

" Text Formatting/Layout {{{
    set expandtab " no real tabs please!
    set wrap "wrap text
    set textwidth=79 " to 79 characters
    "set colorcolumn=85 " and warn me if my line gets over 85 characters
    set formatoptions=cqt " see :help fo-table
    set infercase " case inferred by default
    set shiftround " round the indent to shiftwidth (when at 3 spaces, and I hit > go to 4, not 5)
    set shiftwidth=2 " auto-indent amount when using >> <<
    set softtabstop=2 " when hitting tab or backspace, how many spaces should a tab be (see expandtab)
    set tabstop=4 " real tabs should be 4, and they will show with set list on
" }}}

" Folding {{{
    set foldenable " Turn on folding
    set foldmethod=marker " Fold on the marker
    " set foldlevel=100 " Don't autofold anything (but I can still fold manually)
    set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds

    function! SimpleFoldText() " {{{
        return getline(v:foldstart).' '
    endfunction " }}}

    set foldtext=SimpleFoldText() " Custom fold text function (cleaner than default)
" }}}

" Completions {{{
    set completeopt=longest,menu
    "                   |      |
    "                   |      +-- Do not display 1 line menu
    "                   +-- display completion popup menu

    set complete=.,w,b,t
" }}}

" Mappings {{{
    let mapleader = ","

    nnoremap <space> za " open/close folds with space

    " I hit F1 too often when reaching for esc
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>

    map <F5> :Run<CR>
    imap <F5> <Esc><F5>

    nnoremap <silent> <F12> :NERDTreeToggle <CR> " F12 toggles file explorer

    " Make ' remember line/column {{{
        nnoremap ' `
        nnoremap ` '
    " }}}

    " convenient window switching {{{
        map <C-h> <C-w>h
        map <C-j> <C-w>j
        map <C-k> <C-w>k
        map <C-l> <C-w>l
    " }}}

    " Emacs-like keybindings {{{
    cnoremap <C-a> <Home>
    cnoremap <C-e> <End>
    inoremap <C-a> <Esc>^i
    inoremap <C-e> <Esc>A
    " }}}

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

    " Cucumber table aligning {{{
    inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

    function! s:align()
      let p = '^\s*|\s.*\s|\s*$'
      if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
      endif
    endfunction
    " }}}
" }}}

" Leader Mappings {{{
  " strip all trailing whitespace in the current file
  nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

  " start ack search
  nnoremap <leader>a :Ack

  " edit .vimrc
  nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

  " open vertical split and switch to it
  nnoremap <leader>w <C-w>v<C-w>l
" }}}

" Autocommands {{{
    augroup FTMics
      autocmd!
      au FocusLost * :wall
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
      autocmd FileType c,cpp,cs,java          setlocal ai et sta sw=4 sts=4 cin
      autocmd FileType sh,csh,tcsh,zsh        setlocal ai et sta sw=4 sts=4
      autocmd FileType tcl,perl,python        setlocal ai et sta sw=4 sts=4
      autocmd FileType javascript             setlocal ai et sta sw=2 sts=2 ts=2 cin isk+=$
      autocmd FileType php,aspperl,aspvbs,vb  setlocal ai et sta sw=4 sts=4
      autocmd FileType apache,sql,vbnet       setlocal ai et sta sw=4 sts=4
      autocmd FileType tex,css                setlocal ai et sta sw=2 sts=2
      autocmd FileType tex                    setlocal fo+=t " autowrap text
      autocmd FileType html,xhtml,wml,cf      setlocal ai et sta sw=2 sts=2
      autocmd FileType xml,xsd,xslt           setlocal ai et sta sw=2 sts=2 ts=2
      autocmd FileType eruby,yaml,ruby        setlocal ai et sta sw=2 sts=2
      autocmd FileType cucumber               setlocal ai et sta sw=2 sts=2 ts=2
      autocmd FileType text,txt,mail          setlocal ai com=fb:*,fb:-,n:>
      autocmd FileType sh,zsh,csh,tcsh        inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
      autocmd FileType perl,python,ruby       inoremap <silent> <buffer> <C-X>! #!/usr/bin/<C-R>=&ft<CR>
      autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
      autocmd FileType sh,zsh,csh,tcsh,perl,python,ruby imap <buffer> <C-X>& <C-X>!<Esc>o <C-U># $I<C-V>d$<Esc>o <C-U><C-X>^<Esc>o <C-U><C-G>u
      autocmd FileType c,cpp,cs,java,perl,javscript,php,aspperl,tex,css let b:surround_101 = "\r\n}"
      autocmd FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
      autocmd FileType context set spell spelllang=sk_SK
      autocmd FileType css  silent! setlocal omnifunc=csscomplete#CompleteCSS
      autocmd FileType cucumber silent! compiler cucumber | imap <buffer><expr> <Tab> pumvisible() ? "\<C-N>" : (CucumberComplete(1,'') >= 0 ? "\<C-X>\<C-O>" : (getline('.') =~ '\S' ? ' ' : "\<C-I>"))
      autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
      autocmd FileType gitcommit setlocal spell
      autocmd FileType html setlocal iskeyword+=~
      autocmd FileType ruby silent! compiler ruby | setlocal tw=79 isfname+=: makeprg=rake comments=:#\  | let &includeexpr = 'tolower(substitute(substitute('.&includeexpr.',"\\(\\u\\+\\)\\(\\u\\l\\)","\\1_\\2","g"),"\\(\\l\\|\\d\\)\\(\\u\\)","\\1_\\2","g"))'
      autocmd FileType text,txt setlocal tw=78 linebreak nolist
      autocmd FileType tex  silent! compiler tex | setlocal makeprg=latex\ -interaction=nonstopmode\ % formatoptions+=l
      autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
      autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
    augroup END
" }}}

" Plugins settings {{{
    runtime macros/matchit.vim

    " showmarks {{{
        let g:showmarks_include="abcdefghijklmnopqrstuvwxyz"
    " }}}

    " supertab {{{
      let g:SuperTabDefaultCompletionType = 'context'
      let g:SuperTabContextDefaultCompletionType = '<c-n>'
    " }}}

    " syntastic {{{
    let g:syntastic_auto_loc_list=1
    let g:syntastic_enable_signs=1
    let g:synastic_quiet_warnings=1
    " }}}

    " Fuzzyfilefinder {{{
        map <silent> <C-f> :FufFile **/<cr>
        map <silent> <C-b> :FufBuffer<cr>
    " }}}

    " YankRing {{{
       nnoremap <silent> <F11> :YRShow<CR>
       inoremap <silent> <F11> <esc>:YRShow<CR>
    " }}}

    " Rubycomplete {{{
        let g:rubycomplete_rails=1
        let g:rubycomplete_classes_in_global=1
        let g:rubycomplete_buffer_loading=1
        let g:rubycomplete_include_object=1
        let g:rubycomplete_include_objectspace=1
    " }}}

    " Taglist {{{
        let Tlist_Process_File_Always=1
        let Tlist_Use_Right_Window=1
        let Tlist_Show_One_File=1
    " }}}

    " YankRing {{{
      let g:yankring_history_dir = '~/.vim'
    " }}}
" }}}

" Language specific {{{
  " JavaScript {{{
    " https://gist.github.com/725689
    au BufNewFile,BufRead *.js set makeprg=gjslint\ %

    au BufNewFile,BufRead *.js set errorformat=%-P-----\ FILE\ \ :\ \ %f\ -----,Line\ %l\\,\ E:%n:\ %m,%-Q,%-GFound\ %s,%-GSome\ %s,%-Gfixjsstyle%s,%-Gscript\ can\ %s,%-G
  " }}}
" }}}

" GUI settings {{{
  autocmd GUIEnter * colorscheme molokai
  autocmd GUIEnter * set guioptions-=m
  autocmd GUIEnter * set guioptions-=T
  autocmd GUIEnter * set gfn=Bitstream\ Vera\ Sans\ Mono\ 9
  autocmd GUIEnter * set vb t_vb= " disable visual bell
" }}}

" Commands {{{
function! Run()
  let old_makeprg = &makeprg
  let cmd = matchstr(getline(1),'^#!\zs[^ ]*')
  if exists("b:run_command")
    exe b:run_command
  elseif cmd != '' && executable(cmd)
    wa
    let &makeprg = matchstr(getline(1),'^#!\zs.*').' %'
    make
  elseif &ft == "mail" || &ft == "text" || &ft == "help" || &ft == "gitcommit"
    setlocal spell!
  elseif exists("b:rails_root") && exists(":Rake")
    wa
    Rake
  elseif &ft == "ruby"
    wa
    if executable(expand("%:p")) || getline(1) =~ '^#!'
      compiler ruby
      let &makeprg = "ruby"
      make %
    elseif expand("%:t") =~ '_test\.rb$'
      compiler rubyunit
      let &makeprg = "ruby"
      make %
    elseif expand("%:t") =~ '_spec\.rb$'
      compiler ruby
      let &makeprg = "bundle exec rspec"
      make %
    else
      !irb -r"%:p"
    endif
  elseif &ft == "html" || &ft == "xhtml" || &ft == "php" || &ft == "aspvbs" || &ft == "aspperl"
    wa
    if !exists("b:url")
      call OpenURL(expand("%:p"))
    else
      call OpenURL(b:url)
    endif
  elseif &ft == "vim"
    wa
    unlet! g:loaded_{expand("%:t:r")}
    return 'source %'
  elseif &ft == "sql"
    1,$DBExecRangeSQL
  elseif expand("%:e") == "tex"
    wa
    exe "normal :!rubber -f %:r && xdvi %:r >/dev/null 2>/dev/null &\<CR>"
  else
    wa
    if &makeprg =~ "%"
      make
    else
      make %
    endif
  endif
  let &makeprg = old_makeprg
  return ""
endfunction
command! -bar Run :execute Run()
" }}}
