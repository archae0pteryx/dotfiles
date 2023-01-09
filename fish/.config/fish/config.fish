if status is-interactive
    set GPG_TTY $(tty)
end

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx GPG_TTY $(tty)

# Created by `pipx` on 2023-01-09 05:58:12
set PATH $PATH /Users/rimraf/.local/bin
set -gx PATH "$HOME/.local/bin" $PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /opt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
eval "$(pyenv init --path)"
