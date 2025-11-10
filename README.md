# Dotfiles

This repository contains the configuration files for Vim, tmux, and Zsh.

## Initial setup on a new machine

1. Clone the repository into your home directory (or wherever you prefer to keep your dotfiles).
   ```bash
   git clone <repo-url> ~/dotfiles
   cd ~/dotfiles
   ```
2. Run the setup script to back up any existing configuration files and replace them with symlinks to the versions in this repository.
   ```bash
   ./setup_dotfiles.sh
   ```

The script will create a `~/.dotfiles_backup` directory and move any existing `.vimrc`, `.tmux.conf`, `.zshrc`, `.vim`, or `.tmux` files/directories into it with a timestamp before linking the repository-managed versions.

After the script completes, launching Vim, tmux, or a new Zsh session will automatically pick up the configurations from this repository.

## Updating existing setups

If you update the files in this repository, simply pull the latest changes. Because your home directory contains symlinks to the repository, the new configurations will be picked up immediately.
