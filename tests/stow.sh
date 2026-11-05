#!/usr/bin/env bash
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
sandbox=$(mktemp -d)
trap 'rm -rf -- "$sandbox"' EXIT

# Exercise a checkout path with spaces without changing the real home or repo.
checkout="$sandbox/dotfiles checkout"
mkdir -p "$checkout"
cp -R "$repo/Taskfile.yml" "$repo/ghostty" "$repo/linux" "$repo/macos" "$checkout/"

run_task() {
  if ! env HOME="$target" task --dir "$checkout" "$@" >"$sandbox/task.log" 2>&1; then
    cat "$sandbox/task.log" >&2
    return 1
  fi
}

target="$sandbox/linux home"
mkdir -p "$target"
run_task stow:dry PLATFORM=linux
test -z "$(ls -A "$target")"
run_task stow PLATFORM=linux
test -L "$target/.config/ghostty/shared.conf"
test -L "$target/.config/ghostty/linux.conf"
test -L "$target/.config/nvim/init.lua"
test -L "$target/.config/conky/conky.conf"
test -x "$target/.config/rofi/scripts/launcher_t1"
test -f "$target/.config/ghostty/config"
test ! -L "$target/.config/ghostty/config"
test ! -e "$target/etc"
test ! -e "$target/lid-server"
test ! -e "$target/README.md"
test ! -e "$target/.config/git"
cp "$target/.config/ghostty/config" "$sandbox/expected"
run_task linux
cmp "$sandbox/expected" "$target/.config/ghostty/config"

# An Omarchy-owned file keeps its contents, even without a trailing newline.
printf '# ~/.config/ghostty/shared.conf\nfont-size = 14' >"$target/.config/ghostty/config"
run_task linux
test "$(head -n 2 "$target/.config/ghostty/config")" = "$(printf '# ~/.config/ghostty/shared.conf\nfont-size = 14')"
for layer in shared linux; do
  test "$(grep -xcF "config-file = ?~/.config/ghostty/$layer.conf" "$target/.config/ghostty/config")" = 1
done

# Never append through an existing config symlink into another managed file.
rm "$target/.config/ghostty/config"
cp "$sandbox/expected" "$sandbox/managed-config"
ln -s "$sandbox/managed-config" "$target/.config/ghostty/config"
if env HOME="$target" task --dir "$checkout" linux >"$sandbox/task.log" 2>&1; then
  echo 'Expected a symlinked Ghostty config to be rejected' >&2
  exit 1
fi
cmp "$sandbox/expected" "$sandbox/managed-config"

# Stow must preserve conflicting user files.
target="$sandbox/conflicting home"
mkdir -p "$target/.config/nvim"
printf 'keep my config\n' >"$target/.config/nvim/init.lua"
if env HOME="$target" task --dir "$checkout" linux >"$sandbox/task.log" 2>&1; then
  echo 'Expected Stow to reject the existing Neovim config' >&2
  exit 1
fi
test "$(cat "$target/.config/nvim/init.lua")" = 'keep my config'

target="$sandbox/macos home"
mkdir -p "$target"
run_task stow:dry PLATFORM=macos
test -z "$(ls -A "$target")"
run_task stow PLATFORM=macos
test -L "$target/.config/git/config"
test -L "$target/.config/nvim/init.lua"
test -L "$target/.config/herdr/config.toml"
test -L "$target/.config/ccstatusline/settings.json"
test -x "$target/.local/bin/lazyvim"
test -L "$target/.config/ghostty/shared.conf"
run_task macos
for package in alacritty copyq ghostty git hammerspoon kitty nvim starship tmux vim; do
  run_task "macos:$package:dry-run"
  run_task "macos:$package"
done

echo 'PASS: Linux/macOS stow, previews, repeat installs, existing configs and per-package tasks'
