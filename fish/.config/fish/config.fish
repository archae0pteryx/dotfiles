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
  set -gx GOOGLE_APPLICATION_CREDENTIALS /home/rimraf/.vault/gcp/sandbox-405917-e3f6c36d8e86.json
  set -gx PATH "$HOME/.ebcli-virtual-env/executables" $PATH
  tmux new-session
end


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/rimraf/.local/share/gcloud/path.fish.inc' ]; . '/home/rimraf/.local/share/gcloud/path.fish.inc'; end
