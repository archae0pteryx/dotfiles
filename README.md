# Dotfiles
# WIP
---

### Stow cmds

stow --dotfiles <pkg>


### Decrypt ssh (do not stow)
ansible-vault decrypt <file>


### Add gpg to git

```terminal
# select defaults
gpg --full-generate-key

# get info
gpg --list-secret-keys --keyid-format=long

# copy long form key (sec)
gpg --armor --export <key without algo <algo>/<key>>

# add to GH https://github.com/settings/keys

# add to git
git config --global user.signingkey <key>

# sign all by default
git config --global commit.gpgsign true

# when not using gpg suite (os x) add to shell

if [ -r ~/.zshrc ]; then echo 'export GPG_TTY=$(tty)' >> ~/.zshrc; \
  else echo 'export GPG_TTY=$(tty)' >> ~/.zprofile; fi

# tell git about ssh key
git config --global gpg.format ssh

git config --global user.signingkey /PATH/TO/.SSH/KEY.PUB

```
