if not status is-interactive
    exit
end

# --- Homebrew ---
/opt/homebrew/bin/brew shellenv | source

# --- Editor ---
set -gx EDITOR nvim
set -gx VISUAL nvim

# --- Yubikey / GPG SSH agent ---
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# --- Tools ---
starship init fish | source
zoxide init fish | source
atuin init fish --disable-up-arrow | source
mise activate fish | source
direnv hook fish | source

# fzf key bindings (Ctrl-T, Ctrl-R, Alt-C)
fzf --fish | source

# --- Aliases ---
alias ls 'eza --group-directories-first'
alias ll 'eza -l --group-directories-first --git'
alias la 'eza -la --group-directories-first --git'
alias lt 'eza --tree --level=2 --group-directories-first'
alias cat 'bat --paging=never'
alias vim nvim
alias g git

# Fish-specific niceties
set -g fish_greeting ""
