return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
    },
    init = function()
      vim.api.nvim_create_user_command("LazyGit", function()
        Snacks.lazygit()
      end, { desc = "Open Lazygit" })
    end,
  },
}
