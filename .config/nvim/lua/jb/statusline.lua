local function codecompanion_adapter_name()
  local chat = require("codecompanion").buf_get_chat(vim.api
    .nvim_get_current_buf())
  if not chat then
    return nil
  end

  return " " .. chat.adapter.formatted_name
end

local function codecompanion_current_model_name()
  local chat = require("codecompanion").buf_get_chat(vim.api
    .nvim_get_current_buf())
  if not chat then
    return nil
  end

  return chat.settings.model
end

require('lualine').setup({
  options = {
    icons_enabled = true,
    -- theme = 'nord',
    theme = 'auto',
    section_separators = {
      left = '',
      right = '',
    },
    component_separators = {
      left = '',
      right = '',
    },
  },
  sections = {
    lualine_b = {
      {
        'diagnostics',
        symbols = {},
      }
    },

    lualine_c = {
      {
        function()
          return " "
        end,
        color = function()
          local status = require("sidekick.status").get()
          if status then
            return status.kind == "Error" and "DiagnosticError" or
                status.busy and "DiagnosticWarn" or "Special"
          end
        end,
        cond = function()
          local status = require("sidekick.status")
          return status.get() ~= nil
        end,
      },
    },

    lualine_x = {
      {
        function()
          local status = require("sidekick.status").cli()
          return " " .. (#status > 1 and #status or "")
        end,
        cond = function()
          return #require("sidekick.status").cli() > 0
        end,
        color = function()
          return "Special"
        end,
      },
      'filetype'
    }
  },
  extensions = {
    'fzf',
    'nvim-tree',
    -- Inspired by: https://github.com/jessevdp/personal.nvim/blob/main/lua/plugins/statusline.lua
    {
      filetypes = { "codecompanion" },
      sections = {
        lualine_a = {
          'mode',
        },
        lualine_b = {
          codecompanion_adapter_name,
        },
        lualine_c = {
          codecompanion_current_model_name,
        },
        lualine_x = {},
        lualine_y = {
          "progress",
        },
        lualine_z = {
          "location",
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {
          codecompanion_adapter_name,
        },
        lualine_c = {
          codecompanion_current_model_name,
        },
        lualine_x = {},
        lualine_y = {
          "progress",
        },
        lualine_z = {},
      },
    },
  },
})
