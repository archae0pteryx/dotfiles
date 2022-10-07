#!/bin/bash



open_iterm () {
  osascript -e "
        tell application \"iTerm2\"
          set newWindow to (create window with default profile)
        end tell
      "
}

open_iterm

# yabai -m space --create && \
# index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')" && \
# yabai -m space --focus "${index}" && \
# open_iterm && \
# yabai -m space --label iterm && \
# yabai -m space --swap 2

# osascript -e "
#       tell application \"iTerm2\"
#         set newWindow to (create window with default profile)
#         tell current session of newWindow
#             write text \"env \"
#         end tell
#       end tell
#     "
