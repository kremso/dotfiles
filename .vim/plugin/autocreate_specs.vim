if exists('g:loaded_autocreate_specs') || &cp
  finish
endif

function! s:AlternateFile(path) abort
  let l:in_spec = match(expand("%"), '^spec/') != -1
  if l:in_spec
    return s:AlternateToSpec(a:path)
  else
    return s:AlternateToNonSpec(a:path)
  endif
endfunction

function! s:AlternateToNonSpec(path) abort
  let path = fnamemodify(a:path, ':h')
  let spec_name = substitute(fnamemodify(a:path, ':t'), '\.rb$', '_spec.rb', '')
  let path_minus_app = substitute(path, '^app/', '', '')
  return 'spec/' . path_minus_app . '/' . spec_name
endfunction

function! s:AlternateToSpec(path) abort
  let path = substitute(fnamemodify(a:path, ':h'), '^spec/', '', '')
  let file_name = substitute(fnamemodify(a:path, ':t'), '_spec\.rb$', '.rb', '')

  if match(path, '^lib/') == -1
    let path = 'app/' . path
  endif

  return path . '/' . file_name
endfunction

function! AutoCreateRspec()
  let alternate = s:AlternateFile(expand('%'))

  if filereadable(alternate)
    execute "edit " . alternate
  else
    if confirm("Spec file '" . alternate . "' does not exist", "&Create it\nor &Abort?") == 2
      return
    endif

    let spec_dir = fnamemodify(alternate, ':h')
    if !isdirectory(spec_dir)
      call mkdir(spec_dir, 'p')
    end
    execute "edit " . alternate
  endif
endfunction

augroup AutoCreateRSpec
  au!
  autocmd FileType ruby :cnoremap A<cr> call AutoCreateRspec()<cr>
augroup END

let g:loaded_autocreate_specs = 1
