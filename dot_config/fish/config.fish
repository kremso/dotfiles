if not status is-interactive
    exit
end

# --- Homebrew ---
/opt/homebrew/bin/brew shellenv | source

# --- Editor / shell ---
set -gx EDITOR nvim
set -gx VISUAL nvim
set -g fish_greeting ""

# Avoid macOS Python fork crash with libdispatch (boto3/AWS CLI etc.)
set -gx OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES

# --- PATH ---
fish_add_path $HOME/.local/bin

# --- Yubikey / GPG SSH agent ---
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# --- Tools (each guarded so a fresh machine doesn't error before brew bundle runs) ---
command -v starship >/dev/null; and starship init fish | source
command -v zoxide   >/dev/null; and zoxide init fish | source
command -v atuin    >/dev/null; and atuin init fish --disable-up-arrow | source
command -v mise     >/dev/null; and mise activate fish | source
command -v direnv   >/dev/null; and direnv hook fish | source

# fzf
command -v fzf >/dev/null; and fzf --fish | source
set -gx FZF_DEFAULT_COMMAND 'rg --files'

# --- Aliases ---
alias ls 'eza --group-directories-first'
alias ll 'eza -l --group-directories-first --git'
alias la 'eza -la --group-directories-first --git'
alias lt 'eza --tree --level=2 --group-directories-first'
alias cat 'bat --paging=never'
alias vim nvim
alias g git
alias gst 'git status'
alias gc 'git commit -v'
alias gp 'git push'
alias k kubectl

# --- Work helpers (Luigi's Box) ---
function ssm --description "AWS SSM start-session by private IP"
    trap 'echo "Ignoring SIGTERM signal"' SIGTERM
    aws-vault exec luigis -- aws ec2 describe-instances --filters "Name=private-ip-address,Values=$argv" | jq '.Reservations[].Instances[] | .InstanceId' | xargs -o aws-vault exec luigis -- aws ssm start-session --target
end

function ssm-command --description "AWS SSM send-command by private IP"
    trap 'echo "Ignoring SIGTERM signal"' SIGTERM
    aws-vault exec luigis -- aws ec2 describe-instances --filters "Name=private-ip-address,Values=$argv" | jq '.Reservations[].Instances[] | .InstanceId' | xargs -o aws-vault exec luigis -- aws ssm send-command --instance-ids {} --document-name "AWS-RunShellScript" --parameters commands=pwd --output text
end

function xml --description "Format XML and put it through pager"
    xmllint -format $argv[1] | less
end

# --- Third-party integrations (loaded if present) ---
test -f ~/.orbstack/shell/init2.fish; and source ~/.orbstack/shell/init2.fish
test -d ~/.codeium/windsurf/bin; and fish_add_path ~/.codeium/windsurf/bin
