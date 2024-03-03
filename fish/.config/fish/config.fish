if status is-interactive
  fzf_configure_bindings --directory=\u0192
  set fzf_preview_dir_cmd exa --all --color=always
  set fzf_fd_opts --hidden --exclude=.git
  set -gx VOLTA_HOME $HOME/.volta

  set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
  source /usr/share/powerline/bindings/fish/powerline-setup.fish
  powerline-setup

  tmux attach -t base || tmux new -s base
end

source (pyenv init - | psub)
