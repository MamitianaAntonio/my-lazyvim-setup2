return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  config = function()
    require("ibl").setup({
      indent = {
        char = "┊",
        highlight = { "NonText" },
      },
      scope = { enabled = false },
    })

    -- gris très sombre Catppuccin Mocha
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#1e1e2e" })
  end,
}
