#!/bin/bash
ln -fs "$HOME/.config/helix/themes/dark.toml" "$HOME/.config/helix/themes/theme.toml"
pkill -USR1 hx
