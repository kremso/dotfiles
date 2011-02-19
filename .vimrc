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
    "set statusline=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n
    "set statusline+=%#warningmsg#
    "set statusline+=%{SyntasticStatuslineFlag()}
    "set statusline+=%*
    set cursorline " visually mark current line
" }}}

" Statusline {{{
  "statusline setup
  set statusline=%f       "tail of the filename

  "display a warning if fileformat isnt unix
  set statusline+=%#warningmsg#
  set statusline+=%{&ff!='unix'?'['.&ff.']':''}
  set statusline+=%*

  "display a warning if file encoding isnt utf-8
  set statusline+=%#warningmsg#
  set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
  set statusline+=%*

  set statusline+=%h      "help file flag
  set statusline+=%y      "filetype
  set statusline+=%r      "read only flag
  set statusline+=%m      "modified flag

  " display current git branch
  set statusline+=%{fugitive#statusline()}

  "display a warning if &et is wrong, or we have mixed-indenting
  set statusline+=%#error#
  set statusline+=%{StatuslineTabWarning()}
  set statusline+=%*

  set statusline+=%{StatuslineTrailingSpaceWarning()}

  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  "display a warning if &paste is set
  set statusline+=%#error#
  set statusline+=%{&paste?'[paste]':''}
  set statusline+=%*

  set statusline+=%=      "left/right separator
  set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
  set statusline+=%c,     "cursor column
  set statusline+=%l/%L   "cursor line/total lines
  set statusline+=\ %P    "percent through file
  set laststatus=2        " Always show status line

  "return the syntax highlight group under the cursor ''
  function! StatuslineCurrentHighlight()
      let name = synIDattr(synID(line('.'),col('.'),1),'name')
      if name == ''
          return ''
      else
          return '[' . name . ']'
      endif
  endfunction

  "recalculate the trailing whitespace warning when idle, and after saving
  autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

  "return '[\s]' if trailing white space is detected
  "return '' otherwise
  function! StatuslineTrailingSpaceWarning()
      if !exists("b:statusline_trailing_space_warning")
          if search('\s\+$', 'nw') != 0
              let b:statusline_trailing_space_warning = '[\s]'
          else
              let b:statusline_trailing_space_warning = ''
          endif
      endif
      return b:statusline_trailing_space_warning
  endfunction

  "return '[&et]' if &et is set wrong
  "return '[mixed-indenting]' if spaces and tabs are used to indent
  "return an empty string if everything is fine
  function! StatuslineTabWarning()
      if !exists("b:statusline_tab_warning")
          let tabs = search('^\t', 'nw') != 0
          let spaces = search('^ ', 'nw') != 0

          if tabs && spaces
              let b:statusline_tab_warning =  '[mixed-indenting]'
          elseif (spaces && !&et) || (tabs && &et)
              let b:statusline_tab_warning = '[&et]'
          else
              let b:statusline_tab_warning = ''
          endif
      endif
      return b:statusline_tab_warning
  endfunction

  "return a warning for "long lines" where "long" is either &textwidth or 80 (if
  "no &textwidth is set)
  "
  "return '' if no long lines
  "return '[#x,my,$z] if long lines are found, were x is the number of long
  "lines, y is the median length of the long lines and z is the length of the
  "longest line
  function! StatuslineLongLineWarning()
      if !exists("b:statusline_long_line_warning")
          let long_line_lens = s:LongLines()

          if len(long_line_lens) > 0
              let b:statusline_long_line_warning = "[" .
                          \ '#' . len(long_line_lens) . "," .
                          \ 'm' . s:Median(long_line_lens) . "," .
                          \ '$' . max(long_line_lens) . "]"
          else
              let b:statusline_long_line_warning = ""
          endif
      endif
      return b:statusline_long_line_warning
  endfunction

  "return a list containing the lengths of the long lines in this buffer
  function! s:LongLines()
      let threshold = (&tw ? &tw : 80)
      let spaces = repeat(" ", &ts)

      let long_line_lens = []

      let i = 1
      while i <= line("$")
          let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
          if len > threshold
              call add(long_line_lens, len)
          endif
          let i += 1
      endwhile

      return long_line_lens
  endfunction

  "find the median of the given array of numbers
  function! s:Median(nums)
      let nums = sort(a:nums)
      let l = len(nums)

      if l % 2 == 1
          let i = (l-1) / 2
          return nums[i]
      else
          return (nums[l/2] + nums[(l/2)-1]) / 2
      endif
  endfunction
" }}}

" Text Formatting/Layout {{{
    set expandtab " no real tabs please!
    set wrap "wrap text
    set textwidth=79 " to 79 characters
    "set colorcolumn=85 " and warn me if my line gets over 85 characters
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
      autocmd InsertEnter * setlocal spell
      autocmd InsertLeave * setlocal nospell
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
