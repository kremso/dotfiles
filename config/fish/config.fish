set -g -x fish_term24bit 1

set BROWSER open

set -g -x fish_greeting ''
set -g -x EDITOR nvim

alias g=git
alias gst="git status"
alias gc="git commit -S -v"
alias gp="git push"
alias vim="nvim"
alias mux="tmuxinator"

# Point the SSH_AUTH_SOCK to the one handled by gpg-agent
if test -e (gpgconf --list-dirs agent-ssh-socket)
  set -g -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
else
  echo (gpgconf --list-dirs agent-ssh-socket) "doesn't exist. Is gpg-agent running?"
end

if test -d "$HOME/Projects/go"
  set -g -x GOPATH "$HOME/Projects/go"
  set -U fish_user_paths $HOME/Projects/go/bin/ $fish_user_paths
end

if test -d "$HOME/.rbenv"
  set -gx PATH "$HOME/.rbenv/bin" $PATH
  . (rbenv init -|psub)
end

if test -d "/usr/local/share/chruby"
  source /usr/local/share/chruby/chruby.fish
  source /usr/local/share/chruby/auto.fish
  chruby 2.3.1
end

set -gx Z_SCRIPT_PATH ~/.config/fish/tools/z.sh

function __check_z --on-variable PWD --description 'Setup z on directory change'
  status --is-command-substitution; and return

  bash -c "source $Z_SCRIPT_PATH; _z --add `pwd -P`"
end

set fish_color_autosuggestion 555
set fish_color_command 00ff00
set fish_color_comment 4e4e4e
set fish_color_cwd green
set fish_color_cwd_root red
set fish_color_end 00FF00
set fish_color_error d75f5f
set fish_color_escape cyan
set fish_color_history_current cyan
set fish_color_host normal
set fish_color_match cyan
set fish_color_normal normal
set fish_color_operator cyan
set fish_color_param 00afff
set fish_color_quote 725000
set fish_color_redirection normal
set fish_color_search_match \x2d\x2dbackground\x3dpurple
set fish_color_selection \x2d\x2dbackground\x3dpurple
set fish_color_status red
set fish_color_user green
set fish_color_valid_path \x2d\x2dunderline
set fish_key_bindings fish_default_key_bindings
set fish_pager_color_completion normal
set fish_pager_color_description 555\x1eyellow
set fish_pager_color_prefix cyan
set fish_pager_color_progress cyan
