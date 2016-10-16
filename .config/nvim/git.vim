call dein#add('tpope/vim-fugitive')
augroup FTGit
  au!
  autocmd FileType gitcommit setlocal spell
augroup END
