return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- =============================
    -- COLORS
    -- =============================
    local colors = {
      BG = "#16181b",
      FG = "#c5c4c4",
      BLUE = "#4f9cff",
      VIOLET = "#7a3ba8",
      RED = "#ff3344",
      GREEN = "#00e676",
      YELLOW = "#e8b75f",
      CYAN = "#00bcd4",
      ORANGE = "#ff7733",
      MAGENTA = "#ff00ff",
      PINK = "#ff69b4",
    }

    -- =============================
    -- MODE COLOR
    -- =============================
    local function get_mode_color()
      local m = vim.fn.mode()
      if m == "n" then return colors.BLUE end
      if m == "i" then return colors.VIOLET end
      if m == "v" or m == "V" then return colors.RED end
      if m == "R" then return colors.ORANGE end
      if m == "c" then return colors.GREEN end
      if m == "t" then return colors.CYAN end
      return colors.FG
    end

    -- =============================
    -- COLOR BLEND
    -- =============================
    local function blend(c1, c2, t)
      local function hex_to_rgb(hex)
        return tonumber(hex:sub(2, 3), 16),
            tonumber(hex:sub(4, 5), 16),
            tonumber(hex:sub(6, 7), 16)
      end

      local function lerp(a, b, t) return math.floor(a + (b - a) * t) end

      local r1, g1, b1 = hex_to_rgb(c1)
      local r2, g2, b2 = hex_to_rgb(c2)

      return string.format(
        "#%02X%02X%02X",
        lerp(r1, r2, t),
        lerp(g1, g2, t),
        lerp(b1, b2, t)
      )
    end

    -- =============================
    -- GLOBAL ANIMATION ENGINE
    -- =============================
    local tick = 0
    local pulse = 0
    local direction = 1
    local rainbow_offset = 0
    local breath = 0
    local wave_phase = 0

    vim.fn.timer_start(50, function()
      tick = tick + 1

      -- Pulse basique
      pulse = pulse + (0.04 * direction)
      if pulse >= 1 then direction = -1 end
      if pulse <= 0 then direction = 1 end

      -- Respiration lente
      breath = (math.sin(tick / 30) + 1) / 2

      -- Rainbow rotation
      rainbow_offset = (rainbow_offset + 0.02) % 1

      -- Wave phase
      wave_phase = (wave_phase + 0.1) % (math.pi * 2)

      require("lualine").refresh()
    end, { ["repeat"] = -1 })

    -- =============================
    -- RAINBOW CYCLE
    -- =============================
    local function rainbow_color()
      local rainbow = {
        colors.RED,
        colors.ORANGE,
        colors.YELLOW,
        colors.GREEN,
        colors.CYAN,
        colors.BLUE,
        colors.VIOLET,
        colors.MAGENTA,
      }
      local idx = math.floor(rainbow_offset * #rainbow) + 1
      return rainbow[idx]
    end

    -- =============================
    -- SPINNERS (plus de variantes)
    -- =============================
    local spinner1 = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local spinner2 = { "◐", "◓", "◑", "◒" }
    local spinner3 = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
    local spinner4 = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", "▇", "▆", "▅", "▄", "▃", "▂" }
    local spinner5 = { "◜", "◝", "◞", "◟" }
    local spinner6 = { "⠁", "⠂", "⠄", "⡀", "⢀", "⠠", "⠐", "⠈" }

    -- =============================
    -- ENERGY BAR (amélioré)
    -- =============================
    local function energy_bar()
      local width = 10
      local pos = tick % width
      local bar = ""
      for i = 0, width - 1 do
        local dist = math.abs(i - pos)
        if dist == 0 then
          bar = bar .. "█"
        elseif dist == 1 then
          bar = bar .. "▓"
        elseif dist == 2 then
          bar = bar .. "▒"
        else
          bar = bar .. "░"
        end
      end
      return bar
    end

    -- =============================
    -- BOUNCING BAR
    -- =============================
    local function bouncing_bar()
      local width = 12
      local pos = tick % (width * 2)
      if pos >= width then pos = width * 2 - pos end

      local bar = ""
      for i = 0, width - 1 do
        if i == pos then
          bar = bar .. "●"
        else
          bar = bar .. "○"
        end
      end
      return bar
    end

    -- =============================
    -- WAVEFORM
    -- =============================
    local function waveform()
      local chars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
      local wave = ""
      for i = 1, 8 do
        local v = math.sin(wave_phase + i * 0.5)
        local idx = math.floor((v + 1) / 2 * (#chars - 1)) + 1
        wave = wave .. chars[idx]
      end
      return wave
    end

    -- =============================
    -- SIN WAVE EFFECT (amélioré)
    -- =============================
    local function wave_char()
      local v = math.sin(tick / 3)
      if v > 0.6 then
        return "≈"
      elseif v > 0.2 then
        return "~"
      elseif v > -0.2 then
        return "-"
      elseif v > -0.6 then
        return "_"
      else
        return "."
      end
    end

    -- =============================
    -- MATRIX RAIN
    -- =============================
    local matrix_chars = { "ﾊ", "ﾐ", "ﾋ", "ｰ", "ｳ", "ｼ", "ﾅ", "ﾓ", "ﾆ", "ｻ", "ﾜ", "ﾂ" }
    local function matrix_rain()
      if tick % 3 == 0 then
        return matrix_chars[math.random(#matrix_chars)]
      end
      return matrix_chars[(tick % #matrix_chars) + 1]
    end

    -- =============================
    -- RANDOM GLITCH (amélioré)
    -- =============================
    local glitch_chars = { "#", "%", "&", "@", "▓", "▒", "░", "█", "╳", "╱", "╲" }
    local function glitch()
      if tick % 35 == 0 then
        return glitch_chars[math.random(#glitch_chars)]
      end
      return ""
    end

    -- =============================
    -- PULSING DOTS
    -- =============================
    local function pulsing_dots()
      local dots = { "·", "•", "●", "•" }
      return dots[(tick % #dots) + 1]:rep(3)
    end

    -- =============================
    -- HEARTBEAT
    -- =============================
    local function heartbeat()
      local beat = math.abs(math.sin(tick / 5))
      if beat > 0.9 then
        return "💓"
      elseif beat > 0.7 then
        return "💗"
      else
        return "♥"
      end
    end

    -- =============================
    -- EQUALIZER BARS
    -- =============================
    local function equalizer()
      local bars = ""
      for i = 1, 5 do
        local height = math.floor((math.sin(tick / 10 + i) + 1) * 4)
        local bar_chars = { "▁", "▃", "▅", "▇", "█" }
        bars = bars .. bar_chars[height + 1]
      end
      return bars
    end

    -- =============================
    -- CLEAN SECTIONS
    -- =============================
    opts.options.component_separators = ""
    opts.options.section_separators = ""
    opts.sections.lualine_c = {}
    opts.sections.lualine_x = {}

    -- =============================
    -- LEFT SECTION
    -- =============================

    -- MODE CORE (avec breath)
    table.insert(opts.sections.lualine_c, {
      function()
        return " " .. vim.fn.mode():upper() .. " "
      end,
      color = function()
        local base = get_mode_color()
        local dynamic = blend(base, colors.FG, breath)
        return { fg = colors.BG, bg = dynamic, gui = "bold" }
      end,
    })

    -- TRIPLE SPINNER COMBO
    table.insert(opts.sections.lualine_c, {
      function()
        return spinner1[(tick % #spinner1) + 1]
            .. spinner3[(tick % #spinner3) + 1]
            .. spinner5[(tick % #spinner5) + 1]
      end,
      color = function()
        return { fg = rainbow_color(), gui = "bold" }
      end,
    })

    -- ENERGY BAR
    table.insert(opts.sections.lualine_c, {
      function() return energy_bar() end,
      color = function()
        return { fg = blend(colors.GREEN, colors.CYAN, pulse) }
      end,
    })

    -- WAVEFORM
    table.insert(opts.sections.lualine_c, {
      function() return waveform() end,
      color = function()
        return { fg = blend(colors.BLUE, colors.MAGENTA, breath) }
      end,
    })

    -- WAVE + GLITCH + MATRIX
    table.insert(opts.sections.lualine_c, {
      function()
        return wave_char() .. glitch() .. matrix_rain()
      end,
      color = function()
        return { fg = blend(get_mode_color(), colors.YELLOW, pulse) }
      end,
    })

    -- PULSING DOTS
    table.insert(opts.sections.lualine_c, {
      function() return pulsing_dots() end,
      color = function()
        return { fg = blend(colors.CYAN, colors.PINK, breath) }
      end,
    })

    -- FILENAME GLOW
    table.insert(opts.sections.lualine_c, {
      "filename",
      color = function()
        return { fg = blend(colors.FG, get_mode_color(), pulse), gui = "bold" }
      end,
    })

    -- HEARTBEAT
    table.insert(opts.sections.lualine_c, {
      function() return heartbeat() end,
      color = function()
        return { fg = blend(colors.RED, colors.PINK, breath) }
      end,
    })

    -- GIT PULSE (avec plus d'effet)
    table.insert(opts.sections.lualine_c, {
      function()
        local g = vim.b.gitsigns_status_dict
        if not g then return "" end
        local total = (g.added or 0) + (g.changed or 0) + (g.removed or 0)
        if total == 0 then return "" end

        local icon = spinner2[(tick % #spinner2) + 1]
        return string.format(" %s +%d ~%d -%d ", icon, g.added or 0, g.changed or 0, g.removed or 0)
      end,
      color = function()
        return { fg = blend(colors.YELLOW, colors.RED, pulse), gui = "bold" }
      end,
    })

    -- =============================
    -- RIGHT SECTION
    -- =============================

    -- EQUALIZER
    table.insert(opts.sections.lualine_x, {
      function() return equalizer() end,
      color = function()
        return { fg = blend(colors.GREEN, colors.YELLOW, pulse) }
      end,
    })

    -- BOUNCING BAR
    table.insert(opts.sections.lualine_x, {
      function() return bouncing_bar() end,
      color = function()
        return { fg = blend(colors.ORANGE, colors.RED, breath) }
      end,
    })

    -- LSP STATUS (avec spinner)
    table.insert(opts.sections.lualine_x, {
      function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return " No LSP " end
        local spin = spinner4[(tick % #spinner4) + 1]
        return spin .. "  " .. clients[1].name .. " "
      end,
      color = function()
        return { fg = blend(colors.GREEN, colors.CYAN, pulse), gui = "bold" }
      end,
    })

    -- BRANCH ENERGY (avec rainbow)
    table.insert(opts.sections.lualine_x, {
      "branch",
      icon = " ",
      color = function()
        return { fg = rainbow_color(), gui = "bold" }
      end,
    })

    -- ROTATING SPINNER
    table.insert(opts.sections.lualine_x, {
      function()
        return spinner6[(tick % #spinner6) + 1]
      end,
      color = function()
        return { fg = blend(colors.VIOLET, colors.BLUE, breath), gui = "bold" }
      end,
    })

    -- PROGRESS (avec glow)
    table.insert(opts.sections.lualine_x, {
      "progress",
      color = function()
        return { fg = blend(colors.FG, rainbow_color(), pulse) }
      end,
    })
  end,
}
