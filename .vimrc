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
    set wildmode=full
    set ttyfast " I have a fast terminal
    set undofile " make undo possible after the file is closed and reopened
    set gdefault " global substitutions are default s/a/b/g
    set ttimeoutlen=50  " Make Esc work faster

    " {{{ Make the current window big, but leave others context
    set winwidth=84
    " We have to have a winheight bigger than we want to set winminheight. But if
    " we set winheight to be huge before winminheight, the winminheight set will
    " fail.
    set winheight=5
    set winminheight=5
    set winheight=999
    " }}}
" }}}

" Vim UI {{{
    colorscheme tir_black
    set background=dark
    set t_Co=256
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
" }}}

" Mappings {{{
    nnoremap <space> za " open/close folds with space

    " I hit F1 too often when reaching for esc
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>

    map <F5> :Run<CR>
    imap <F5> <Esc><F5>

    " Make ' remember line/column
    nnoremap ' `
    nnoremap ` '

    " convenient window switching
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

    " Emacs-like keybindings
    cnoremap <C-a> <Home>
    cnoremap <C-e> <End>
    inoremap <C-a> <Esc>^i
    inoremap <C-e> <Esc>A

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
    nnoremap n nzzzv:call PulseCursorLine()<cr>
    nnoremap N Nzzzv:call PulseCursorLine()<cr>

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

    " Save like a pro
    nnoremap <c-s> :w<cr>

    " expands to current directory
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
" }}}

" Operator Mappings {{{
  onoremap imp :<c-u>execute "normal! ?def\r:nohlsearch\rf(lvt)"<cr>
" }}}

" Leader Mappings {{{
  let mapleader = ","

  " this key combination gets rid of the search highlights
  nmap <leader><space> :noh<cr>

  " strip all trailing whitespace in the current file
  nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

  " start ack search
  nnoremap <leader>a :Ack 

  " edit .vimrc
  nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

  " source .vimrc
  nnoremap <leader>sv :source $MYVIMRC<cr>

  " open vertical split and switch to it
  nnoremap <leader>w <C-w>v<C-w>l

  " reformat whole file
  nnoremap <leader>= ggVG=

  " convert {} to do/end
  nnoremap <leader>b ^f{cwdo<cr><esc>$xxoend<esc>

  " initialize object from parameters
  function! InitializeFromParameters()
    let saved_unnamed_register = @@

    normal! ?deff(yi(
    let params = split(@@, ",")
    for param in params
      let cleaned_param = substitute(param, '^\s*\(.\{-}\)\s*$', '\1', '')
      let @@ = "@" . cleaned_param . " = " . cleaned_param
      normal! op==
    endfor
    normal! jdd
    nohlsearch

    let @@ = saved_unnamed_register
  endfunction
  nnoremap <leader>i :call InitializeFromParameters()<cr>
  inoremap <leader>i <esc>:call InitializeFromParameters()<cr>

  " Switch between the last two files
  nnoremap <leader><leader> <c-^>

  " show long lines {{{
    function! ShowLongLines()
      highlight OverLength ctermbg=red ctermfg=white guibg=#592929
      match OverLength /\%81v.\+/
    endfunction
    nnoremap <leader>sll :call ShowLongLines()<cr>
  " }}}
" }}}

" Abbreviations {{{
  iabbr ssig Maj sa,<cr>Tomas
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
  map <leader>gR :call ShowRoutes()<cr>

  function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    exec ":!bundle exec rspec " . a:filename
  endfunction

  function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
  endfunction

  function! RunTestFile(...)
    if a:0
      let command_suffix = a:1
    else
      let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if in_spec_file
      call SetTestFile()
    elseif !exists("t:grb_test_file")
      return
    end
    call RunTests(t:grb_test_file . command_suffix)
  endfunction

  function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
  endfunction

  " Run this file
  map <leader>t :call RunTestFile()<cr>
  " Run only the example under the cursor
  map <leader>T :call RunNearestTest()<cr>
  " Run all test files
  map <leader>a :call RunTests('spec')<cr>
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
      au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap
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
" }}}

" GUI settings {{{
  autocmd GUIEnter * colorscheme molokai
  autocmd GUIEnter * set guioptions-=m
  autocmd GUIEnter * set guioptions-=T
  "autocmd GUIEnter * set gfn=Bitstream\ Vera\ Sans\ Mono\ 9
  autocmd GUIEnter * set gfn=Monaco\ for\ Powerline\ 9
  let g:Powerline_symbols = 'fancy'
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

" PulseCursorLine {{{
function! PulseCursorLine()
    let current_window = winnr()

    windo set nocursorline
    execute current_window . 'wincmd w'

    setlocal cursorline

    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    hi CursorLine guibg=#2a2a2a
    redraw
    sleep 20m

    hi CursorLine guibg=#333333
    redraw
    sleep 20m

    hi CursorLine guibg=#3a3a3a
    redraw
    sleep 20m

    hi CursorLine guibg=#444444
    redraw
    sleep 20m

    hi CursorLine guibg=#4a4a4a
    redraw
    sleep 20m

    hi CursorLine guibg=#444444
    redraw
    sleep 20m

    hi CursorLine guibg=#3a3a3a
    redraw
    sleep 20m

    hi CursorLine guibg=#333333
    redraw
    sleep 20m

    hi CursorLine guibg=#2a2a2a
    redraw
    sleep 20m

    execute 'hi ' . old_hi

    windo set cursorline
    execute current_window . 'wincmd w'
endfunction
" }}}

" Ack motions {{{

" Motions to Ack for things.  Works with pretty much everything, including:
"
"   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
"
" Awesome.
"
" Note: If the text covered by a motion contains a newline it won't work.  Ack
" searches line-by-line.

nnoremap <silent> \a :set opfunc=<SID>AckMotion<CR>g@
xnoremap <silent> \a :<C-U>call <SID>AckMotion(visualmode())<CR>

function! s:CopyMotionForType(type)
    if a:type ==# 'v'
        silent execute "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'char'
        silent execute "normal! `[v`]y"
    endif
endfunction

function! s:AckMotion(type) abort
    let reg_save = @@

    call s:CopyMotionForType(a:type)

    execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"

    let @@ = reg_save
endfunction

" }}}

" Refactorings {{{
function! ExtractVariable()
  let name = input("Variable name: ")
  if name == ''
    return
  endif
  " Enter visual mode (not sure why this is needed since we're already in
  " visual mode anyway)
  normal! gv

  " Replace selected text with the variable name
  exec "normal c" . name
  " Define the variable on the line above
  exec "normal! O" . name . " = "
  " Paste the original selected text to be the variable value
  normal! $p
endfunction

function! InlineVariable()
  " Copy the variable under the cursor into the 'a' register
  :let l:tmp_a = @a
  :normal "ayiw
  " Delete variable and equals sign
  :normal 2daW
  " Delete the expression into the 'b' register
  :let l:tmp_b = @b
  :normal "bd$
  " Delete the remnants of the line
  :normal dd
  " Go to the end of the previous line so we can start our search for the
  " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
  " work; I'm not sure why.
  normal k$
  " Find the next occurence of the variable
  exec '/\<' . @a . '\>'
  " Replace that occurence with the text we yanked
  exec ':.s/\<' . @a . '\>/' . @b
  :let @a = l:tmp_a
  :let @b = l:tmp_b
endfunction

vnoremap <leader>rv :call ExtractVariable()<cr>
nnoremap <leader>ri :call InlineVariable()<cr>
" }}}
