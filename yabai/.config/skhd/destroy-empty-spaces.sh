#!/bin/bash
spaces=$(yabai -m query --spaces --display | jq -r 'map(select(.windows | length == 0).index)' | jq -r '.[]')

echo "${spaces}"

for space in $spaces; do
  yabai -m space ${space} --destroy
done
