local map = Util.map
local del = vim.keymap.del

local toggle = function(option, ...)
  if LazyVim.toggle[option] then
    LazyVim.toggle[option](...)
  else
    LazyVim.toggle(option, ...)
  end
end

-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L112C18-L112C18
-- stylua: ignore start
del("n", "<leader>uI")
del("n", "<leader>ub")
del("n", "<leader>uf")
del("n", "<leader>uF")
vim.g.autoformat = true
map("n", "<leader>of", function() LazyVim.format.toggle(true) end,   "Toggle Autoformat (Buffer)" )
map("n", "<leader>oF", function() LazyVim.format.toggle() end,   "Toggle Autoformat (Global)" )
del("n", "<leader>us")
map("n", "<leader>os", function() toggle("spell") end, "Toggle Spelling" )
del("n", "<leader>uw")
map("n", "<leader>ow", function() toggle("wrap") end, "Toggle Word Wrap" )
del("n", "<leader>uL")
map("n", "<leader>or", function() toggle("relativenumber") end, "Toggle Relative Line Numbers" )
del("n", "<leader>ul")
map("n", "<leader>ol", function() toggle("cursorline") end, "Toggle Cursorline" )
map("n", "<leader>on", function() toggle("number") end, "Toggle Line Numbers" )
del("n", "<leader>ud")
map("n", "<leader>oD", function() toggle("diagnostics") end, "Toggle Diagnostics" )
map("n", "<leader>oc", function() toggle("ignorecase") end, "Toggle Case Ignore" )
del("n", "<leader>uc")
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>oC", function() toggle("conceallevel", false, {0, conceallevel}) end, "Toggle Conceal" )
del("n", "<leader>uh")
map("n", "<leader>oI", function()
  toggle("inlay_hints")
  vim.cmd("NvimContextVtToggle")
end, "Toggle Inlay Hints")
-- stylua: ignore end

del("n", "<leader>uT")
map("n", "<leader>oh", function()
  local is_enabled = vim.b.ts_highlight
  local toggle_fn = {
    vim.treesitter.start,
    vim.treesitter.stop,
  }
  Util.toggle(is_enabled, toggle_fn, "Treesitter Highlight")
end, "Toggle Treesitter Highlight")

map("n", "<leader>od", function()
  local is_enabled = vim.diagnostic.config().virtual_text
  local toggle_fn = function()
    vim.cmd("Corn toggle")
  end
  Util.toggle(is_enabled, toggle_fn, "Inline Diagnostics")
end, "Toggle Inline Diagnostics")

-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L135C1-L136C1
del("n", "<leader>ui")
map("n", "<leader>np", vim.show_pos, "Inspect Treesitter")

map("n", "<leader>om", function()
  local bo = vim.bo[0]
  local is_enabled = bo.modifiable
  local toggle_fn = function()
    -- bo.readonly = not bo.readonly
    bo.modifiable = not bo.modifiable
  end
  Util.toggle(is_enabled, toggle_fn, "File Modifiable")
end, "Toggle Modifiable")

map("n", "<leader>o<cr>", function()
  local opt = vim.wo
  local is_enabled = opt.scrolloff > 100
  local toggle_fn = function()
    opt.scrolloff = 999 - vim.o.scrolloff
    if not is_enabled then -- Now it is enabled
      local buf_star_line = 0
      local buf_end_line = vim.api.nvim_buf_line_count(0)
      local current_line = vim.fn.line(".")

      local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
      local shown_lines = win_info.botline - win_info.topline + 1
      local offset = shown_lines / 2

      if (current_line - buf_star_line > offset) and (buf_end_line - current_line > offset) then
        vim.cmd("normal! zz")
      end
    end
  end
  Util.toggle(is_enabled, toggle_fn, "Always Center")
end, "Toggle Always Center")

-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/config/keymaps.lua#L47
del("n", "<leader>ur")
map(
  "n",
  "<leader>o<esc>",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  "Redraw / Clear hlsearch / Diff Update"
)

-- stylua: ignore start
map("n", "<leader>o<Tab>", function()
  vim.ui.input({ prompt = "Enter Indent Width: " }, function(input)
    if not input then
      return
    end
    vim.bo.tabstop = tonumber(input)
    vim.bo.shiftwidth = tonumber(input)
    vim.notify("Set Indent Width to " .. input)
  end)
end,   "Set Indent Width" )
-- stylua: ignore end
map("n", "<leader>nt", function()
  local node = vim.treesitter.get_node():type()
  -- copy(node)
  vim.notify('Treesitter node under cursor is "' .. node .. '". Name copied.')
end, "Inspect Treesitter Ndoe under Cursor")

local file_detail = function()
  local home = vim.fn.getenv("HOME")
  -- local filename = vim.fn.expand("%:p:t")
  -- local repo_root = vim.fn.system("git rev-parse --show-toplevel")
  --     :gsub(home, "~")
  --     :gsub("\n", "")
  -- local filedir = vim.fn.expand("%:p:h")
  --     :gsub(home, "~")
  --     :gsub(repo_root, "")
  local relative_file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local msg = string.format(
    [[
Working Dir: %s
  File Path: %s
  File Type: %s
  Buffer Nr: %s
  Window Id: %s]],
    vim.fn.getcwd():gsub(home, "~"),
    "/" .. relative_file_path,
    vim.bo.filetype,
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_get_current_win()
  )
  require("notify")(msg, vim.log.levels.INFO, { title = "File Info", timeout = 3000 })
end
map("n", "<leader>ni", file_detail, "File Info")
map("n", "<leader>hi", file_detail, "File Info")

-- Lazy
del("n", "<leader>l")
map("n", "<leader>nz", "<cmd>Lazy<cr>", "Lazy")
map("n", "<leader>nZ", function()
  LazyVim.news.changelog()
end, "LazyVim Changelog")
