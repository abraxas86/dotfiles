local wezterm = require 'wezterm'

wezterm.on(
  "update-right-status",
  function(window)
    local date = wezterm.strftime("%Y-%m-%d %H:%M:%S ")
    window:set_right_status(wezterm.format({ { Text = date } }))
  end
)

-- Tab appearance settings
local TAB_BAR_BG = "#0D101B"
local TAB_ACTIVE_BG = "#461556"
local TAB_ACTIVE_FG = "#FFFFFF" --"#EE243D"
local TAB_INACTIVE_BG = "#111111"
local TAB_INACTIVE_FG = "#AF2747"
local TAB_LEFT_CAP = ""
local TAB_RIGHT_CAP = ""
local ICON_NVIM = ""  -- Neovim icon
local ICON_MONITOR = ""  -- Monitor icon

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local is_active = tab.is_active
  local bg_color = is_active and TAB_ACTIVE_BG or TAB_INACTIVE_BG
  local fg_color = is_active and TAB_ACTIVE_FG or TAB_INACTIVE_FG
  local active_pane = tab.active_pane
  local cwd = active_pane.current_working_dir
  local process = active_pane.foreground_process_name
  local title

  -- If in a BASH session, show the last 30 characters of the path
  if process:match("bash") then
    title = cwd and cwd.file_path or "Terminal"
    -- Shorten the path using ~ for $HOME
    local home_dir = os.getenv("HOME")
    title = string.gsub(title, "^" .. home_dir, "~")

    -- Truncate start of the path if it's too long and keep right-side decoration
    local max_length = 30
    if #title > max_length then
      -- Truncate the start and keep the last part of the path
      title = "…" .. title:sub(-max_length)
    end
  elseif process:match("htop") or process:match("btop") then
    -- If the process is htop or btop, show the monitor icon
    title = ICON_MONITOR
  elseif process:match("nvim") then
    -- If the process is nvim, show the Neovim icon
    title = ICON_NVIM
  else
    -- For other processes, show just the process name (e.g., 'htop' instead of '/usr/bin/htop')
    local process_name = process:match("([^/]+)$") -- Extract the program name from the full path
    if process_name then
      title = process_name
    else
      title = ICON_MONITOR
    end
  end

  -- Ensure the right-side decoration (cap) is displayed
  return {
    { Background = { Color = "#0B0022" } },
    { Foreground = { Color = bg_color } },
    { Text = TAB_LEFT_CAP },
    { Background = { Color = bg_color } },
    { Foreground = { Color = fg_color } },
    { Text = " " .. title .. " " },
    { Background = { Color = "#0b0022" } },
    { Foreground = { Color = bg_color } },
    { Text = TAB_RIGHT_CAP },
  }
end)

local wez_conf = {
  font = wezterm.font_with_fallback({
    "EnvyCodeR Nerd Font Mono", 
    "IBM Plex Mono",
    "Noto Sans SC",
  }),
  font_size = 13,
  line_height = 1.2,
  cell_width = 0.9,
  color_scheme = 'Catppuccin Mocha',
  default_cursor_style = "BlinkingBar",
  cursor_blink_rate = 1000,
  cursor_thickness = '1pt',
  force_reverse_video_cursor = false,
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = false,
  tab_bar_at_bottom = true,
  tab_max_width = 40, -- Ensure max tab width is 40
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 }, -- Set all paddings to 0
  window_decorations = "RESIZE",
  native_macos_fullscreen_mode = false,
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,
  use_ime = true,
  window_background_opacity = 0.75,
  term = "xterm-256color",
  automatically_reload_config = false,
}

local action = wezterm.action
wez_conf.keys = {
  { key = 'LeftArrow', mods = 'SHIFT|ALT', action = action.MoveTabRelative(-1) },
  { key = 'RightArrow', mods = 'SHIFT|ALT', action = action.MoveTabRelative(1) },
}

wez_conf.colors = {
  background = '#000000',
}

return wez_conf

