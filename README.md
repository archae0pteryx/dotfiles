# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/) via [Task](https://taskfile.dev).

## Layout

```
macos/<tool>/...   one stow package per tool; contents mirror $HOME
linux/<tool>/...   same, for Linux hosts
ghostty/...        shared Ghostty settings, stowed on both platforms
```

Rules:

- A package is named after the tool. Platform-specific settings live under `macos/` or `linux/`.
- Package directories are discovered automatically. `linux/lid-server` is a separate, opt-in system installer and is never stowed into `$HOME`.
- Retired configs are deleted; git history is the archive.
- Linux hosts get git/vim config from nix, so those packages are macOS-only.
- Linux keeps the minimal Neovim config; macOS has the plugin-based configuration.

## Usage

```
task stow                         # all macOS packages (default on every OS)
task stow -- vim                   # just macos/vim
task stow -- --mac lazyvim         # just macos/lazyvim
task stow -- --linux               # all Linux packages
task stow -- --linux nvim          # just linux/nvim
task stow:dry -- --linux nvim      # list existing files whose contents differ
./scripts/dryrun.sh                # preview all macOS packages
```

The preview prints only short target paths, such as `~/.config/nvim/init.lua`.
New files and identical contents are omitted; an empty list prints
`No differing files (macos).` (or `linux`).
Use `./scripts/dryrun.sh linux` or `./scripts/dryrun.sh macos nvim` to select
a platform or package. It never overwrites files. Stow still refuses conflicting
regular files or symlinks during installation, even if their contents match.

Arguments after `--` select `--mac` (the default) or `--linux`, followed by at
most one package name. The name must match a directory under `macos/` or
`linux/`; for example, `task stow -- --linux lazyvim` works once
`linux/lazyvim/` exists. Selecting Ghostty also installs its shared settings
and, on Linux, adds its config includes. `lid-server` remains a separate task.

To bring a live config under management, copy it into `<platform>/<tool>/` at its `$HOME`-relative path, then `stow --adopt` that package once.

## New Linux host

Install Git, GNU Stow and Task (the `go-task` runner), then clone this repo:

```sh
git clone https://github.com/archae0pteryx/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
task stow:dry -- --linux
task stow -- --linux
```

These tasks install config links, not applications or a desktop environment.
Install Ghostty, Neovim, Rofi and Conky separately if you use them. On a host
without nix managing Git/Vim, install and configure those separately too.

Stow stops on conflicting files. Back up and move only the files it reports,
then repeat the preview. Use `--adopt` only when deliberately importing a live
config: it moves that file into the repo and can replace the tracked version.

Linux setup creates `~/.config/ghostty/config` if needed and appends the shared
and Linux includes once, preserving existing settings. On Omarchy this stays
a regular file so its font and display tools can edit it. If your config is a
symlink, make a backup and convert it to a regular file first. The dry run only
compares package files; it does not create or append this file.

Rofi's bundled themes and applets target an X11 desktop. Install the fonts they
reference (Nerd Fonts and Feather) and Papirus icons; applet commands in
`linux/rofi/.config/rofi/applets/bin/` also depend on your desktop and apps.
For example, `apps.sh` uses `pacman`, screenshots use `maim`/`xdotool`, audio
uses `amixer`, and power menus use `systemctl` and a screen locker. Review the
commands before using them on another distro or Wayland desktop.

Before starting Conky, edit `linux/conky/.config/conky/conky.conf` for the new
machine: it currently uses the `enp5s0` network interface, an NVIDIA GPU
(`nvidia-smi`), FiraCode Nerd Font and an X11 desktop.

The optional [lid-server setup](linux/lid-server/README.md) disables sleep on
a dedicated laptop server. Normal `task stow` never changes `/etc` or sleep
settings. Existing `task linux`, `task macos` and per-package macOS commands
remain available; for one other package use
`stow --no-folding -t "$HOME" -d linux -R <tool>` (and stow the root `ghostty`
package too when selecting Ghostty).

Run `bash tests/stow.sh` to check Linux and macOS installation in temporary
homes, including conflict handling and repeat installs. Requires Task and Stow.
