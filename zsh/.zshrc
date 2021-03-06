source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
ZSH="$HOME/.config/zsh"
ZSH_THEME="nicoulaj"

plugins=(git sudo docker)

export PATH="$PATH:$HOME/.local/bin:/usr/local/sbin:$HOME/.cargo/bin:$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH="$PATH:/usr/local/share/dotnet:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export GPG_TTY=$(tty)

#eval "$(oh-my-posh --init --shell zsh --config /usr/local/opt/oh-my-posh/themes/bubbles.omp.json)"

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source <(cat ~/.aliases/*.alias)
source $ZSH/oh-my-zsh.sh
# source ~/.aliases/eagle.motd
#source ~/.config/zsh/auto-nvm


export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
