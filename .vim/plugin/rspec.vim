if exists('g:loaded_rspec') || &cp || v:version < 700
  finish
endif

let t:path = fnamemodify(expand("<sfile>"), ":p:h")

function! RspecRun(kind)
  let t:executable = "rspec -r " . t:path . "/rspec_vim_formatter.rb -f RSpec::Core::Formatters::SweetVimRspecFormatter "

  let t:in_spec_file = match(expand("%"), '_spec.rb$') != -1

  if t:in_spec_file
    let t:last_spec_file = @%
    let t:target = expand('%')

    if a:kind == "Focused"
      let t:target .=  "-l " . line(".")
    endif
  else
    let t:target = t:last_spec_file
  endif

  let t:result = system(t:executable . t:target)
  cgete t:result
  botright cwindow
  cwindow
  setlocal foldmethod=marker
  setlocal foldmarker=+-+,-+-
endfunction

command! RspecRunFile call RspecRun("File")
command! RspecRunFocused call RspecRun("Focused")

let g:loaded_rspec = 1
