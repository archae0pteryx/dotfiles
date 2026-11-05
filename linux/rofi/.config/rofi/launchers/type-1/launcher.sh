#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x

dir="$HOME/.config/rofi/launchers/type-1"
theme='style-1'

rofi \
    -combi-modi window,drun,run,ssh \
    -show combi \
    -theme ${dir}/${theme}.rasi
