#!/bin/bash
ln -fs "$HOME/.config/waybar/dark.css" "$HOME/.config/waybar/theme.css"
pkill -USR2 waybar
