#!/bin/bash
ln -fs "$HOME/.config/swaync/light.css" "$HOME/.config/swaync/style.css"
swaync-client --reload-css
