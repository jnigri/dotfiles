return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
      },
    },
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },
  {
    "echasnovski/mini.files",
    version = false,
    keys = {
      {
        "<leader>e",
        function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          local path = buf_name ~= "" and vim.fn.fnamemodify(buf_name, ":p:h") or vim.uv.cwd()
          require("mini.files").open(path, true)
        end,
        desc = "Open File Explorer",
      },
    },
    opts = {
      options = {
        permanent_delete = false,
        use_as_default_explorer = true,
      },
      windows = {
        preview = true,
        width_focus = 35,
        width_nofocus = 20,
        width_preview = 50,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "<Esc>", function()
            require("mini.files").close()
          end, { buffer = buf_id, desc = "Close File Explorer" })
        end,
      })
    end,
  },
}
