local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.default_prog = {'/usr/bin/nu'}

config.color_scheme = 'Catppuccin Mocha'

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font {
  family = 'Maple Mono NF',
  harfbuzz_features = { 'cv01', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', },
}

config.window_close_confirmation = 'NeverPrompt'

return config
