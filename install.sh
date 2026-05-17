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

link_labels=(
  ".vimrc"
  ".zshrc"
  ".config/fastfetch/config.jsonc"
  ".config/opencode/opencode.json"
  ".config/starship.toml"
)

link_sources=(
  "$repo_dir/.vimrc"
  "$repo_dir/.zshrc"
  "$repo_dir/.config/fastfetch/config.jsonc"
  "$repo_dir/.config/opencode/opencode.json"
  "$repo_dir/.config/starship.toml"
)

link_targets=(
  "$HOME/.vimrc"
  "$HOME/.zshrc"
  "$HOME/.config/fastfetch/config.jsonc"
  "$HOME/.config/opencode/opencode.json"
  "$HOME/.config/starship.toml"
)

contains_value() {
  local needle="$1"
  shift
  local value

  for value in "$@"; do
    if [ "$value" = "$needle" ]; then
      return 0
    fi
  done

  return 1
}

prompt_selection() {
  local input token
  local -a selected
  local i

  if [ ! -t 0 ]; then
    echo "This installer is interactive. Run it from a terminal." >&2
    return 1
  fi

  while true; do
    selected=()
    echo
    echo "Choose which files to link (space or comma separated):"
    for i in "${!link_labels[@]}"; do
      printf '  %d) %s\n' "$((i + 1))" "${link_labels[$i]}"
    done
    echo "  a) all"
    read -r -p "Selection: " input
    input="${input//,/ }"

    for token in $input; do
      case "$token" in
        a|A|all|ALL)
          selected=()
          for i in "${!link_labels[@]}"; do
            selected+=("$i")
          done
          break
          ;;
        *)
          if [[ "$token" =~ ^[0-9]+$ ]]; then
            if [ "$token" -ge 1 ] && [ "$token" -le "${#link_labels[@]}" ]; then
              i=$((token - 1))
              if ! contains_value "$i" "${selected[@]}"; then
                selected+=("$i")
              fi
            else
              echo "Ignored out-of-range option: $token"
            fi
          elif [ -n "$token" ]; then
            echo "Ignored invalid option: $token"
          fi
          ;;
      esac
    done

    if [ "${#selected[@]}" -eq 0 ]; then
      echo "No valid selection made. Please try again."
      continue
    fi

    break
  done

  echo
  echo "Linking selected files:"
  for i in "${selected[@]}"; do
    link_file "${link_sources[$i]}" "${link_targets[$i]}"
  done
}

link_all() {
  local i
  echo
  echo "Linking all files:"
  for i in "${!link_labels[@]}"; do
    link_file "${link_sources[$i]}" "${link_targets[$i]}"
  done
}

usage() {
  cat <<'EOF'
Usage: ./install.sh [--all]

Options:
  --all    Link all files without prompting
  -h       Show this help message
  --help   Show this help message
EOF
}

case "${1:-}" in
  "")
    prompt_selection
    ;;
  --all)
    link_all
    ;;
  -h|--help)
    usage
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage >&2
    exit 1
    ;;
esac
