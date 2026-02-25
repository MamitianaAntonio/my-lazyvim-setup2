return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local c = {
      bg     = "#1e2127",
      bg2    = "#282c34",
      fg     = "#abb2bf",
      dim    = "#5c6370",
      blue   = "#61afef",
      green  = "#98c379",
      yellow = "#e5c07b",
      red    = "#e06c75",
      violet = "#c678dd",
      cyan   = "#56b6c2",
      orange = "#d19a66",
    }

    local circle = { "◐", "◓", "◑", "◒" }
    local tick = 0

    vim.fn.timer_start(120, function()
      tick = (tick + 1) % #circle
      require("lualine").refresh()
    end, { ["repeat"] = -1 })

    local function spinner()
      return circle[tick + 1]
    end

    -- Mode
    local modes = {
      n       = { label = "󰋜 NORMAL", color = c.blue },
      i       = { label = "󰏫 INSERT", color = c.green },
      v       = { label = "󰈈 VISUAL", color = c.violet },
      V       = { label = "󰈈 V-LINE", color = c.violet },
      ["\22"] = { label = "󰈈 V-BLOCK", color = c.violet },
      c       = { label = " COMMAND", color = c.yellow },
      R       = { label = "󰛔 REPLACE", color = c.red },
      t       = { label = " TERMINAL", color = c.cyan },
    }

    local function mode_info()
      return modes[vim.fn.mode()] or { label = " ??????", color = c.fg }
    end

    -- 💎 Macro recording indicator
    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg == "" then return "" end
      return "󰑋 REC @" .. reg
    end

    -- 💎 Word & char count
    local function word_count()
      local mode = vim.fn.mode()
      local wc = vim.fn.wordcount()
      if mode == "v" or mode == "V" or mode == "\22" then
        if wc.visual_words then
          return "󰯂 " .. wc.visual_words .. "w sel"
        end
      end
      return "󰯂 " .. (wc.words or 0) .. "w"
    end

    -- 💎 Search count
    local function search_count()
      if vim.v.hlsearch == 0 then return "" end
      local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 50 })
      if not ok or result.total == 0 then return "" end
      return string.format("󰍉 %d/%d", result.current, result.total)
    end

    -- 💎 Mixed indent warning
    local function mixed_indent()
      local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false)
      local has_space, has_tab = false, false
      for _, line in ipairs(lines) do
        if line:match("^ ") then has_space = true end
        if line:match("^\t") then has_tab = true end
      end
      if has_space and has_tab then return "󰅖 mixed" end
      return ""
    end

    -- 💎 Git blame (current line)
    local function git_blame()
      local info = vim.b.gitsigns_blame_line_dict
      if not info then return "" end
      local author = info.author or "?"
      if author == "Not Committed Yet" then return "󰜄 uncommitted" end
      if #author > 15 then author = author:sub(1, 12) .. "…" end
      local date = info.author_time
          and os.date("%d %b", tonumber(info.author_time))
          or ""
      return "󰊢 " .. author .. " · " .. date
    end

    -- 💎 Python venv
    local function venv()
      local v = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV")
      if not v then return "" end
      return " " .. (v:match("([^/]+)$") or v)
    end

    -- 💎 File size
    local function file_size()
      local size = vim.fn.getfsize(vim.fn.expand("%:p"))
      if size <= 0 then return "" end
      local units = { "B", "K", "M", "G" }
      local i = 1
      while size >= 1024 and i < #units do
        size = size / 1024
        i = i + 1
      end
      return string.format("󰋊 %.1f%s", size, units[i])
    end

    -- 💎 CWD folder name
    local function cwd_name()
      local cwd = vim.fn.getcwd()
      return "󱉭 " .. (cwd:match("([^/]+)$") or cwd)
    end

    -- 💎 Lazy.nvim startup time
    local startuptime_cache = nil
    local function startuptime()
      if startuptime_cache then return startuptime_cache end
      local ok, lazy = pcall(require, "lazy")
      if ok and lazy.stats then
        local s = lazy.stats()
        startuptime_cache = string.format("󱐋 %.0fms", s.startuptime)
      else
        startuptime_cache = ""
      end
      return startuptime_cache
    end

    -- 💎 Copilot / AI status
    local function copilot_status()
      local ok, cp = pcall(require, "copilot.client")
      if not ok then return "" end
      if cp.is_disabled() then return "󰅖 copilot off" end
      return " copilot"
    end

    -- Sections
    opts.options = {
      theme                = "onedark",
      globalstatus         = true,
      component_separators = { left = "│", right = "│" },
      section_separators   = { left = "", right = "" },
      refresh              = { statusline = 120 },
    }

    opts.sections = {
      lualine_a = {
        {
          function() return " " .. mode_info().label .. " " end,
          color = function()
            return { fg = c.bg, bg = mode_info().color, gui = "bold" }
          end,
          separator = { right = "" },
          padding = 0,
        },
        -- 💎 Macro recording (red pill, only when active)
        {
          macro_recording,
          color = { fg = c.bg, bg = c.red, gui = "bold" },
          cond = function() return vim.fn.reg_recording() ~= "" end,
          separator = { right = "" },
          padding = { left = 1, right = 1 },
        },
      },

      lualine_b = {
        -- CWD
        { cwd_name, color = { fg = c.orange, bg = c.bg2, gui = "bold" } },
        -- Branch
        { "branch", icon = " ",                                         color = { fg = c.violet, bg = c.bg2, gui = "bold" } },
        -- Diff
        {
          "diff",
          symbols = { added = " ", modified = "󰝤 ", removed = " " },
          diff_color = {
            added    = { fg = c.green },
            modified = { fg = c.yellow },
            removed  = { fg = c.red },
          },
          colored = true,
        },
      },

      lualine_c = {
        -- Filename
        {
          "filename",
          path = 1,
          symbols = {
            modified = " ●",
            readonly = " 󰌾",
            unnamed  = " 󰡯 [no name]",
            newfile  = " 󰎔 [new]",
          },
          color = { fg = c.fg, gui = "bold" },
        },
        -- File size
        { file_size, color = { fg = c.dim } },
        -- 💎 Git blame inline
        { git_blame, color = { fg = c.dim, gui = "italic" } },
      },

      -- ── Right ─────────────────────────────────────────────
      lualine_x = {
        -- 💎 Search count
        { search_count,   color = { fg = c.yellow, gui = "bold" } },
        -- 💎 Word count
        { word_count,     color = { fg = c.dim } },
        -- 💎 Mixed indent
        { mixed_indent,   color = { fg = c.orange, gui = "bold" } },
        -- 💎 Copilot
        { copilot_status, color = { fg = c.cyan, gui = "bold" } },
        -- Diagnostics
        {
          "diagnostics",
          sources = { "nvim_lsp" },
          symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          diagnostics_color = {
            error = { fg = c.red },
            warn  = { fg = c.yellow },
            info  = { fg = c.blue },
            hint  = { fg = c.cyan },
          },
          colored = true,
        },
        -- LSP + circle spinner
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "󰌚 no lsp" end
            local names = {}
            for _, cl in ipairs(clients) do table.insert(names, cl.name) end
            return spinner() .. " 󰒋 " .. table.concat(names, ", ")
          end,
          color = function()
            local ok = #vim.lsp.get_clients({ bufnr = 0 }) > 0
            return { fg = ok and c.green or c.dim, gui = "bold" }
          end,
        },
      },

      lualine_y = {
        -- 💎 Python venv
        {
          venv,
          color = { fg = c.yellow, gui = "bold" },
          cond = function()
            return os.getenv("VIRTUAL_ENV") ~= nil
                or os.getenv("CONDA_DEFAULT_ENV") ~= nil
          end,
        },
        -- Indent style
        {
          function()
            local indent = vim.opt.expandtab:get() and "󰌒 spc" or "󰌒 tab"
            return indent .. ":" .. vim.opt.tabstop:get()
          end,
          color = { fg = c.dim },
        },
        -- Filetype
        { "filetype",  icon_only = false,     color = { fg = c.cyan, gui = "bold" } },
        -- Encoding (skip utf-8)
        {
          "encoding",
          fmt = function(s)
            if s == "utf-8" then return "" end
            return "󰉿 " .. s:upper()
          end,
          color = { fg = c.dim },
        },
        -- 💎 Startup time
        { startuptime, color = { fg = c.dim } },
      },

      lualine_z = {
        -- Location
        {
          "location",
          icon = "󰆤",
          color = function()
            return { fg = c.bg, bg = mode_info().color, gui = "bold" }
          end,
          separator = { left = "" },
          padding = { left = 1, right = 1 },
        },
        -- Progress
        {
          "progress",
          icon = "󰓾",
          color = function()
            return { fg = c.bg, bg = mode_info().color, gui = "bold" }
          end,
          padding = { left = 0, right = 1 },
        },
      },
    }

    -- Inactive windows
    opts.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", color = { fg = c.dim } } },
      lualine_x = { { "location", color = { fg = c.dim } } },
      lualine_y = {},
      lualine_z = {},
    }

    return opts
  end,
}
