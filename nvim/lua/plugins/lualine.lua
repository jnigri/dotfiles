-- Flat statusline in the style of the asiimov preview:
--   NORMAL  main  +12 -3                          TypeScript  Ln 8, Col 21
local filetype_names = {
  typescript = "TypeScript",
  typescriptreact = "TypeScript React",
  javascript = "JavaScript",
  javascriptreact = "JavaScript React",
  json = "JSON",
  jsonc = "JSON",
  yaml = "YAML",
  toml = "TOML",
  html = "HTML",
  css = "CSS",
  sh = "Shell",
  zsh = "Zsh",
  lua = "Lua",
  python = "Python",
  markdown = "Markdown",
  dockerfile = "Dockerfile",
  tmux = "tmux",
}

local function filetype()
  local ft = vim.bo.filetype
  if ft == "" then
    return ""
  end
  return filetype_names[ft] or (ft:sub(1, 1):upper() .. ft:sub(2))
end

local function location()
  return string.format("Ln %d, Col %d", vim.fn.line("."), vim.fn.virtcol("."))
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local icons = LazyVim.config.icons

    opts.options.section_separators = { left = "", right = "" }
    opts.options.component_separators = { left = "", right = "" }

    opts.sections = {
      lualine_a = { { "mode", padding = 2 } },
      lualine_b = {
        { "branch", icon = "", padding = { left = 2, right = 1 } },
        {
          "diff",
          symbols = { added = "+", modified = "~", removed = "-" },
          padding = { left = 1, right = 1 },
          source = function()
            local gs = vim.b.gitsigns_status_dict
            if gs then
              return { added = gs.added, modified = gs.changed, removed = gs.removed }
            end
          end,
        },
      },
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
      },
      lualine_x = {
        -- macro recording ("recording @q") via noice
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },
        { filetype, padding = { left = 1, right = 2 } },
        { location, padding = { left = 0, right = 2 } },
      },
      lualine_y = {},
      lualine_z = {},
    }
  end,
}
