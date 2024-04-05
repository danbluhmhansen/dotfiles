#!/bin/bash
ln -fs "$HOME/.config/swaync/dark.css" "$HOME/.config/swaync/style.css"
swaync-client --reload-css
