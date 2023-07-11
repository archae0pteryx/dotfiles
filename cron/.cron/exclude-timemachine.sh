#!/bin/sh
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

EXCLUDE_DIRS=(
  "node_modules"
  ".git"
  "target"
)

for EXCLUDE_DIR in "${EXCLUDE_DIRS[@]}"; do
  find ~/Code -type d -maxdepth 5 -name "*/$EXCLUDE_DIR/*" | xargs -n 1 tmutil addexclusion > ~/.cron/$(date +%Y%m%d)_excluded-$EXCLUDE_DIR.log
done

# find -type d -exec sh -c 'test -f "$1"/foo' -- {} \; -print -prune
# find ~/Code -type d -maxdepth 5 -name 'node_modules' -prune | xargs -n 1 tmutil addexclusion > ~/.cron/$(date +%Y%m%d)_excluded-node_modules.log

# find ~/Code -type d -maxdepth 5 -name '.git' | xargs -n 1 tmutil addexclusion > ~/.cron/$(date +%Y%m%d)_excluded-git.log

# find ~/Code -type d -maxdepth 5 -name 'tmp' | xargs -n 1 tmutil addexclusion > ~/.cron/$(date +%Y%m%d)_excluded-tmp.log

# find ~/Code -type d -maxdepth 5 -name 'target' | xargs -n 1 tmutil addexclusion > ~/.cron/$(date +%Y%m%d)_excluded-target.log

