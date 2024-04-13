export def toggle [] {
  if (gsettings get org.gnome.desktop.interface color-scheme) != "'prefer-dark'" {
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface gtk-theme Breeze-Dark
    gsettings set org.gnome.desktop.interface icon-theme breeze-dark

    ln -fs ~/.config/helix/themes/dark.toml ~/.config/helix/themes/theme.toml
    pkill -USR1 hx

    swww img ~/Pictures/wallhaven-kxro37.png

    ln -fs ~/.config/fuzzel/dark.ini ~/.config/fuzzel/fuzzel.ini

    ln -fs ~/.config/swaync/dark.css ~/.config/swaync/style.css
    swaync-client --reload-css

    ln -fs ~/.config/waybar/dark.css ~/.config/waybar/theme.css
    pkill -USR2 waybar
  } else {
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    gsettings set org.gnome.desktop.interface gtk-theme Breeze
    gsettings set org.gnome.desktop.interface icon-theme breeze

    ln -fs ~/.config/helix/themes/light.toml ~/.config/helix/themes/theme.toml
    pkill -USR1 hx

    swww img ~/Pictures/wallhaven-6d73mq.jpg

    ln -fs ~/.config/fuzzel/light.ini ~/.config/fuzzel/fuzzel.ini

    ln -fs ~/.config/swaync/light.css ~/.config/swaync/style.css
    swaync-client --reload-css

    ln -fs ~/.config/waybar/light.css ~/.config/waybar/theme.css
    pkill -USR2 waybar
  }
}
