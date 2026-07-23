#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Idempotent — safe to re-run.
set -euo pipefail
cd "$(dirname "$0")"

for f in zshrc zsh-aliases gitconfig gitignore; do
  ln -sfn "$PWD/$f" "$HOME/.$f"
  echo "linked ~/.$f -> $PWD/$f"
done

mkdir -p "$HOME/.config/ghostty"
ln -sfn "$PWD/ghostty" "$HOME/.config/ghostty/config"
echo "linked ~/.config/ghostty/config -> $PWD/ghostty"
