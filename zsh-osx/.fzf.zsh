# Setup fzf
# ---------

if [[ ! "$PATH" == */Users/ryan/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/ryan/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/ryan/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/ryan/.fzf/shell/key-bindings.zsh"
