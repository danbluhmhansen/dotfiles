local wezterm = require 'wezterm'

local config = wezterm.config_builder()

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

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3)
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  local scheme = wezterm.get_builtin_color_schemes()[scheme_for_appearance(get_appearance())]

  -- Color palette for the backgrounds of each cell
  local colors = {
    scheme.tab_bar.background,
    scheme.tab_bar.inactive_tab.bg_color,
    scheme.tab_bar.inactive_tab_hover.bg_color,
    scheme.tab_bar.new_tab.bg_color,
    scheme.tab_bar.new_tab_hover.bg_color,
  }

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = cwd_uri.file_path
    local hostname = cwd_uri.host or wezterm.hostname()

    -- Remove the domain name portion of the hostname
    local dot = hostname:find '[.]'
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == '' then
      hostname = wezterm.hostname()
    end

    local home = cwd:gsub(wezterm.home_dir, "~")

    local success, stdout, stderr = wezterm.run_child_process {
      os.getenv('WEZTERM_DEFAULT_PROG'),
      '-c',
      'use ($nu.default-config-dir | path join scripts/gstat.nu);gstat prompt ' .. cwd,
    }

    table.insert(cells, success and stdout:match("^%s*(.-)%s*$") or '')
    table.insert(cells, home)
    -- table.insert(cells, hostname)
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14"
  local date = wezterm.strftime '%F %T'
  table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  -- for _, b in ipairs(wezterm.battery_info()) do
  --   table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  -- end

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = scheme.foreground } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

config.native_macos_fullscreen_mode = true

config.color_scheme = scheme_for_appearance(get_appearance())

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

config.font_size = tonumber(os.getenv('WEZTERM_FONT_SIZE') or '12')
config.font = wezterm.font {
  family = os.getenv('WEZTERM_FONT') or 'Maple Mono NF',
  harfbuzz_features = { 'cv01', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', },
}

config.window_close_confirmation = 'NeverPrompt'

if wezterm.hostname() == 'jupiter.local' then
  config.window_padding = {
    left = 6,
    right = 0,
    top = 4,
    bottom = 0,
  }
end

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
