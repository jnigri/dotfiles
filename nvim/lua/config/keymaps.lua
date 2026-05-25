-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function git_root()
  local result = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result[1]
end

local function gitlab_base_url()
  local remote = vim.fn.system("git remote get-url origin 2>/dev/null"):gsub("\n", "")
  if remote == "" then
    return nil
  end
  remote = remote:gsub("^git@([^:]+):", "https://%1/")
  remote = remote:gsub("%.git$", "")
  return remote
end

-- <leader>yg: copy GitLab permalink for current line
vim.keymap.set("n", "<leader>yg", function()
  local root = git_root()
  if not root then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end
  local base = gitlab_base_url()
  if not base then
    vim.notify("No git remote found", vim.log.levels.ERROR)
    return
  end
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local filepath = vim.fn.expand("%:p"):sub(#root + 2)
  local line = vim.fn.line(".")
  local url = base .. "/-/blob/" .. branch .. "/" .. filepath .. "#L" .. line
  vim.fn.setreg("+", url)
  vim.notify("Copied: " .. url)
end, { desc = "Copy GitLab URL for current line" })

-- <leader>yr: copy project-relative path with line number
vim.keymap.set("n", "<leader>yr", function()
  local root = git_root()
  local filepath
  if root then
    filepath = vim.fn.expand("%:p"):sub(#root + 2)
  else
    filepath = vim.fn.expand("%:.")
  end
  local result = filepath .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", result)
  vim.notify("Copied: " .. result)
end, { desc = "Copy project-relative path with line" })

-- <leader>yf: copy full absolute path with line number
vim.keymap.set("n", "<leader>yf", function()
  local result = vim.fn.expand("%:p") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", result)
  vim.notify("Copied: " .. result)
end, { desc = "Copy full path with line" })
