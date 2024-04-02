#!/bin/bash
ln -fs "/home/dan/.config/waybar/light.css" "/home/dan/.config/waybar/theme.css"
pkill -USR2 waybar
