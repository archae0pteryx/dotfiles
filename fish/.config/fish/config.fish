if status is-interactive
  fzf_configure_bindings --directory=\u0192
  set fzf_preview_dir_cmd exa --all --color=always
  set fzf_fd_opts --hidden --exclude=.git
  set -x -U GOPATH $HOME/go
  source (pyenv init - | psub)
  set -gx PATH "/usr/local/go/bin" $PATH
  set -gx VOLTA_HOME "$HOME/.volta"
  set -gx PATH "$VOLTA_HOME/bin" $PATH
  set -gx PATH "$GOPATH/bin" $PATH
  set -gx EDITOR "vim"
  set -gx PATH "$HOME/.ebcli-virtual-env/executables" $PATH
  tmux new-session
end

# Source local config for system-specific settings (not tracked in git)
if test -f ~/.config/fish/config.local.fish
  source ~/.config/fish/config.local.fish
end

# The next line updates PATH for the Google Cloud SDK.
if test -f "$HOME/.local/share/gcloud/path.fish.inc"
  source "$HOME/.local/share/gcloud/path.fish.inc"
end
