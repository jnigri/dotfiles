-- Lualine theme for the asiimov colorscheme. lualine's "auto" theme picks
-- this up because it matches vim.g.colors_name, and re-reads it on
-- ColorScheme, so it follows light/dark too.
-- Flat look: colored mode block, everything else on the surface color.
local c = require("asiimov").colors()

local function mode(color)
  return {
    a = { fg = c.base, bg = color, gui = "bold" },
    b = { fg = c.text, bg = c.surface },
    c = { fg = c.muted, bg = c.surface },
  }
end

return {
  normal = mode(c.accent),
  insert = mode(c.success),
  visual = mode(c.link),
  replace = mode(c.error),
  command = mode(c.amber),
  terminal = mode(c.success),
  inactive = {
    a = { fg = c.muted, bg = c.surface },
    b = { fg = c.muted, bg = c.surface },
    c = { fg = c.muted, bg = c.surface },
  },
}
