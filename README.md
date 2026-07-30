# dotfiles

Configuration for my single NixOS desktop. GNU Stow deploys the files from this
repository to their expected locations, while NixOS remains responsible for
building and activating the operating-system configuration.

## Stow packages

- `claude` deploys `~/.claude/CLAUDE.md`.
- `emacs` deploys `~/.config/emacs/init.el`.
- `ncspot` deploys `~/.config/ncspot/config.toml`.
- `nixos` deploys the NixOS configuration to `/etc/nixos`.

## Clone

Clone the repository directly under the home directory so Stow's default target
is the home directory:

```sh
cd ~
git clone git@github.com:Biggels/dotfiles.git
cd dotfiles
```

## Deploy user configuration

Deploy one or more user packages from the repository root:

```sh
stow emacs
stow claude ncspot
```

Remove a package's links without deleting the files in this repository:

```sh
stow --delete emacs
```

## Deploy the NixOS configuration

The NixOS package uses a different target:

```sh
sudo stow --dir="$HOME/dotfiles" --target=/etc/nixos nixos
```

Stow will refuse to overwrite existing regular files. Read
[`nixos/README.md`](nixos/README.md) before the first deployment for the safe
installation and migration sequence.

Once deployed, the files under `/etc/nixos` are symlinks into this repository.
Editing the tracked files therefore edits the active source configuration; a
`nixos-rebuild` is still required to build and activate the change.
