# POSH_THEME_DIR="$(brew --prefix oh-my-posh)/themes"

# LIST_OF_THEMES=()
# while IFS='' read -r line; do LIST_OF_THEMES+=("$line"); done < <(find "$POSH_THEME_DIR" -type f -print)
# TOTAL_NUM_THEMES=${#LIST_OF_THEMES[@]}

# RAND_NUM=$(( RANDOM % TOTAL_NUM_THEMES ))
# SELECTED_THEME="${LIST_OF_THEMES[$RAND_NUM]}"

# echo "${SELECTED_THEME}"

# eval "$(oh-my-posh --init --shell zsh --config ${SELECTED_THEME})"

eval "$(oh-my-posh --init --shell zsh --config /usr/local/opt/oh-my-posh/themes/bubbles.omp.json)"

