def fuzzy-pwr [] {
  match ("󰍁 lock\n󰗼 exit\n󰜉 reboot\n shutdown\n theme" | fuzzel --dmenu --index) {
    '0' => (swaylock),
    '1' => (niri msg action quit --skip-confirmation),
    '2' => (reboot),
    '3' => (shutdown now),
    '4' => (source ~/.config/nushell/scripts/theme-switch.nu;switch-theme),
  }
}
