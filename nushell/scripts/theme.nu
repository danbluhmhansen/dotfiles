export def toggle [] {
  match ($nu.os-info).name {
    'linux' => {
      if (gsettings get org.gnome.desktop.interface color-scheme) != "'prefer-dark'" {
        gsettings set org.gnome.desktop.interface color-scheme prefer-dark
        gsettings set org.gnome.desktop.interface gtk-theme Breeze-Dark
        gsettings set org.gnome.desktop.interface icon-theme breeze-dark

        open ~/.config/helix/themes/theme.toml |
          update inherits catppuccin_latte |
          to toml o> ~/.config/helix/themes/theme.toml
          
        swww img ~/Pictures/wallhaven-kxro37.png
        ln -fs ~/.config/fuzzel/dark.ini ~/.config/fuzzel/fuzzel.ini
        ln -fs ~/.config/swaync/dark.css ~/.config/swaync/style.css
        ln -fs ~/.config/waybar/dark.css ~/.config/waybar/theme.css
      } else {
        gsettings set org.gnome.desktop.interface color-scheme prefer-light
        gsettings set org.gnome.desktop.interface gtk-theme Breeze
        gsettings set org.gnome.desktop.interface icon-theme breeze

        open ~/.config/helix/themes/theme.toml |
          update inherits catppuccin_mocha |
          to toml o> ~/.config/helix/themes/theme.toml
          
        swww img ~/Pictures/wallhaven-6d73mq.jpg
        ln -fs ~/.config/fuzzel/light.ini ~/.config/fuzzel/fuzzel.ini
        ln -fs ~/.config/swaync/light.css ~/.config/swaync/style.css
        ln -fs ~/.config/waybar/light.css ~/.config/waybar/theme.css
      }
      
      pkill -USR1 hx
      pkill -USR2 waybar
      swaync-client --reload-css
    },
    'mac' => {
      # TODO: implement theme switch detection on mac
      if false {
        open ~/.config/helix/themes/theme.toml |
          update inherits catppuccin_latte |
          to toml o> ~/.config/helix/themes/theme.toml
      } else {
        open ~/.config/helix/themes/theme.toml |
          update inherits catppuccin_mocha |
          to toml o> ~/.config/helix/themes/theme.toml
      }
      pkill -USR1 hx
    },
    'windows' => {
      let theme = open ~\AppData\Roaming\helix\themes\theme.toml | get inherits
      if $theme == 'catppuccin_mocha' {
        open ~/AppData/Roaming/helix/themes/theme.toml |
          update inherits catppuccin_latte |
          to toml o> ~/AppData/Roaming/helix/themes/theme.toml
      } else {
        open ~/AppData/Roaming/helix/themes/theme.toml |
          update inherits catppuccin_mocha |
          to toml o> ~/AppData/Roaming/helix/themes/theme.toml
      }
    },
  }
}
