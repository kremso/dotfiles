map <leader>f :Denite file_rec<cr>
map <leader>b :Denite buffer<cr>
map <leader>r :Denite file_mru<cr>

call denite#custom#var('file_rec', 'command',
      \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)

call denite#custom#source(
      \ 'file_rec', 'matchers', ['matcher_cpsm'])

" Change sorters.
call denite#custom#source(
      \ 'file_rec', 'sorters', ['sorter_rank'])
