# dotfiles

Personal dotfiles for my systems (macOS + Linux).

## What’s inside

This repo is meant to hold my common configuration files (shell, editor, git, tooling), tracked in a way that’s easy to bootstrap on a new machine.

Current files include:

- `.vimrc`

## Install / bootstrap

The intended workflow is to **symlink** files from this repo into `$HOME` (or the appropriate config location).

Example (safe, explicit):

```bash
cd /path/to/dotfiles
ln -sfn "$(pwd)/.vimrc" "$HOME/.vimrc"
```

Notes:

- `-s` symlink, `-f` replace existing destination, `-n` treat destination as a normal file if it’s a symlink.
- For apps that prefer XDG paths (e.g. `~/.config/...`), place files accordingly and symlink those directories/files.

## Machine-specific / secrets

Do **not** commit secrets (tokens, private keys, passwords). Prefer:

- Keeping secret values in a separate, untracked file (see `.gitignore`)
- Using a secret manager (1Password, Keychain, `pass`, etc.)
- Sourcing a local override file like `~/.zshrc.local` if needed

## Repo conventions

- Keep configs **portable** where possible.
- Add comments only for non-obvious intent/trade-offs.
- Prefer small, composable files over one giant config.

## License

For personal use. If you want a license here (MIT/Apache-2.0/etc.), add one explicitly.
