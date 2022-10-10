export DEFAULT_DISPLAY=1

function is_single_display() {
  yabai -m displays | jq -r 'length == 0'
}

is_single=$(is_single_display)

if [[ $is_single == false ]]; then
  export DEFAULT_DISPLAY=2
fi
