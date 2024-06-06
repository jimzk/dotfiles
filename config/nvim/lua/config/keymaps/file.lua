local map = vim.keymap.set
local del = vim.keymap.del

map("n", "<leader>ho", function()
  local path = vim.fn.expand("%:p")
  vim.cmd("silent !open " .. path)
end, { desc = "Open File by Default APP" })
map("n", "<leader>hO", function()
  local path = vim.fn.getcwd()
  vim.cmd("silent !open " .. path)
end, { desc = "Open CWD by Finder" })
map("n", "<leader>hv", function()
  local path = vim.fn.expand("%:p")
  vim.cmd("silent !code " .. path)
end, { desc = "Open File by VSCode" })
map("n", "<leader>hV", function()
  local path = vim.fn.getcwd()
  vim.cmd("silent !code " .. path)
end, { desc = "Open CWD by VSCode" })
map("n", "<leader>hR", function()
  local path = vim.fn.getcwd()
  vim.cmd([[silent !open -na "RustRover.app" --args ]] .. path)
end, { desc = "Open Project by RustRover" })
map("n", "<leader>hc", function()
  local path = vim.fn.expand("%:p:h")
  vim.cmd("silent cd " .. path)
  vim.notify("cd to " .. path:gsub(vim.fn.getenv("HOME"), "~"))
end, { desc = "cd to File Directory" })
map("n", "<leader>hC", function()
  vim.cmd("Gcd")
  vim.notify("cd to Git repo root " .. vim.fn.getcwd():gsub(vim.fn.getenv("HOME"), "~"))
end, { desc = "cd to Repo Root" })
map("n", "<leader>hp", function()
  local file_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", file_path)
  vim.notify("File Path Copied", vim.log.levels.INFO)
end, { desc = "Copy File Path" })

map("n", "<leader>hr", function()
  vim.ui.input({
    prompt = "[G] Enter New File Name: ",
    default = vim.fn.expand("%:t"),
  }, function(input)
    if not input then
      return
    end
    vim.cmd("GRename " .. input)
  end)
end, { desc = "[G] Rename File" })

map("n", "<leader>hm", function()
  vim.ui.input({
    prompt = "[G] Move File to: ",
    default = "./" .. vim.fn.expand("%:."),
  }, function(input)
    if not input then
      return
    end
    vim.cmd("GMove " .. input)
  end)
end, { desc = "[G] Move File" })
map("n", "<leader>hd", function()
  vim.cmd("GDelete")
end, { desc = "[G] Delete File" })
map("n", "<leader>hD", function()
  vim.cmd("GDelete!")
end, { desc = "[G] Delete File Forcely" })
