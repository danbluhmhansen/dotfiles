#!/bin/bash
ln -fs "$HOME/.config/helix/themes/light.toml" "$HOME/.config/helix/themes/theme.toml"
pkill -USR1 hx
