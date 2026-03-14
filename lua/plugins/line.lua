return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- all manjaro custom colors
    local c = {
      bg = "#0d1117",
      bg2 = "#141b22",
      bg3 = "#1c2733",
      fg = "#cdd9e5",
      dim = "#4a6070",
      green = "#34be5b",
      green2 = "#26a447",
      teal = "#2eb398",
      cyan = "#39c5cf",
      blue = "#35a5c8",
      violet = "#9b7fd4",
      red = "#e05c7a",
      orange = "#e5b567",
      yellow = "#d4a72c",
    }

    -- 1. Spinning arc (LSP activity)
    local arcs = { "◜", "◠", "◝", "◞", "◡", "◟" }
    -- 2. Bouncing dots (macro rec)
    local dots = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
    -- 3. Manjaro leaf pulse (mode)
    local leaves = { "", "", "", "", "", "", "", "" }
    -- 4. Wave bar (progress)
    local bars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", "▇", "▆", "▅", "▄", "▃", "▂" }

    local tick = 0
    local tick2 = 0
    local tick3 = 0

    -- Fast tick: arcs + dots (80ms)
    vim.fn.timer_start(80, function()
      tick = (tick + 1) % #arcs
      require("lualine").refresh()
    end, { ["repeat"] = -1 })

    -- Medium tick: leaves (200ms)
    vim.fn.timer_start(200, function()
      tick2 = (tick2 + 1) % #leaves
    end, { ["repeat"] = -1 })

    -- Slow tick: wave bar (130ms)
    vim.fn.timer_start(130, function()
      tick3 = (tick3 + 1) % #bars
    end, { ["repeat"] = -1 })

    local function arc_spin()
      return arcs[tick + 1]
    end
    local function dot_spin()
      return dots[tick + 1]
    end
    local function leaf_pulse()
      return leaves[tick2 + 1]
    end
    local function wave_bar()
      return bars[tick3 + 1]
    end

    -- ── Mode map ─────────────────────────────────────────
    local modes = {
      n = { label = "NORMAL", icon = "󰋜", color = c.green },
      i = { label = "INSERT", icon = "󰏫", color = c.cyan },
      v = { label = "VISUAL", icon = "󰈈", color = c.violet },
      V = { label = "V·LINE", icon = "󰈈", color = c.violet },
      ["\22"] = { label = "V·BLOCK", icon = "󰈈", color = c.violet },
      c = { label = "COMMAND", icon = "", color = c.yellow },
      R = { label = "REPLACE", icon = "󰛔", color = c.red },
      t = { label = "TERMINAL", icon = "", color = c.teal },
      s = { label = "SELECT", icon = "󰒅", color = c.orange },
    }

    local function mode_info()
      return modes[vim.fn.mode()] or { label = "??????", icon = "󰘌", color = c.dim }
    end

    -- ── Components ───────────────────────────────────────

    -- Animated mode pill: leaf + icon + label
    local function mode_component()
      local m = mode_info()
      return " " .. leaf_pulse() .. " " .. m.icon .. " " .. m.label .. " "
    end

    -- Macro: animated dot spinner + reg name
    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return dot_spin() .. " REC @" .. reg
    end

    -- Search count
    local function search_count()
      if vim.v.hlsearch == 0 then
        return ""
      end
      local ok, r = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 50 })
      if not ok or r.total == 0 then
        return ""
      end
      return string.format("󰍉 %d/%d", r.current, r.total)
    end

    -- Word count
    local function word_count()
      local wc = vim.fn.wordcount()
      local mode = vim.fn.mode()
      if (mode == "v" or mode == "V" or mode == "\22") and wc.visual_words then
        return "󱀍 " .. wc.visual_words .. "w"
      end
      return "󱀍 " .. (wc.words or 0) .. "w"
    end

    -- Mixed indent
    local function mixed_indent()
      local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false)
      local sp, tb = false, false
      for _, l in ipairs(lines) do
        if l:match("^ ") then
          sp = true
        end
        if l:match("^\t") then
          tb = true
        end
      end
      return (sp and tb) and "󰅖 mixed" or ""
    end

    -- Git blame
    local function git_blame()
      local info = vim.b.gitsigns_blame_line_dict
      if not info then
        return ""
      end
      local author = info.author or "?"
      if author == "Not Committed Yet" then
        return "󰜄 uncommitted"
      end
      if #author > 14 then
        author = author:sub(1, 11) .. "…"
      end
      local date = info.author_time and os.date("%d %b", tonumber(info.author_time)) or ""
      return "󰊢 " .. author .. " · " .. date
    end

    -- Python venv
    local function venv()
      local v = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV")
      if not v then
        return ""
      end
      return " " .. (v:match("([^/]+)$") or v)
    end

    -- File size
    local function file_size()
      local sz = vim.fn.getfsize(vim.fn.expand("%:p"))
      if sz <= 0 then
        return ""
      end
      local u = { "B", "K", "M", "G" }
      local i = 1
      while sz >= 1024 and i < #u do
        sz = sz / 1024
        i = i + 1
      end
      return string.format("󰋊 %.1f%s", sz, u[i])
    end

    -- CWD
    local function cwd_name()
      local cwd = vim.fn.getcwd()
      return "󱉭 " .. (cwd:match("([^/]+)$") or cwd)
    end

    -- Startup time (cached)
    local _startup = nil
    local function startuptime()
      if _startup then
        return _startup
      end
      local ok, lazy = pcall(require, "lazy")
      _startup = (ok and lazy.stats) and string.format("󱐋 %.0fms", lazy.stats().startuptime) or ""
      return _startup
    end

    -- Copilot
    local function copilot_status()
      local ok, cp = pcall(require, "copilot.client")
      if not ok then
        return ""
      end
      return cp.is_disabled() and "󰅖 copilot" or " copilot"
    end

    -- Animated LSP: arc spinner + client names
    local function lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return "󰌚 no lsp"
      end
      local names = {}
      for _, cl in ipairs(clients) do
        table.insert(names, cl.name)
      end
      return arc_spin() .. " 󰒋 " .. table.concat(names, " · ")
    end

    -- Animated progress: wave bar + percentage
    local function animated_progress()
      local cur = vim.fn.line(".")
      local total = vim.fn.line("$")
      if total == 0 then
        return ""
      end
      local pct = math.floor(cur / total * 100)
      return wave_bar() .. " " .. pct .. "%%"
    end

    -- ── Theme ────────────────────────────────────────────
    local manjaro_theme = {
      normal = {
        a = { fg = c.bg, bg = c.green, gui = "bold" },
        b = { fg = c.fg, bg = c.bg3 },
        c = { fg = c.fg, bg = c.bg2 },
      },
      insert = { a = { fg = c.bg, bg = c.cyan, gui = "bold" } },
      visual = { a = { fg = c.bg, bg = c.violet, gui = "bold" } },
      replace = { a = { fg = c.bg, bg = c.red, gui = "bold" } },
      command = { a = { fg = c.bg, bg = c.yellow, gui = "bold" } },
      terminal = { a = { fg = c.bg, bg = c.teal, gui = "bold" } },
      inactive = {
        a = { fg = c.dim, bg = c.bg },
        b = { fg = c.dim, bg = c.bg },
        c = { fg = c.dim, bg = c.bg },
      },
    }

    -- ── Options ──────────────────────────────────────────
    opts.options = {
      theme = manjaro_theme,
      globalstatus = true,
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "", right = "" },
      refresh = { statusline = 80 },
    }

    -- ── Sections ─────────────────────────────────────────
    opts.sections = {
      lualine_a = {
        -- Animated mode pill
        {
          mode_component,
          color = function()
            return { fg = c.bg, bg = mode_info().color, gui = "bold" }
          end,
          separator = { right = "" },
          padding = 0,
        },
        -- Macro recording (only when active, animated)
        {
          macro_recording,
          color = { fg = c.bg, bg = c.red, gui = "bold" },
          cond = function()
            return vim.fn.reg_recording() ~= ""
          end,
          separator = { right = "" },
          padding = { left = 1, right = 1 },
        },
      },

      lualine_b = {
        { cwd_name, color = { fg = c.green, bg = c.bg3, gui = "bold" } },
        {
          "branch",
          icon = " ",
          color = { fg = c.violet, bg = c.bg3, gui = "bold" },
        },
        {
          "diff",
          symbols = { added = " ", modified = "󰝤 ", removed = " " },
          diff_color = {
            added = { fg = c.green },
            modified = { fg = c.yellow },
            removed = { fg = c.red },
          },
          colored = true,
        },
      },

      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = {
            modified = " ●",
            readonly = " 󰌾",
            unnamed = " 󰡯 [no name]",
            newfile = " 󰎔 [new]",
          },
          color = { fg = c.fg, gui = "bold" },
        },
        { file_size, color = { fg = c.dim } },
        { git_blame, color = { fg = c.dim, gui = "italic" } },
      },

      lualine_x = {
        { search_count, color = { fg = c.yellow, gui = "bold" } },
        { word_count, color = { fg = c.dim } },
        { mixed_indent, color = { fg = c.orange, gui = "bold" } },
        { copilot_status, color = { fg = c.teal, gui = "bold" } },
        {
          "diagnostics",
          sources = { "nvim_lsp" },
          symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          diagnostics_color = {
            error = { fg = c.red },
            warn = { fg = c.yellow },
            info = { fg = c.blue },
            hint = { fg = c.cyan },
          },
          colored = true,
        },
        -- Animated LSP spinner
        {
          lsp_status,
          color = function()
            local ok = #vim.lsp.get_clients({ bufnr = 0 }) > 0
            return { fg = ok and c.green or c.dim, gui = "bold" }
          end,
        },
      },

      lualine_y = {
        {
          venv,
          color = { fg = c.yellow, gui = "bold" },
          cond = function()
            return os.getenv("VIRTUAL_ENV") ~= nil or os.getenv("CONDA_DEFAULT_ENV") ~= nil
          end,
        },
        {
          function()
            local indent = vim.opt.expandtab:get() and "󰌒 spc" or "󰌒 tab"
            return indent .. ":" .. vim.opt.tabstop:get()
          end,
          color = { fg = c.dim },
        },
        { "filetype", icon_only = false, color = { fg = c.cyan, gui = "bold" } },
        {
          "encoding",
          fmt = function(s)
            return s == "utf-8" and "" or "󰉿 " .. s:upper()
          end,
          color = { fg = c.dim },
        },
        { startuptime, color = { fg = c.dim } },
      },

      lualine_z = {
        {
          "location",
          icon = "󰆤",
          color = function()
            return { fg = c.bg, bg = mode_info().color, gui = "bold" }
          end,
          separator = { left = "" },
          padding = { left = 1, right = 1 },
        },
        -- Animated wave progress
        {
          animated_progress,
          color = function()
            return { fg = c.bg, bg = mode_info().color, gui = "bold" }
          end,
          padding = { left = 0, right = 1 },
        },
      },
    }

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
