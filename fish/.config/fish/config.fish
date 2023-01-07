if status is-interactive
    # Commands to run in interactive sessions can go here
    set GPG_TTY $(tty)
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx GPG_TTY $(tty)
