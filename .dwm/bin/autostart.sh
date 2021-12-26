#!/usr/bin/env bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
## Autostart Programs

# Kill already running process
_ps=(picom keepassxc dunst ksuperkey mpd xfce-polkit xfce4-power-manager blueman-applet)
for _prs in "${_ps[@]}"; do
	if [[ $(pidof "${_prs}") ]]; then
		killall -9 "${_prs}"
	fi
done

export PATH="$PATH:$HOME/.local/bin"

# Enable power management
xfce4-power-manager &

# Fix cursor
xsetroot -cursor_name left_ptr

# Polkit agent
/usr/lib/xfce-polkit/xfce-polkit &

# Enable Super Keys For Menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# Restore wallpaper
# hsetroot -cover /home/dni9/.dwm/wallpapers/default.png
hsetroot -cover "$(find /home/dni9/.dwm/wallpapers -type f -name '*' | shuf -n 1)"

# Lauch dwmbar
/home/dni9/.dwm/bin/dwmbar.sh &
# Lauch notification daemon
/home/dni9/.dwm/bin/dwmdunst.sh

# Lauch compositor
/home/dni9/.dwm/bin/dwmcomp.sh

# Start mpd
# exec mpd &

export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
wmname LG3D

## Add your autostart programs here --------------
# volumeicon &
exec keepassxc &
exec blueman-applet &
## -----------------------------------------------

dwm
