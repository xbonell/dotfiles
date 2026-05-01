# Agent guidelines (dotfiles repo)

This repo is a **personal dotfiles** collection. Changes should be safe, reversible, and avoid leaking secrets.

## Principles

- Prefer **symlink-friendly** layouts (files live in repo, linked into `$HOME`).
- Keep configs **idempotent** and **portable** across machines.
- Avoid “magic” that makes shells/editors slow to start.
- Never commit secrets.

## Common layout patterns

Any of these are acceptable—pick the one that fits the tool:

- **Direct home-dotfiles**: track files like `.vimrc`, `.zshrc`, `.gitconfig`
- **XDG config**: track under `.config/<tool>/...` for tools that support it
- **Tool-specific dirs**: e.g. `bin/`, `scripts/`, `macos/`

If adding a new tool, update `README.md` with the intended install path.

## Installing (expected approach)

Prefer **explicit symlinks** rather than copying:

```bash
ln -sfn "$(pwd)/.vimrc" "$HOME/.vimrc"
```

If we add a bootstrap script later, it must:

- Be safe to re-run
- Not delete user data
- Detect OS (`uname`) and branch accordingly
- Print what it changes

## Secrets policy (must-follow)

Never add or suggest committing:

- Private keys (`id_rsa`, `*.pem`, `*.p12`, etc.)
- Tokens, passwords, API keys, `.env` files
- Personal SSH/GPG key material

Prefer local overrides (untracked) such as:

- `~/.zshrc.local`
- `~/.gitconfig.local`
- `~/.config/<tool>/local.*`

## macOS notes

If adding macOS defaults scripts, keep them in `macos/` and ensure:

- They’re opt-in (not auto-run)
- They document the changes they make

## Editing style

- Keep diffs small and easy to review.
- Avoid introducing dependencies unless necessary.
- If adding ignore patterns, ensure we **don’t** ignore real dotfiles unintentionally.
