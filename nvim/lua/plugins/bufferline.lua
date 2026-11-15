-- Buffer tabs: a lighter sibling of the tmux tab bar, so the two stack well
-- inside tmux and still look finished on their own:
--   no bar background, muted names, active buffer bright + orange underline,
--   and an empty winbar under the tabs (see config/options.lua) for breathing room.
-- The underline color comes from TabLineSel's bg (set by the asiimov colorscheme).
return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    local bufferline = require("bufferline")
    opts.options = vim.tbl_extend("force", opts.options or {}, {
      style_preset = { bufferline.style_preset.minimal, bufferline.style_preset.no_italic },
      indicator = { style = "underline" },
      separator_style = { "", "" },
      show_close_icon = false,
    })
  end,
}
