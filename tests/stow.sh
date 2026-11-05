#!/usr/bin/env bash
# shellcheck disable=SC2088 # Expected display paths intentionally use a literal tilde.
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
sandbox=$(mktemp -d)
trap 'rm -rf -- "$sandbox"' EXIT

# Exercise a checkout path with spaces without changing the real home or repo.
checkout="$sandbox/dotfiles checkout"
mkdir -p "$checkout"
cp -R "$repo/Taskfile.yml" "$repo/scripts" "$repo/ghostty" "$repo/herdr" "$repo/nvim" "$repo/linux" "$repo/macos" "$checkout/"

run_task() {
  if ! env HOME="$target" task --dir "$checkout" "$@" >"$sandbox/task.log" 2>&1; then
    cat "$sandbox/task.log" >&2
    return 1
  fi
}

target="$sandbox/linux home"
mkdir -p "$target"
run_task stow:dry -- --linux
test "$(cat "$sandbox/task.log")" = 'No differing files (linux).'
test -z "$(ls -A "$target")"
run_task stow -- --linux
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
run_task stow:dry -- --linux
test "$(cat "$sandbox/task.log")" = 'No differing files (linux).'
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
run_task stow:dry -- --linux
test "$(cat "$sandbox/task.log")" = '~/.config/nvim/init.lua'
test "$(env HOME="$target" "$checkout/scripts/dryrun.sh" linux nvim)" = '~/.config/nvim/init.lua'
test "$(env HOME="$target" "$checkout/scripts/dryrun.sh" linux)" = '~/.config/nvim/init.lua'
if env HOME="$target" task --dir "$checkout" linux >"$sandbox/task.log" 2>&1; then
  echo 'Expected Stow to reject the existing Neovim config' >&2
  exit 1
fi
test "$(cat "$target/.config/nvim/init.lua")" = 'keep my config'

# Equal regular files are omitted; broken links and blocked parents are listed.
cp "$checkout/nvim/.config/nvim/init.lua" "$target/.config/nvim/init.lua"
run_task linux:dry
test "$(cat "$sandbox/task.log")" = 'No differing files (linux).'
rm "$target/.config/nvim/init.lua"
ln -s missing "$target/.config/nvim/init.lua"
run_task linux:dry
test "$(cat "$sandbox/task.log")" = '~/.config/nvim/init.lua'
rm -rf "$target/.config"
printf 'blocked\n' >"$target/.config"
run_task linux:dry
test "$(cat "$sandbox/task.log")" = '~/.config'

target="$sandbox/macos home"
mkdir -p "$target"
run_task stow:dry
test "$(cat "$sandbox/task.log")" = 'No differing files (macos).'
test -z "$(ls -A "$target")"
run_task stow
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

# The default is macOS even when only a package name is passed.
target="$sandbox/selected home"
mkdir -p "$target"
run_task stow -- vim
test -L "$target/.config/vim/vimrc"
test ! -e "$target/.config/ghostty"
test ! -e "$target/.config/nvim"
run_task stow:dry -- vim
test "$(cat "$sandbox/task.log")" = 'No differing files (macos).'
run_task stow -- --mac lazyvim
test -x "$target/.local/bin/lazyvim"

target="$sandbox/selected linux home"
mkdir -p "$target/.config/nvim"
printf 'keep my config\n' >"$target/.config/nvim/init.lua"
run_task stow:dry -- --linux nvim
test "$(cat "$sandbox/task.log")" = '~/.config/nvim/init.lua'
test ! -e "$target/.config/ghostty"
rm "$target/.config/nvim/init.lua"
run_task stow -- --linux nvim
test -L "$target/.config/nvim/init.lua"
test ! -e "$target/.config/conky"
run_task stow -- --linux ghostty
test -L "$target/.config/ghostty/shared.conf"
test -L "$target/.config/ghostty/linux.conf"
test -f "$target/.config/ghostty/config"

# Any package directory works without adding another Taskfile task.
cp -R "$checkout/macos/lazyvim" "$checkout/linux/"
run_task stow -- --linux lazyvim
test -x "$target/.local/bin/lazyvim"

target="$sandbox/invalid arguments home"
mkdir -p "$target"
for args in '--windows' '--linux missing' '--linux lid-server' '--mac ../linux' '--linux nvim extra' '--linux --mac'; do
  # shellcheck disable=SC2086 # Each fixture intentionally contains separate CLI arguments.
  if env HOME="$target" task --dir "$checkout" stow -- $args >"$sandbox/task.log" 2>&1; then
    echo "Expected invalid arguments to fail: $args" >&2
    exit 1
  fi
  test -z "$(ls -A "$target")"
done

echo 'PASS: Linux/macOS stow, previews, repeat installs, existing configs and per-package tasks'
