if status is-interactive
  fzf_configure_bindings --directory=\u0192
  set fzf_preview_dir_cmd exa --all --color=always
  set fzf_fd_opts --hidden --exclude=.git
  set -gx VOLTA_HOME $HOME/.volta
end

#source (pyenv init - | psub)
