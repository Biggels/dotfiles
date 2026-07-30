# NixOS configuration

A deliberately small, non-flake configuration for one desktop. The goal is to
start with a useful, understandable system and add complexity only when there
is a concrete need.

The initial system provides:

- the Plasma desktop
- NetworkManager
- PipeWire audio
- the NVIDIA driver for a GeForce RTX 2060
- Firefox
- Git
- Discord
- Emacs
- GNU Stow

There is no Home Manager, flake, gaming setup, or project-language tooling yet.

## Files

- `configuration.nix` is the human-edited system configuration.
- `hardware-configuration.nix` is generated for this computer during NixOS
  installation. Do not copy one from another computer.

The hardware file is intentionally absent until it has been generated on
`bixos-ibp-9290`.

## First installation

After partitioning and mounting the target system at `/mnt`, generate its
machine-specific configuration:

```sh
sudo nixos-generate-config --root /mnt
```

From the root of this repository, copy the tracked configuration over the
generated starter configuration. Leave the generated hardware file in place
and review its disk mounts:

```sh
sudo cp ./nixos/configuration.nix /mnt/etc/nixos/configuration.nix
```

This configuration uses `system.stateVersion = "26.05"` for a new 26.05
installation. If the generated configuration says the machine was first
installed on an older release, keep that older value instead.

Install NixOS and set a password for the normal user before rebooting:

```sh
sudo nixos-install
sudo nixos-enter --root /mnt -c 'passwd biggels'
```

## Put the hardware file under version control

After the first boot, copy the generated hardware file into this directory:

```sh
cp /etc/nixos/hardware-configuration.nix ~/dotfiles/nixos/
```

Review the copy before committing it. To deploy the Stow package, first move
the existing regular configuration files aside as backups, then create the
links:

```sh
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.before-stow
sudo mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.before-stow
sudo stow --dir="$HOME/dotfiles" --target=/etc/nixos nixos
```

Confirm that `/etc/nixos/configuration.nix` and
`/etc/nixos/hardware-configuration.nix` are symlinks before rebuilding.

## Make a system change

Edit `nixos/configuration.nix` from the repository root, then try the result
without making it the default boot entry:

```sh
sudo nixos-rebuild test
```

If it works, make it the current and default configuration:

```sh
sudo nixos-rebuild switch
```

If a change goes wrong, reboot into an older generation from the boot menu, or
run:

```sh
sudo nixos-rebuild switch --rollback
```

Changing the contents of an already-linked file does not require running Stow
again. Run Stow again only when adding, removing, or relocating files in the
`nixos` package.

## Where new things go

- Add ordinary command-line tools and desktop applications to
  `environment.systemPackages`.
- Prefer a dedicated NixOS option when a program or service has one, as Firefox
  and Git do.
- Add system behavior next to the related section: boot, networking, desktop,
  graphics, audio, users, or programs.
- Split the file into modules only after it becomes difficult to navigate.

Packages and NixOS options can be searched at <https://search.nixos.org/>.

## Project environments

The system configuration does not need language runtimes for every programming
project. To experiment without changing the system, enter a temporary classic
Nix shell:

```sh
nix-shell -p python3
```

When a project needs a repeatable environment, add a `shell.nix` to that
project. Flakes can remain disabled until there is a concrete reason to adopt
them.
