#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x

dir="$HOME/.config/rofi/launchers/type-7"
theme='style-1'

rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
