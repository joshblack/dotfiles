local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.automatically_reload_config = true

-- Might help with repeat keys getting stuck
config.use_ime = false

-- Color
config.color_scheme = 'OneNord'

-- Font
config.font = wezterm.font_with_fallback {
  {
    family = "JetBrainsMono Nerd Font",
    weight = "Regular",
  },
  {
    family = "JetBrainsMono Nerd Font",
    weight = "Medium",
  },
  {
    family = "JetBrainsMono Nerd Font",
    weight = "Bold",
  },
  "JetBrains Mono",
}
config.font_size = 20
config.line_height = 1.1
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Tab bar
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- Remove all path components and return only the last value
-- https://github.com/wez/wezterm/discussions/4945
local function remove_abs_path(path) return path:gsub("(.*[/\\])(.*)", "%2") end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  return remove_abs_path(tab_info.active_pane.foreground_process_name)
end

-- https://github.com/wez/wezterm/discussions/3924#discussioncomment-6348211
wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local palette = config.resolved_palette.tab_bar
    local colors = {
      bg = palette.background,
      tab = tab.is_active and palette.active_tab.fg_color or
          palette.active_tab.bg_color,
      fg = tab.is_active and palette.active_tab.bg_color or
          palette.inactive_tab.fg_color,
    }

    local prefix = tab.is_active and "" or ""
    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = colors.tab } },
      { Foreground = { Color = colors.fg } },
      { Text = " " .. prefix .. "  " },
      -- { Background = { Color = colors.tab } },
      -- { Foreground = { Color = colors.fg } },
      { Text = tab.tab_index + 1 .. ": " },
      { Text = title },
      -- { Background = { Color = colors.tab } },
      -- { Foreground = { Color = colors.fg } },
      { Text = " " },
      { Background = { Color = colors.bg } },
      { Text = " " },
    }
  end
)

-- Window
-- config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 8,
  right = 8,
  -- top = "1cell",
  top = "1cell",
  bottom = 0,
}

return config
