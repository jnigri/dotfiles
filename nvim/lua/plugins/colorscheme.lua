return {
  -- Asiimov colorscheme lives in this config (colors/asiimov.lua + lua/asiimov/).
  -- Source palette: https://github.com/jnigri/asiimov-theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "asiimov",
    },
  },
  -- Follow macOS light/dark appearance while running: flips 'background',
  -- which reloads the asiimov colorscheme in the matching flavor.
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      update_interval = 3000,
      fallback = "dark",
    },
  },
}
