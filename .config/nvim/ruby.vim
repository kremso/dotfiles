autocmd FileType ruby nmap <leader>g :grep -ir <c-r><c-w> app<cr>

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
let g:rspec_command = "Dispatch rspec {spec}"


let g:xmpfilter_cmd = "seeing_is_believing"
nmap <buffer> <C-c> <Plug>(seeing_is_believing-run)
xmap <buffer> <C-c> <Plug>(seeing_is_believing-run)
imap <buffer> <C-c> <Plug>(seeing_is_believing-run)

nmap <buffer> <C-x> <Plug>(seeing_is_believing-clean)
xmap <buffer> <C-x> <Plug>(seeing_is_believing-clean)
imap <buffer> <C-x> <Plug>(seeing_is_believing-clean)
