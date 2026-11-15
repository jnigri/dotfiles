return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    -- no snippets in popup
    opts.sources.default = { "lsp", "path", "buffer" }
    -- no grey ghost text
    opts.completion.ghost_text.enabled = false
    -- popup only on demand (<C-space>), not while typing
    opts.completion.menu.auto_show = false
    -- <C-space> never reaches nvim here; use <C-j> to open/close the popup
    opts.keymap["<C-j>"] = { "show", "hide" }
    -- no side doc box (still on demand with <C-space>)
    opts.completion.documentation.auto_show = false
  end,
}
