autocmd FileType ruby nmap <leader>g :grep -ir <c-r><c-w> app<cr>

map <Leader>t :w<cr>:TestFile<cr>
map <Leader>T :w<cr>:TestNearest<cr>

let g:ale_ruby_rubocop_executable="bundle exec rake rubocop"
