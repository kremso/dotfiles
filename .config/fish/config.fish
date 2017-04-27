set -g -x fish_term24bit 1

set BROWSER open

set -g -x fish_greeting ''
set -g -x EDITOR nvim
set -g -x GOPATH "$HOME/Projects/go"

set -U fish_user_paths $HOME/Projects/go/bin/ $fish_user_paths

alias g=git
alias gst="git status"
alias gc="git commit -S -v"
alias gp="git push"
alias vim="nvim"
alias mux="tmuxinator"

if test -d "$HOME/.rbenv"
  set -gx PATH "$HOME/.rbenv/bin" $PATH
  . (rbenv init -|psub)
end

set -gx Z_SCRIPT_PATH ~/.config/fish/tools/z.sh

function __check_z --on-variable PWD --description 'Setup z on directory change'
  status --is-command-substitution; and return

  bash -c "source $Z_SCRIPT_PATH; _z --add `pwd -P`"
end
