# dotfiles

Minimal, on-demand macOS setup. Philosophy: **only config that is actually used** — nothing speculative. When something new is needed, it gets added explicitly.

This README doubles as **setup instructions for a coding agent** (Claude Code, etc.). On a fresh machine, tell the agent: *"read the README in github.com/bypotatoes/dotfiles and set up my machine"*.

## Fresh machine setup

Prerequisites: macOS with [Homebrew](https://brew.sh) installed.

1. **SSH key** (skip if `~/.ssh/id_ed25519` exists):
   ```sh
   ssh-keygen -t ed25519 -C "ilya.hrytsuk@dayforce.com" -f ~/.ssh/id_ed25519 -N ""
   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
   ```
   Append to `~/.ssh/config`:
   ```
   Host github.com
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile ~/.ssh/id_ed25519
   ```
   Copy `~/.ssh/id_ed25519.pub` to clipboard (`pbcopy`) and have the user add it at
   <https://github.com/settings/ssh/new> (agents: open the page, then poll
   `ssh -T git@github.com` until it greets).

2. **Clone** — all repos live in `~/Projects`:
   ```sh
   mkdir -p ~/Projects
   git clone git@github.com:bypotatoes/dotfiles.git ~/Projects/dotfiles
   ```

3. **Install packages**:
   ```sh
   brew bundle --file ~/Projects/dotfiles/Brewfile
   ```

4. **Symlink dotfiles** (idempotent):
   ```sh
   ~/Projects/dotfiles/install.sh
   ```

5. Open a new terminal. Verify: `Ctrl-R` opens fzf history search, typing shows
   gray autosuggestions, `gs` runs `git status`.

## What's here

| File          | Purpose |
|---------------|---------|
| `zshrc`       | History (100k, shared, deduped), fzf `Ctrl-R`/`Ctrl-T`, autosuggestions, syntax highlighting, ↑/↓ prefix search, minimal git-aware prompt. Standard emacs-style keybindings (`Ctrl-A`/`Ctrl-E`). |
| `zsh-aliases` | Shell + git aliases (`g`, `gs`, `ga`, `gc`, `gd`, `gr`, `gl`, `glf`, `gwc`). |
| `gitconfig`   | Identity, `co` alias, modern defaults (`push.autoSetupRemote`, histogram diff, zdiff3 conflicts, rerere). |
| `gitignore`   | Global ignores (macOS junk, vim swap). |
| `Brewfile`    | fzf, zsh-autosuggestions, zsh-syntax-highlighting. |
| `install.sh`  | Symlinks the above into `$HOME` as `.<name>`. |

## Conventions

- Machine-specific config goes in `~/.zshrc.local` (sourced if present, never committed).
- Repos are cloned into `~/Projects/`.
- Pre-2026 history (oh-my-zsh, tmux, Ruby-era config) lives in git history before the "fresh start" commit.
