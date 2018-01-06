augroup FTSimultaneousEdits
  autocmd!
  autocmd SwapExists * call HandleSwapFile(expand('<afile>:p'))
augroup END

" Print a message after the autocommand completes
" (so you can see it, but don't have to hit <ENTER> to continue)...
function! DelayedMsg(msg)
  " A sneaky way of injecting a message when swapping into the new buffer...
  augroup DelayedMsg
    autocmd!
    " Print the message on finally entering the buffer...
    autocmd BufWinEnter *  echohl WarningMsg
    exec 'autocmd BufWinEnter *  echon "\r'.printf("%-60s", a:msg).'"'
    autocmd BufWinEnter *  echohl NONE

    " And then remove these autocmds, so it's a "one-shot" deal...
    autocmd BufWinEnter *  augroup AutoSwap_Mac_Msg
    autocmd BufWinEnter *  autocmd!
    autocmd BufWinEnter *  augroup END
  augroup END
endfunction

function! HandleSwapFile(filename)
  " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
    call DelayedMsg("Old swapfile detected...and deleted")
    call delete(v:swapname)
    let v:swapchoice = 'e'
    " otherwise, open file read-only
  else
    call DelayedMsg("Swapfile detected...opening read-only")
    let v:swapchoice = 'o'
  endif
endfunction
