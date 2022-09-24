SYS=$(uname -a)

function osx () {
  echo "[+] setup fzf osx"
  if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
  fi
  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
}

function linux () {
  echo "[+] setup fzf linux"
  if [[ ! "$PATH" == */usr/bin/fzf* ]]; then
    PATH="${PATH:+${PATH}:}/usr/bin/fzf"
  fi
  [[ $- == *i* ]] && source "/usr/share/fzf/completion.zsh" 2> /dev/null
  source "/usr/share/fzf/key-bindings.zsh"
}

function windows () {
  echo "[-] WINDOWS NOT SETUP FOR FZF"
}

if [[ "$SYS" == *"Darwin"* ]]; then
  osx
elif [[ "$SYS" == *"Linux"* ]]; then
  linux
else
  windows
fi
