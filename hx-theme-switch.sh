#!/bin/sh

if [ "$1" = "dark" ]; then
  echo 'inherits = "catppuccin_mocha"' > /Users/dan/.config/helix/themes/theme.toml
else
  echo 'inherits = "catppuccin_latte"' > /Users/dan/.config/helix/themes/theme.toml
fi

pkill -USR1 hx
