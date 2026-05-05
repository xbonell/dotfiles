export PATH="$HOME/.local/bin:$PATH"

# oh-my-zsh (optional)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
if [ -s "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# starship (optional)
if [[ -o interactive ]] && command -v starship >/dev/null 2>&1 && [[ "${TERM:-}" != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

# zplug (optional)
if [ -s "$HOME/.zplug/init.zsh" ]; then
  source "$HOME/.zplug/init.zsh"

  zplug "plugins/git", from:oh-my-zsh
  zplug "plugins/dnf", from:oh-my-zsh
  zplug "plugins/vscode", from:oh-my-zsh
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-syntax-highlighting"

  # Avoid interactive prompts during shell startup. To install plugins, run:
  #   zplug install
  #   zplug load
  VSCODE=cursor
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
  zplug load
fi

# fnm (optional)
FNM_PATH="$HOME/.local/share/fnm"
if [ -x "$FNM_PATH/fnm" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$("$FNM_PATH/fnm" env --shell zsh)"
fi

# Opencode CLI (optional)
OPENCODE_BIN="$HOME/.opencode/bin"
if [ -d "$OPENCODE_BIN" ]; then
  export PATH="$OPENCODE_BIN:$PATH"
fi

# fzf (optional)
if [[ -o interactive ]] && command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Prefer lsd if installed, fallback to system ls
if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd'
fi

# Fastfetch (optional)
unalias fastfetch >/dev/null 2>&1 || true
fastfetch() {
  local config="$HOME/.config/fastfetch/config.jsonc"

  if [ -f "$config" ]; then
    command fastfetch --config "$config" "$@"
  else
    command fastfetch "$@"
  fi
}

# Local overrides (untracked)
if [ -s "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi
