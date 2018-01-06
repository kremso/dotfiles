augroup FTQuickfix
  autocmd!
  autocmd Filetype qf setlocal colorcolumn=0 nolist nocursorline wrap linebreak
augroup END

nmap [q :cprevious<cr>
nmap ]q :cnext<cr>
