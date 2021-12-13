#!/usr/bin/env bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## rofi sudo askpass helper
export SUDO_ASKPASS=/home/dni9/.dwm/bin/askpass.sh

## execute the application
sudo -A $1
