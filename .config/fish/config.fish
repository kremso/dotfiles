set BROWSER open

set -g -x fish_greeting ''
set -g -x EDITOR vim

alias gst="git status"
alias gc="git commit -v"
alias gp="git push"

set -gx PATH "$HOME/.rbenv/bin" $PATH
. (rbenv init -|psub)

set -gx Z_SCRIPT_PATH ~/.config/fish/tools/z.sh

function __check_z --on-variable PWD --description 'Setup z on directory change'
  status --is-command-substitution; and return

  bash -c "source $Z_SCRIPT_PATH; _z --add `pwd -P`"
end
