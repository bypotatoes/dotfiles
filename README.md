# dotfiles

Minimal, on-demand macOS setup. Philosophy: **only config that is actually used** — nothing speculative. When something new is needed, it gets added explicitly.

This README doubles as **setup instructions for a coding agent** (Claude Code, etc.). On a fresh machine, tell the agent: *"read the README in github.com/bypotatoes/dotfiles and set up my machine"*.

## Fresh machine setup

0. **Homebrew** (skip if `brew` already works):
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   Agents: permission classifiers often block curl-pipe-to-shell — if blocked, have the
   user run this one line themselves, then continue.

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

6. **Claude Code layer** — clone and install
   [bypotatoes/dotfiles-claude](https://github.com/bypotatoes/dotfiles-claude)
   (settings, skills, memory) per its README:
   ```sh
   git clone git@github.com:bypotatoes/dotfiles-claude.git ~/Projects/dotfiles-claude
   ~/Projects/dotfiles-claude/install.sh
   ```

7. **gh auth** — run `gh auth login --web --git-protocol ssh` in a real terminal
   (it needs an interactive TTY for the device-code prompt; agents get stuck here,
   so hand this one to the user).

Done. Ghostty comes from the Brewfile; its config is already linked by `install.sh`.
When a work project is cloned later, seed its agent memory with
`~/Projects/dotfiles-claude/restore-memory.sh <project-path>`.

## What's here

| File          | Purpose |
|---------------|---------|
| `zshrc`       | History (100k, shared, deduped), fzf `Ctrl-R`/`Ctrl-T`, autosuggestions, syntax highlighting, ↑/↓ prefix search, robbyrussell-style prompt (no oh-my-zsh). Standard emacs-style keybindings (`Ctrl-A`/`Ctrl-E`). |
| `zsh-aliases` | Shell + git aliases (`g`, `gs`, `ga`, `gc`, `gd`, `gr`, `gl`, `glf`, `gwc`). |
| `gitconfig`   | Identity, `co` alias, modern defaults (`push.autoSetupRemote`, histogram diff, zdiff3 conflicts, rerere). |
| `gitignore`   | Global ignores (macOS junk, vim swap). |
| `ghostty`     | Ghostty terminal: copy-on-select to clipboard, Option-as-Alt (needed for the Alt word-jumps), window restore. → `~/.config/ghostty/config` |
| `Brewfile`    | Ghostty, gh, fzf, zsh-autosuggestions, zsh-syntax-highlighting. |
| `install.sh`  | Symlinks the above into `$HOME` as `.<name>` (Ghostty into `~/.config/ghostty/config`). |

## Conventions

- Machine-specific config goes in `~/.zshrc.local` (sourced if present, never committed).
- Repos are cloned into `~/Projects/`.
- Pre-2026 history (oh-my-zsh, tmux, Ruby-era config) lives in git history before the "fresh start" commit.
