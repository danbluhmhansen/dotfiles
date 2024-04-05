#!/bin/bash
ln -fs "$HOME/.config/waybar/light.css" "$HOME/.config/waybar/theme.css"
pkill -USR2 waybar
