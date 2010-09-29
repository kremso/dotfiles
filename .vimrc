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
    set clipboard+=unnamed " share clipboard
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
" }}}

" Vim UI {{{
    set background=dark
    colorscheme desert
    set incsearch " incremental search aka search as you type
    set hlsearch " highlight search matches
    nnoremap <leader><space> :noh<cr> " this key combination gets rid of the search highlights
    set ignorecase " ignore case
    set smartcase " but when the query starts with upper character be case sensitive

    set laststatus=2 " always show the status line
    set lazyredraw " do not redraw while running macros
    set linespace=0 " don't insert any extra pixel lines between rows
    set list " show traling listchars
    "set listchars=tab:>-,trail:- " show tabs and trailing
    set listchars=tab:▸\ ,trail:¬
    set nostartofline " move the cursor to first non-blank character after some commands (:25 e.g.)
    set novisualbell " don't blink
    set number " turn on line numbers
    set report=0 " tell us when anything is changed
    set ruler " Always show current positions along the bottom
    set shortmess=aOstT " shortens messages to avoid 'press a key' prompt
    set showcmd " show the command being typed
    set showmatch " show matching brackets
    set scrolloff=5 " Keep 10 lines (top/bottom) for scope
    set sidescrolloff=10 " Keep 5 lines at the size
    set statusline=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    set cursorline " visually mark current line
" }}}

" Text Formatting/Layout {{{
    set expandtab " no real tabs please!
    set wrap "wrap text
    set textwidth=79 " to 79 characters
    set colorcolumn=85 " and warn me if my line gets over 85 characters
    set formatoptions=qrnl " Automatically insert comment leader on return, and let gq format comments
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

" Delimiters made less annoying {{{
    function! IsEmptyPair(str) " {{{
        for pair in split( &matchpairs, ',' ) + [ "''", '""', '``' ]
            if a:str == join( split( pair, ':' ),'' )
                return 1
            endif
        endfor
        return 0
    endfunc " }}}

    function! WithinEmptyPair() " {{{
        let cur = strpart( getline('.'), col('.')-2, 2 )
        return IsEmptyPair( cur )
    endfunc " }}}

    function! SkipDelim(char) " {{{
        let cur = strpart( getline('.'), col('.')-2, 3 )
        if cur[0] == "\\"
            return a:char
        elseif cur[1] == a:char
            return "\<Right>"
        elseif cur[1] == ' ' && cur[2] == a:char
            return "\<Right>\<Right>"
        elseif IsEmptyPair( cur[0] . a:char )
            return a:char . "\<Left>"
        else
            return a:char
        endif
    endfunc " }}}

    inoremap <expr> ) SkipDelim(')')
    inoremap <expr> ] SkipDelim(']')
    inoremap <expr> } SkipDelim('}')
    inoremap <expr> ' SkipDelim("'")
    inoremap <expr> " SkipDelim('"')
    inoremap <expr> ` SkipDelim('`')
    "inoremap <expr> | SkipDelim('|')
    inoremap <expr> <BS>    WithinEmptyPair() ? "\<Right>\<BS>\<BS>"      : "\<BS>"
    inoremap <expr> <CR>    WithinEmptyPair() ? "\<CR>\<CR>\<Up>"         : "\<CR>"
    inoremap <expr> <Space> WithinEmptyPair() ? "\<Space>\<Space>\<Left>" : "\<Space>"

    vmap q( s()<C-R>"<Esc>
    vmap q) s()<C-R>"<Esc>
    vmap q[ s[]<C-R>"<Esc>
    vmap q] s[]<C-R>"<Esc>
    vmap q{ s{}<C-R>"<Esc>
    vmap q} s{}<C-R>"<Esc>
    vmap q' s''<C-R>"<Esc>
    vmap q" s""<C-R>"<Esc>
    vmap q` s``<C-R>"<Esc>
    "vmap q| s||<C-R>"<Esc>
" }}}

" Mappings {{{
    let mapleader = ","

    nnoremap <space> za " open/close folds with space

    " I hit F1 too often when reaching for esc
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>


    " F5 executes if shebang is found {{{
        function! CheckForShebang()
            if (match( getline(1) , '^\#!') == 0)
                map <F5> :!./%<CR>
            else
                unmap <F5>
            end
        endfunction
        map <F6> :call CheckForShebang()
    " }}}

    " tab expands text {{{
    "    function InsertTabWrapper()
    "        let col = col('.') - 1
    "        if !col || getline('.')[col - 1] !~ '\k'
    "            return "\<tab>"
    "        else
    "            return "\<c-p>"
    "        endif
    "    endfunction
    "    imap <tab> <c-r>=InsertTabWrapper()<cr>
    " }}}

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

    inoremap <C-a> <Esc>A

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

    " new scratch buffer
    nmap <leader><tab> :Sscratch<cr><C-W>x<C-j>:resize 15<cr>
" }}}

" Autocommands {{{
    " General {{{
        au FocusLost * :wa
    " }}}

    " ConTeXt {{{
        autocmd FileType context set spell spelllang=sk_SK
    " }}}

    " Ruby {{{
        au BufRead,BufNewFile *.rb,*.rhtml set shiftwidth=2
        au BufRead,BufNewFile *.rb,*.rhtml set softtabstop=2
        au BufRead,BufNewFile *.rb,*.rhtml compiler ruby
    " }}}

    " Pig {{{
        augroup filetypedetect
            au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
        augroup END
    " }}}

    " XML {{{
      au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
    " }}}
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
" }}}

" Language specific {{{
  " Ruby {{{
    if !exists( "*EndToken" )
      function EndToken()
        let current_line = getline( '.' )
        let braces_at_end = '{\s*\(|\(,\|\s\|\w\)*|\s*\)\?$'
        if match( current_line, braces_at_end ) >= 0
          return '}'
        else
          return 'end'
        endif
      endfunction
    endif

    imap <S-CR> <ESC>:execute 'normal o' . EndToken()<CR>O

    let g:rubycomplete_buffer_loading = 1
    let g:rubycomplete_classes_in_global = 1
    let g:rubycomplete_rails = 1
  " }}}
" }}}

" GUI settings {{{
  autocmd GUIEnter * colorscheme ir_black
  autocmd GUIEnter * set guioptions-=m
  autocmd GUIEnter * set guioptions-=T
  autocmd GUIEnter * set gfn=Bitstream\ Vera\ Sans\ Mono\ 9
  autocmd GUIEnter * set vb t_vb= " disable visual bell
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
