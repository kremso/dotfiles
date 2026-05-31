# dotfiles

Personal macOS dev environment, managed with [chezmoi](https://www.chezmoi.io/).

## Bootstrap a fresh Mac

```sh
# 1. Install Homebrew (if not present) — chezmoi can do this too, but bootstrapping it manually first is cleanest.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi
brew install chezmoi

# 3. Initialise from this repo (clones, prompts, applies, runs install scripts)
chezmoi init --apply --source=$HOME/.dotfiles git@github.com:kremso/dotfiles.git
```

That will:
- Prompt for name, email, GitHub user, and SSH signing pubkey.
- Symlink/render all config files into `$HOME`.
- Run `brew bundle` against the [Brewfile](Brewfile).
- Apply macOS system defaults.

## Daily use

```sh
chezmoi edit ~/.gitconfig   # edit a managed file
chezmoi diff                # preview pending changes
chezmoi apply               # apply them
chezmoi re-add              # pull live edits back into source
chezmoi update              # git pull + apply (sync from another machine)
```

## What's inside

- **Shell**: fish + starship prompt + zoxide + atuin
- **Editor**: VS Code (primary), Neovim (minimal lazy.nvim setup)
- **Terminal**: Ghostty
- **Runtimes**: mise (Python/Node/Ruby), uv (Python project tool)
- **Git**: delta pager, SSH commit signing via Yubikey
- **Yubikey**: GPG (for legacy) + SSH auth + SSH commit signing
