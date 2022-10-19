#!/bin/bash
echo "Stowing: zsh-osx, vim, git-common, tmux, yabai, kitty"
stow zsh-osx
stow vim
stow git-common
stow tmux
stow yabai
stow kitty

if [ "$HOSTNAME" = "xenu.local" ]; then
    echo "stowing xenu: git-xenu"
    stow git-xenu
else
    echo "stowing zeal: git-zeal"
    stow git-zeal
fi

