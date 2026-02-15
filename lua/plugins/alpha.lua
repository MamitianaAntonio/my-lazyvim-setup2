return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- =============================
    -- ANT 3D + GOAT
    -- =============================
    local logo_ant_3d = {
      "                                                     ",
      "       ▄▄▄       ███▄    █ ▄▄▄█████▓                ",
      "      ▒████▄     ██ ▀█   █ ▓  ██▒ ▓▒                ",
      "      ▒██  ▀█▄  ▓██  ▀█ ██▒▒ ▓██░ ▒░                ",
      "      ░██▄▄▄▄██ ▓██▒  ▐▌██▒░ ▓██▓ ░                 ",
      "       ▓█   ▓██▒▒██░   ▓██░  ▒██▒ ░                 ",
      "       ▒▒   ▓▒█░░ ▒░   ▒ ▒   ▒ ░░                   ",
      "        ▒   ▒▒ ░░ ░░   ░ ▒░    ░                    ",
      "                                                     ",
      "              ▄████  ▒█████   ▄▄▄     ▄▄▄█████▓     ",
      "             ██▒ ▀█▒▒██▒  ██▒▒████▄   ▓  ██▒ ▓▒     ",
      "            ▒██░▄▄▄░▒██░  ██▒▒██  ▀█▄ ▒ ▓██░ ▒░     ",
      "            ░▓█  ██▓▒██   ██░░██▄▄▄▄██░ ▓██▓ ░      ",
      "            ░▒▓███▀▒░ ████▓▒░ ▓█   ▓██▒ ▒██▒ ░      ",
      "             ░▒   ▒ ░ ▒░▒░▒░  ▒▒   ▓▒█░ ▒ ░░        ",
      "              ░   ░   ░ ▒ ▒░   ▒   ▒▒ ░   ░         ",
      "            ░ ░   ░ ░ ░ ░ ▒    ░   ▒    ░           ",
      "                  ░     ░ ░        ░  ░             ",
      "                                                     ",
    }

    dashboard.section.header.val = logo_ant_3d
    dashboard.section.header.opts.hl = "AlphaHeader"

    -- =============================
    -- HIGHLIGHT
    -- =============================
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#4f9cff", bold = true })
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#00e676" })
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#e8b75f", italic = true })

    -- =============================
    -- BUTTONS
    -- =============================
    dashboard.section.buttons.val = {
      dashboard.button("f", "  🔍 Find File", ":Telescope find_files <CR>"),
      dashboard.button("n", "  ✨ New File", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "  🕘 Recent Files", ":Telescope oldfiles <CR>"),
      dashboard.button("p", "  📙 Recent Project", ":Telescope project<CR>"),
      dashboard.button("g", "  🌍 Find Text", ":Telescope live_grep <CR>"),
      dashboard.button("c", "  ⚙ Config", ":e $MYVIMRC <CR>"),
      dashboard.button("l", "  📦 Lazy", ":Lazy<CR>"),
      dashboard.button("q", "  ⏻ Quit", ":qa<CR>"),
    }

    dashboard.section.buttons.opts.hl = "AlphaButtons"

    -- =============================
    -- FOOTER
    -- =============================
    dashboard.section.footer.val = "⚡ GOAT MODE ⚡"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- =============================
    -- LAYOUT
    -- =============================
    dashboard.config.layout = {
      { type = "padding", val = 3 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    dashboard.config.opts.noautocmd = true
    vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])

    alpha.setup(dashboard.config)
  end,
}
