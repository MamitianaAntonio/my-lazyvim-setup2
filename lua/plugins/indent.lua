return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
        },
        scope = { enabled = false },
      })
    end
  },
}
