local toggle = function(opt)
  local f = function()
    local opts = vim.o
    if opts[opt] then
      opts[opt] = false
      Notify("Disable " .. opt)
    else
      opts[opt] = true
      Notify("Enable " .. opt)
    end
  end
  return { f, "toggle " .. opt }
end

require("which-key").register({
  name = "options",
  n = toggle("number"),
  r = toggle("relativenumber"),
  w = toggle("wrap"),
  c = toggle("ignorecase"),
  h = toggle("hlsearch"),
  i = toggle("incsearch"),
  s = toggle("spell"),
  p = { function()
    local path = vim.fn.stdpath("data") .. "/telescope-projects.txt"
    vim.cmd("!rm " .. path)
    Notify("Clean telescope-projects cache")
  end, "Clean telescope.project cache" },
  m = { "<cmd>MarksToggleSigns<cr>", "toggle marks sign" },
  M = { "<cmd>DeleteSession<cr>", "delete session"},
}, { prefix = "<leader>o" })
