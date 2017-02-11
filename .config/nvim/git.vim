call dein#add('tpope/vim-fugitive')
call dein#add('airblade/vim-gitgutter')

set updatetime=250

augroup FTGit
  au!
  autocmd FileType gitcommit setlocal spell
augroup END
