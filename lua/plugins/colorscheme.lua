return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      theme = "wave",
      background = { dark = "wave" },
      transparent = true,
      terminalColors = true,
      dimInactive = true,
      colors = {
        theme = {
          wave = {
            ui = {
              bg = "#0d1117",
              bg_dim = "#141b22",
              bg_gutter = "#141b22",
              bg_visual = "#1c2733",
              bg_search = "#1c2733",
              pmenu = { bg = "#141b22" },
            },
          },
        },
      },
      overrides = function(colors)
        local t = colors.theme
        return {
          -- Seamless statusline / lualine integration
          StatusLine = { bg = "#0d1117" },
          StatusLineNC = { bg = "#0d1117" },
          -- Transparent float borders (match Manjaro green accent)
          FloatBorder = { fg = "#34be5b", bg = "NONE" },
          NormalFloat = { bg = "#141b22" },
          -- Telescope
          TelescopeNormal = { bg = "#0d1117" },
          TelescopeBorder = { fg = "#34be5b", bg = "#0d1117" },
          TelescopePromptBorder = { fg = "#34be5b", bg = "#141b22" },
          TelescopePromptNormal = { bg = "#141b22" },
          TelescopeResultsBorder = { fg = "#1c2733", bg = "#0d1117" },
          TelescopePreviewBorder = { fg = "#1c2733", bg = "#0d1117" },
          -- Cursorline subtle
          CursorLine = { bg = "#141b22" },
          CursorLineNr = { fg = "#34be5b", bold = true },
          -- LineNr dim
          LineNr = { fg = "#2a3a2e" },
          -- Indent guides (if using indent-blankline)
          IblIndent = { fg = "#1c2733" },
          IblScope = { fg = "#34be5b" },
          -- Matching parens pop with Manjaro green
          MatchParen = { fg = "#34be5b", bold = true, underline = true },
          -- Search highlight
          Search = { bg = "#1c3a22", fg = "#34be5b", bold = true },
          IncSearch = { bg = "#34be5b", fg = "#0d1117", bold = true },
          -- Git signs (match lualine diff colors)
          GitSignsAdd = { fg = "#34be5b" },
          GitSignsChange = { fg = "#d4a72c" },
          GitSignsDelete = { fg = "#e05c7a" },
          -- Pmenu
          Pmenu = { bg = "#141b22", fg = "#cdd9e5" },
          PmenuSel = { bg = "#1c2733", fg = "#34be5b", bold = true },
          PmenuSbar = { bg = "#141b22" },
          PmenuThumb = { bg = "#34be5b" },
          -- Diagnostics virtual text subtle
          DiagnosticVirtualTextError = { fg = "#e05c7a", bg = "#1a1520" },
          DiagnosticVirtualTextWarn = { fg = "#d4a72c", bg = "#1a1812" },
          DiagnosticVirtualTextInfo = { fg = "#35a5c8", bg = "#111820" },
          DiagnosticVirtualTextHint = { fg = "#2eb398", bg = "#101a18" },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
    },
  },
}
