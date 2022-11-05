git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Natural scrolling and accel

sudo /usr/share/X11/xorg.conf.d/40-libinput.conf

Section "InputClass"
	Identifier "Logitech Mouse 1000dpi"
	MatchVendor "Logitech"
	MatchProduct "USB Optical Mouse"
	Driver "libinput"
	MatchIsPointer "yes"
	Option "AccelProfile" "flat"
	Option "AccelSpeed" "-0.6"
EndSection

# PBCOPY alt
sudo pacman -S xsel

# set aliases (linux)
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

sudo pacman -Syu neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# RUST
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | shcurl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


# GPG Github setup
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
gpg --armor --export <sec>


