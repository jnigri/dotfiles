-- Keep Neovim's native one-row message line (cmdheight=1) under the footer.
-- With noice's message UI on, Neovim forces cmdheight=0, the footer becomes
-- the last terminal row, and Ghostty stretches its colors into the window's
-- bottom padding (footer looks tall, text off-center).
-- noice still handles the command-line popup, LSP progress and hover docs.
return {
  "folke/noice.nvim",
  opts = {
    messages = { enabled = false },
    -- LSP progress popup: sit just above the footer, not on top of it
    -- (its default row assumes there's no message line).
    views = { mini = { position = { row = -2 } } },
  },
}
