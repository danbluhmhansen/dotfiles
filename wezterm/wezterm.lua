local wezterm = require 'wezterm'

local config = wezterm.config_builder()

if os.getenv('XDG_CURRENT_DESKTOP') == 'Hyprland' then
  config.enable_wayland = false;
end

if os.getenv('WEZTERM_DEFAULT_PROG') then
  config.default_prog = {os.getenv('WEZTERM_DEFAULT_PROG')}
end

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

config.native_macos_fullscreen_mode = true

config.color_scheme = scheme_for_appearance(get_appearance())

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.font_size = tonumber(os.getenv('WEZTERM_FONT_SIZE') or '12')
config.font = wezterm.font {
  family = os.getenv('WEZTERM_FONT') or 'Maple Mono NF',
  harfbuzz_features = { 'cv01', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', },
}

config.window_close_confirmation = 'NeverPrompt'

local act = wezterm.action

local keys = {}

if wezterm.hostname() == 'venus.local' then
  table.insert(keys, { key = '§', action = act.SendKey { key = '`' } })
  table.insert(keys, { key = '±', action = act.SendKey { key = '~' } })
  table.insert(keys, { key = '`', action = act.SendKey { key = '§' } })
  table.insert(keys, { key = '~', action = act.SendKey { key = '±' } })
end

config.keys = keys

return config
