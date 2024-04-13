def fuzzy-pwr [] {
  match ("󰍁 lock\n󰗼 exit\n󰜉 reboot\n shutdown\n theme" | fuzzel --dmenu --index) {
    '0' => (swaylock),
    '1' => (niri msg action quit --skip-confirmation),
    '2' => (reboot),
    '3' => (shutdown now),
    '4' => (use ~/.config/nushell/scripts/theme.nu;(theme toggle)),
  }
}
