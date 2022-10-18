#!/bin/zsh
source ~/.aliases/yabai.alias

yabai -m signal --add event=application_launched app="^Firefox" action="yabai -m"
#export DEFAULT_DISPLAY=1
#function is_single_display() {
#  ydisplays | jq -r 'length == 0'
#}
#
#is_single=$(is_single_display)
#
#if [[ $is_single == false ]]; then
#  export DEFAULT_DISPLAY=2
#fi


# all_spaces=()
# while read -r value
# do
#   all_windows_spaces+=("$value")
# done < <(yspaces | jq -r '.[] | .windows | @sh')


# count=0
# for space in "${all_windows_spaces[@]}"; do
#   if [[ "${space}" =~ [0-9] ]]; then
#     echo "space $count : windows $space"
#   else;
#     # yspace --destroy $count
#   fi
#   # for windows in "${space[@]}"
#   #     # echo "space ${space[@]} has ${windows[@]} windows"
#   #   # if [[ "${windows[@]}" == 0 ]]; then
#   #   #   yspaces $space --destroy
#   #   # fi
#   # done
#   let count++
# done

echo "$count"

# if [[ $num_windows == true ]]; then
#   return true
# fi
# return false

# echo "DEBUG: ${space_windows}"
