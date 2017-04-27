call dein#add('tomasr/molokai')

set termguicolors
:let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

augroup Colors
au!
" Always match terminal background
au ColorScheme * hi Normal guibg=#002b36
au ColorScheme * hi NonText guibg=#002b36
au ColorScheme * hi MatchParen guifg=#FD971F guibg=#000000 gui=underline
" Never underline cursorline
au ColorScheme * hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white
au ColorScheme * hi Search guifg=NONE guibg=NONE gui=underline
au ColorScheme * hi IncSearch guifg=NONE guibg=NONE gui=underline
augroup END

if &term =~ '256color'
" Disable Background Color Erase (BCE) so that color schemes
" work properly when Vim is used inside tmux and GNU screen.
" See also http://snk.tuxfamily.org/log/vim-256color-bce.html
set t_ut=
endif

colorscheme molokai
