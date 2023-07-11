if status is-interactive
  fzf_configure_bindings --directory=\u0192
  set fzf_preview_dir_cmd exa --all --color=always
  set fzf_fd_opts --hidden --exclude=.git
  set -gx VOLTA_HOME $HOME/.volta
end


set -gx PNPM_HOME "/Users/rimraf/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

source (pyenv init - | psub)
