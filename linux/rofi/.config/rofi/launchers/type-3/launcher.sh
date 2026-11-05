#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x

dir="$HOME/.config/rofi/launchers/type-3"
theme='style-10'

rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
