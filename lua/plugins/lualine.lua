return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    -- Custom Catppuccin colors
    local colors = {
      bg = "#1e1e2e",
      fg = "#cdd6f4",
      yellow = "#f9e2af",
      cyan = "#89dceb",
      darkblue = "#89b4fa",
      green = "#a6e3a1",
      orange = "#fab387",
      violet = "#cba6f7",
      magenta = "#f5c2e7",
      blue = "#74c7ec",
      red = "#f38ba8",
    }

    -- Custom theme
    local custom_catppuccin = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = { a = { bg = colors.green, fg = colors.bg, gui = "bold" } },
      visual = { a = { bg = colors.magenta, fg = colors.bg, gui = "bold" } },
      replace = { a = { bg = colors.red, fg = colors.bg, gui = "bold" } },
      command = { a = { bg = colors.yellow, fg = colors.bg, gui = "bold" } },
      inactive = {
        a = { bg = colors.bg, fg = colors.blue, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
    }

    -- Lualine setup
    lualine.setup({
      options = {
        theme = custom_catppuccin,
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { { "branch", icon = "" }, "diff" },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = "  ", readonly = "  " } },
        },
        lualine_x = {
          { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
          { "encoding" },
          { "fileformat", icons_enabled = true },
          { "filetype", icon_only = false },
        },
        lualine_y = { "progress" },
        lualine_z = { { "location", icon = "" } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "nvim-tree", "fugitive", "quickfix" },
    })
  end,
}
