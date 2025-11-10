#!/usr/bin/env bash
set -euo pipefail

# Determine the directory where this script resides (i.e., the root of the dotfiles repo)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BACKUP_DIR="$HOME/.dotfiles_backup"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

create_symlink() {
  local source_path="$1"
  local target_path="$2"
  local backup_path

  if [ ! -e "$source_path" ]; then
    echo "Source $source_path does not exist; skipping."
    return
  fi

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    echo "Symlink already exists for $target_path"
    return
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_path="$BACKUP_DIR/$(basename "$target_path").$TIMESTAMP"
    echo "Backing up $target_path to $backup_path"
    mv "$target_path" "$backup_path"
  fi

  echo "Linking $source_path -> $target_path"
  ln -sfn "$source_path" "$target_path"
}

# Files to link
declare -A FILE_LINKS=(
  ["$SCRIPT_DIR/vimrc"]="$HOME/.vimrc"
  ["$SCRIPT_DIR/tmux.conf"]="$HOME/.tmux.conf"
  ["$SCRIPT_DIR/zshrc"]="$HOME/.zshrc"
)

# Directories to link
declare -A DIR_LINKS=(
  ["$SCRIPT_DIR/vim"]="$HOME/.vim"
  ["$SCRIPT_DIR/tmux"]="$HOME/.tmux"
)

for source in "${!FILE_LINKS[@]}"; do
  create_symlink "$source" "${FILE_LINKS[$source]}"
done

for source in "${!DIR_LINKS[@]}"; do
  create_symlink "$source" "${DIR_LINKS[$source]}"
done

echo "Dotfiles setup complete."
