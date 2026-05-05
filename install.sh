#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
os_name="$(uname -s)"

case "$os_name" in
  Darwin|Linux)
    echo "Installing dotfiles for $os_name from $repo_dir"
    ;;
  *)
    echo "Unsupported OS: $os_name" >&2
    exit 1
    ;;
esac

link_file() {
  local source_path="$1"
  local target_path="$2"
  local target_dir

  if [ ! -e "$source_path" ]; then
    echo "Missing source: $source_path" >&2
    return 1
  fi

  target_dir="$(dirname -- "$target_path")"
  mkdir -p "$target_dir"

  if [ -L "$target_path" ]; then
    ln -sfn "$source_path" "$target_path"
    echo "Relinked $target_path -> $source_path"
  elif [ -e "$target_path" ]; then
    echo "Skipped $target_path (exists and is not a symlink)"
  else
    ln -s "$source_path" "$target_path"
    echo "Linked $target_path -> $source_path"
  fi
}

link_file "$repo_dir/.vimrc" "$HOME/.vimrc"
link_file "$repo_dir/.zshrc" "$HOME/.zshrc"
link_file "$repo_dir/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link_file "$repo_dir/.config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
