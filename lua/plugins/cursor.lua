return {
  {
    "danilamihailov/beacon.nvim",
    event = "VeryLazy",
    config = function()
      vim.g.beacon_size = 60
      vim.g.beacon_minimal_jump = 10
      vim.g.beacon_show_jumps = 1
    end,
  },
}
