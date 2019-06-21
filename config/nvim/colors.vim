set termguicolors
:let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

augroup Colors
au!
" Always match terminal background
au ColorScheme * hi Normal guibg=#002b36
au ColorScheme * hi NonText guibg=#002b36
au ColorScheme * hi MatchParen guifg=#FD971F guibg=#000000 gui=underline
" Never underline cursorline
" au ColorScheme * hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white

au ColorScheme * hi Search guifg=#000000 guibg=#fffac5 gui=underline
au ColorScheme * hi IncSearch guifg=#000000 guibg=#fffac5 gui=underline
augroup END

if &term =~ '256color'
" Disable Backgrd in synstack(v:beval_lnum, v:beval_col)
"         call add(l:synNames, printf('%s%s', repeat(' ', idx), synIDattr(id,
"         'name')))
"                 let l:idx+=1
"                     endfor
"                         return join(l:synNames, "\n")
"                         endfunund Color Erase (BCE) so that color schemes
" work properly when Vim is used inside tmux and GNU screen.
" See also http://snk.tuxfamily.org/log/vim-256color-bce.html
set t_ut=
endif

colorscheme molokai
colorscheme mango
