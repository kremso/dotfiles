call pathogen#infect()
call pathogen#helptags()

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
    set ignorecase " ignore case
    set smartcase " but when the query starts with upper character be case sensitive

    set laststatus=2 " always show the status line
    set lazyredraw " do not redraw while running macros
    set linespace=0 " don't insert any extra pixel lines between rows
    set list " show traling listchars
    set listchars=tab:▸\ ,trail:¬
    set nostartofline " move the cursor to first non-blank character after some commands (:25 e.g.)
    set novisualbell " don't blink
    set relativenumber " turn on line numbers
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

    set complete=.,w,b,t
" }}}

" Mappings {{{
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

    noremap <c-u> <c-u>zz
    noremap <c-d> <c-d>zz

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

    map <tab> % " move between pair characters by using tab

    " Keep search matches in the middle of the window.
    nnoremap n nzz
    nnoremap N Nzz

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

" }}}

" Leader Mappings {{{
  let mapleader = ","

  nmap <leader><space> :noh<cr> " this key combination gets rid of the search highlights

  " strip all trailing whitespace in the current file
  nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

  " start ack search
  nnoremap <leader>a :Ack 

  " edit .vimrc
  nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

  " open vertical split and switch to it
  nnoremap <leader>w <C-w>v<C-w>l

  " reformat whole file
  nnoremap <leader>f ggVG=

  " show long lines {{{
    function! ShowLongLines()
      highlight OverLength ctermbg=red ctermfg=white guibg=#592929
      match OverLength /\%81v.\+/
    endfunction
    nnoremap <leader>sll :call ShowLongLines()<cr>
  " }}}
" }}}

" Language specific / filetype autocommands {{{
  " CSS, SCSS {{{
    augroup FTCss
      au!
      autocmd FileType css,scss  silent! setlocal omnifunc=csscomplete#CompleteCSS
      autocmd FileType css,scss  setlocal iskeyword+=-
      autocmd FileType css,scss   setlocal ai et sta sw=2 sts=2
      " Use <leader>S to sort properties.
      au BufNewFile,BufRead *.scss,*.css nnoremap <buffer> <leader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>
      " Make {<cr> insert a pair of brackets in such a way that the cursor is
      " correctly positioned inside of them AND the following code doesn't get unfolded.
      au BufNewFile,BufRead *.scss,*.css inoremap <buffer> {<cr> {}<left><cr>.<cr><esc>k==A<bs>

    augroup END
  " }}}
  " HTML, XML {{{
    augroup FTHtml
      au!
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
" }}}

" Miscelancous autocommands {{{
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
      autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
      autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
    augroup END

    augroup FTQuickfix
      au!
      au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap
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
      let g:SuperTabLongestHighlight = 1
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

" Statusline {{{
  augroup ft_statuslinecolor
    au!

    au InsertEnter * hi StatusLine ctermfg=196 guifg=#FF3145
    au InsertLeave * hi StatusLine ctermfg=130 guifg=#CD5907
  augroup END

  set statusline=%f    " Path.
  set statusline+=%m   " Modified flag.
  set statusline+=%r   " Readonly flag.
  set statusline+=%w   " Preview window flag.

  set statusline+=\    " Space.

  set statusline+=%#redbar#                " Highlight the following as a warning.
  set statusline+=%{SyntasticStatuslineFlag()} " Syntastic errors.
  set statusline+=%*                           " Reset highlighting.

  set statusline+=%=   " Right align.

  " File format, encoding and type.  Ex: "(unix/utf-8/python)"
  set statusline+=(
  set statusline+=%{&ff}                        " Format (unix/DOS).
  set statusline+=/
  set statusline+=%{strlen(&fenc)?&fenc:&enc}   " Encoding (utf-8).
  set statusline+=/
  set statusline+=%{&ft}                        " Type (python).
  set statusline+=)

  " Line and column position and counts.
  set statusline+=\ (line\ %l\/%L,\ col\ %03c)
" }}}
