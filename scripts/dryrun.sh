#!/usr/bin/env bash
# shellcheck disable=SC2088 # Display paths intentionally use a literal tilde.
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
platform=${1:-macos}
case "$platform" in
  macos|linux) ;;
  *) echo 'Usage: dryrun.sh [macos|linux [package ...]]' >&2; exit 1 ;;
esac
if [[ $# -gt 0 ]]; then shift; fi
if [[ $# -eq 0 ]]; then
  exec task --silent --dir "$repo" "$platform:dry"
fi

differences=$({
  for package in "$@"; do
    roots=("$repo/$platform/$package")
    if [[ $package == ghostty ]]; then roots+=("$repo/ghostty"); fi
    for root in "${roots[@]}"; do
      [[ -d $root ]] || { echo "Unknown package: $platform/$package" >&2; exit 1; }
      find "$root" \( -type f -o -type l \) ! -name .DS_Store -print0 |
      while IFS= read -r -d '' source; do
        relative=${source#"$root/"}
        target="$HOME/$relative"
        # A file or broken symlink in a parent directory also blocks installation.
        while [[ ! -e $target && ! -L $target ]]; do target=${target%/*}; done
        if [[ $target != "$HOME/$relative" && -d $target ]]; then continue; fi
        if [[ $target == "$HOME/$relative" && -f $target ]]; then
          if cmp -s "$source" "$target"; then continue; else result=$?; fi
          if [[ $result -ne 1 ]]; then
            printf 'Cannot compare ~/%s\n' "$relative" >&2
            exit "$result"
          fi
        fi
        printf '~/%s\n' "${target#"$HOME/"}"
      done || exit "$?"
    done
  done
} | sort -u)
printf '%s\n' "${differences:-No differing files ($platform).}"
