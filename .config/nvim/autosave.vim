call dein#add('tmux-plugins/vim-tmux-focus-events')

autocmd FocusLost * silent! wa
