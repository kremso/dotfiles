augroup FTCss
  au!
  au BufRead,BufNewFile *.scss.erb set ft=scss
  autocmd FileType css,scss  silent! setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType css,scss  setlocal iskeyword+=-
  autocmd FileType scss,sass  syntax cluster sassCssAttributes add=@cssColors
  " Use <leader>S to sort properties.
  au FileType css,scss nnoremap <buffer> <leader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>
  " Make {<cr> insert a pair of brackets in such a way that the cursor is
  " correctly positioned inside of them AND the following code doesn't get unfolded.
  au FileType css,scss inoremap <buffer> {<cr> {<cr>}<esc>O

augroup END
