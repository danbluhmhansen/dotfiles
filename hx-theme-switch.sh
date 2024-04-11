#!/bin/sh
/bin/ln -fs "/Users/dan/.config/helix/themes/$1.toml" "/Users/dan/.config/helix/themes/theme.toml"
/usr/bin/pkill -USR1 hx
