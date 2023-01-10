function create_and_switch() {
  yabai -m space --create && \
    index=$(yabai -m query --spaces --display | jq 'map(.)[-1].index') && \
    yabai -m space --focus "$index"
}

create_and_switch
