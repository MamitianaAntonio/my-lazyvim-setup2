return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local colors = {
      -- Base colors
      BG = "#0a0e14",
      BG_LIGHT = "#151a21",
      FG = "#e6e6e6",
      FG_DIM = "#7a8185",

      -- Accent colors (more refined)
      BLUE = "#61afef",
      VIOLET = "#c678dd",
      RED = "#e06c75",
      GREEN = "#98c379",
      YELLOW = "#e5c07b",
      CYAN = "#56b6c2",
      ORANGE = "#d19a66",
      MAGENTA = "#c678dd",
      PINK = "#ff79c6",

      -- Special effects
      NEON_BLUE = "#00d4ff",
      NEON_PINK = "#ff006e",
      NEON_GREEN = "#00ff88",
      GOLD = "#ffd700",
    }

    -- =============================
    -- ENHANCED ANIMATION ENGINE =============================
    local anim = {
      tick = 0,
      pulse = 0,
      pulse_direction = 1,
      breath = 0,
      rainbow_offset = 0,
      wave_phase = 0,
      glow_intensity = 0,
      scroll_offset = 0,
    }

    -- Smoother refresh rate
    vim.fn.timer_start(40, function()
      anim.tick = anim.tick + 1

      -- Smooth pulse (0 to 1)
      anim.pulse = anim.pulse + (0.035 * anim.pulse_direction)
      if anim.pulse >= 1 then anim.pulse_direction = -1 end
      if anim.pulse <= 0 then anim.pulse_direction = 1 end

      -- Breathing effect (smoother)
      anim.breath = (math.sin(anim.tick / 40) + 1) / 2

      -- Rainbow cycle
      anim.rainbow_offset = (anim.rainbow_offset + 0.015) % 1

      -- Wave phase
      anim.wave_phase = (anim.wave_phase + 0.08) % (math.pi * 2)

      -- Glow intensity (for premium effects)
      anim.glow_intensity = (math.sin(anim.tick / 25) + 1) / 2

      -- Scroll effect
      anim.scroll_offset = (anim.scroll_offset + 0.1) % 100

      require("lualine").refresh()
    end, { ["repeat"] = -1 })

    -- =============================
    -- PREMIUM COLOR UTILITIES
    -- =============================
    local function hex_to_rgb(hex)
      return tonumber(hex:sub(2, 3), 16),
          tonumber(hex:sub(4, 5), 16),
          tonumber(hex:sub(6, 7), 16)
    end

    local function rgb_to_hex(r, g, b)
      return string.format("#%02X%02X%02X",
        math.min(255, math.max(0, math.floor(r))),
        math.min(255, math.max(0, math.floor(g))),
        math.min(255, math.max(0, math.floor(b)))
      )
    end

    -- Smooth color blending
    local function blend(c1, c2, t)
      local r1, g1, b1 = hex_to_rgb(c1)
      local r2, g2, b2 = hex_to_rgb(c2)

      local function lerp(a, b, t) return a + (b - a) * t end

      return rgb_to_hex(
        lerp(r1, r2, t),
        lerp(g1, g2, t),
        lerp(b1, b2, t)
      )
    end

    -- Add glow effect to color
    local function glow(base_color, intensity)
      local r, g, b = hex_to_rgb(base_color)
      local boost = 1 + (intensity * 0.3)
      return rgb_to_hex(
        math.min(255, r * boost),
        math.min(255, g * boost),
        math.min(255, b * boost)
      )
    end

    -- =============================
    -- MODE DETECTION
    -- =============================
    local function get_mode_info()
      local mode = vim.fn.mode()
      local modes = {
        n = { name = "NORMAL", color = colors.BLUE, icon = "󰋜" },
        i = { name = "INSERT", color = colors.GREEN, icon = "󰏫" },
        v = { name = "VISUAL", color = colors.VIOLET, icon = "󰈈" },
        V = { name = "V-LINE", color = colors.VIOLET, icon = "󰈈" },
        ["\22"] = { name = "V-BLOCK", color = colors.VIOLET, icon = "󰈈" },
        c = { name = "COMMAND", color = colors.YELLOW, icon = "" },
        R = { name = "REPLACE", color = colors.RED, icon = "󰛔" },
        t = { name = "TERMINAL", color = colors.CYAN, icon = "" },
      }
      return modes[mode] or { name = "UNKNOWN", color = colors.FG, icon = "" }
    end

    -- =============================
    -- RAINBOW SYSTEM
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
        colors.PINK,
      }
      local idx = math.floor(anim.rainbow_offset * #rainbow) + 1
      return rainbow[idx]
    end

    -- =============================
    -- PREMIUM SPINNERS
    -- =============================
    local spinners = {
      dots = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
      arc = { "◜", "◠", "◝", "◞", "◡", "◟" },
      circle = { "◐", "◓", "◑", "◒" },
      dots_pulse = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
      line = { "⎯", "⎼", "⎺", "⎻" },
    }

    local function get_spinner(type, speed)
      speed = speed or 1
      local spinner = spinners[type] or spinners.dots
      local idx = math.floor(anim.tick * speed) % #spinner + 1
      return spinner[idx]
    end

    -- =============================
    -- PREMIUM VISUAL EFFECTS
    -- =============================

    -- Smooth wave indicator
    local function wave_indicator()
      local blocks = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
      local wave = ""
      for i = 1, 6 do
        local v = math.sin(anim.wave_phase + i * 0.6)
        local idx = math.floor((v + 1) / 2 * (#blocks - 1)) + 1
        wave = wave .. blocks[idx]
      end
      return wave
    end

    -- Premium energy bar with gradient effect
    local function energy_bar()
      local width = 8
      local pos = (anim.tick * 0.8) % width
      local bar = ""

      for i = 0, width - 1 do
        local dist = math.abs(i - pos)
        if dist < 0.5 then
          bar = bar .. "█"
        elseif dist < 1.5 then
          bar = bar .. "▓"
        elseif dist < 2.5 then
          bar = bar .. "▒"
        else
          bar = bar .. "░"
        end
      end
      return bar
    end

    -- Spectrum analyzer effect
    local function spectrum()
      local bars = ""
      for i = 1, 5 do
        local height = math.floor((math.sin(anim.tick / 12 + i * 0.8) + 1) * 4)
        local chars = { "▁", "▂", "▃", "▅", "▇" }
        bars = bars .. chars[math.min(height + 1, #chars)]
      end
      return bars
    end

    -- Pulsing dot indicator
    local function pulse_dot()
      local intensity = anim.pulse
      if intensity > 0.8 then
        return "●"
      elseif intensity > 0.5 then
        return "◉"
      elseif intensity > 0.2 then
        return "○"
      else
        return "◌"
      end
    end

    -- Breathing separator
    local function breathing_separator()
      local chars = { "·", "•", "●" }
      local idx = math.floor(anim.breath * (#chars - 1)) + 1
      return chars[idx]
    end

    -- =============================
    -- COMPONENT BUILDERS
    -- =============================

    -- Premium mode indicator
    local function mode_component()
      return {
        function()
          local mode_info = get_mode_info()
          return " " .. mode_info.icon .. " " .. mode_info.name .. " "
        end,
        color = function()
          local mode_info = get_mode_info()
          local base = mode_info.color
          local glowing = glow(base, anim.glow_intensity)
          return {
            fg = colors.BG,
            bg = blend(base, glowing, anim.breath),
            gui = "bold"
          }
        end,
        separator = { right = "" },
      }
    end

    -- Premium filename with icon
    local function filename_component()
      return {
        function()
          local filename = vim.fn.expand("%:t")
          if filename == "" then filename = "[No Name]" end

          -- Get file icon (requires nvim-web-devicons)
          local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
          local icon = ""
          if devicons_ok then
            icon = devicons.get_icon(filename, vim.fn.expand("%:e"), { default = true })
          end

          return icon .. " " .. filename
        end,
        color = function()
          local mode_info = get_mode_info()
          return {
            fg = blend(colors.FG, mode_info.color, anim.pulse * 0.4),
            gui = "bold"
          }
        end,
      }
    end

    -- Git status with smooth animations
    local function git_component()
      return {
        function()
          local g = vim.b.gitsigns_status_dict
          if not g then return "" end

          local added = g.added or 0
          local changed = g.changed or 0
          local removed = g.removed or 0
          local total = added + changed + removed

          if total == 0 then return "" end

          local spinner = get_spinner("circle", 0.5)
          return string.format(
            "%s  +%d ~%d -%d",
            spinner,
            added,
            changed,
            removed
          )
        end,
        color = function()
          return {
            fg = blend(colors.GREEN, colors.YELLOW, anim.pulse),
            gui = "bold"
          }
        end,
      }
    end

    -- LSP status with premium styling
    local function lsp_component()
      return {
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            return "󰌚 No LSP"
          end

          local spinner = get_spinner("dots_pulse", 0.3)
          local client_names = {}
          for _, client in ipairs(clients) do
            table.insert(client_names, client.name)
          end

          return spinner .. " 󰒋 " .. table.concat(client_names, ", ")
        end,
        color = function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local base_color = #clients > 0 and colors.NEON_GREEN or colors.FG_DIM
          return {
            fg = glow(base_color, anim.glow_intensity * 0.5),
            gui = "bold"
          }
        end,
      }
    end

    -- Branch with rainbow effect
    local function branch_component()
      return {
        function()
          local branch = vim.b.gitsigns_head or vim.fn.FugitiveHead()
          if not branch or branch == "" then return "" end
          return "  " .. branch
        end,
        color = function()
          return {
            fg = glow(rainbow_color(), anim.glow_intensity * 0.3),
            gui = "bold"
          }
        end,
      }
    end

    -- File encoding with conditional display
    local function encoding_component()
      return {
        function()
          local encoding = vim.opt.fileencoding:get()
          if encoding == "utf-8" then return "" end
          return "󰉿 " .. encoding:upper()
        end,
        color = { fg = colors.FG_DIM },
      }
    end

    -- Progress with visual indicator
    local function progress_component()
      return {
        function()
          local cur = vim.fn.line(".")
          local total = vim.fn.line("$")
          local percentage = math.floor(cur / total * 100)

          return string.format("󰓾 %d%%%%", percentage)
        end,
        color = function()
          return {
            fg = blend(colors.FG, rainbow_color(), anim.pulse * 0.3),
            gui = "bold"
          }
        end,
      }
    end

    -- Location (line:col)
    local function location_component()
      return {
        function()
          return "󰆤 %l:%c"
        end,
        color = function()
          local mode_info = get_mode_info()
          return {
            fg = blend(colors.FG_DIM, mode_info.color, anim.breath * 0.3)
          }
        end,
      }
    end

    -- =============================
    -- DECORATIVE COMPONENTS
    -- =============================

    local function separator_wave()
      return {
        function() return wave_indicator() end,
        color = function()
          return {
            fg = blend(colors.BLUE, colors.CYAN, anim.breath),
          }
        end,
      }
    end

    local function separator_energy()
      return {
        function() return energy_bar() end,
        color = function()
          return {
            fg = blend(colors.NEON_GREEN, colors.NEON_BLUE, anim.pulse),
          }
        end,
      }
    end

    local function separator_spectrum()
      return {
        function() return spectrum() end,
        color = function()
          return {
            fg = blend(colors.VIOLET, colors.PINK, anim.pulse),
          }
        end,
      }
    end

    local function separator_pulse()
      return {
        function()
          return pulse_dot() .. breathing_separator() .. pulse_dot()
        end,
        color = function()
          local mode_info = get_mode_info()
          return {
            fg = blend(mode_info.color, colors.FG_DIM, anim.pulse),
          }
        end,
      }
    end

    -- =============================
    -- CONFIGURATION
    -- =============================

    opts.options = {
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      globalstatus = true,
      refresh = {
        statusline = 40,
      },
    }

    -- Clear default sections
    opts.sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    -- =============================
    -- LEFT SIDE (Primary info)
    -- =============================

    table.insert(opts.sections.lualine_a, mode_component())
    table.insert(opts.sections.lualine_b, separator_wave())
    table.insert(opts.sections.lualine_b, filename_component())
    table.insert(opts.sections.lualine_b, separator_pulse())
    table.insert(opts.sections.lualine_c, git_component())

    -- =============================
    -- RIGHT SIDE (Status info)
    -- =============================

    table.insert(opts.sections.lualine_x, lsp_component())
    table.insert(opts.sections.lualine_x, separator_energy())
    table.insert(opts.sections.lualine_y, branch_component())
    table.insert(opts.sections.lualine_y, separator_spectrum())
    table.insert(opts.sections.lualine_y, encoding_component())
    table.insert(opts.sections.lualine_z, location_component())
    table.insert(opts.sections.lualine_z, progress_component())

    return opts
  end,
}
