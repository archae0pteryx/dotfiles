ZSH_THEME="fino"

plugins=(zsh-autosuggestions git docker sudo)

export PATH="$PATH:$HOME/.local/bin:/usr/local/sbin"
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

#eval "$(oh-my-posh --init --shell zsh --config /usr/local/opt/oh-my-posh/themes/bubbles.omp.json)"

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

. "$HOME/.cargo/env"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.aliases/aliases.core
source $ZSH/oh-my-zsh.sh
