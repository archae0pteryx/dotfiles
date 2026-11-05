#!/usr/bin/env bash
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
mode=$1
shift
platform=macos
case "${1:-}" in
  --mac) shift ;;
  --linux) platform=linux; shift ;;
esac
if [[ $# -gt 1 || ${1:-} == -* ]]; then
  echo 'Usage: task stow[:dry] -- [--mac|--linux] [package]' >&2
  exit 1
fi

package=${1:-}
if [[ -z $package ]]; then
  if [[ $mode == dry ]]; then platform+=:dry; fi
  exec task --silent --dir "$repo" "$platform"
fi
if [[ ! $package =~ ^[[:alnum:]][[:alnum:]_.-]*$ || $package == lid-server || ! -d "$repo/$platform/$package" ]]; then
  echo "Unknown stow package: $platform/$package" >&2
  exit 1
fi
if [[ $mode == dry ]]; then
  exec "$repo/scripts/dryrun.sh" "$platform" "$package"
fi
if [[ $package == ghostty ]]; then
  exec task --silent --dir "$repo" "$platform:ghostty"
fi
exec stow --no-folding --ignore='(^|/)\.DS_Store$' -t "$HOME" -d "$repo/$platform" -R "$package"
