local ignored = "which_key_ignore"
local mappings = {
  -- Alternative Windows
  -- ["<Tab>"] = { "<cmd>wincmd p<cr>", "✭ go last accessed win" },
  -- Alternative buffer
  ["<Tab>"] = { "<C-^>", "✭ alternative buffer" },
  ["<S-Tab>"] = { "<cmd>vs #<cr>", "✭ split alternative buffer" },
  -- Buffers
  -- ["-"] = { "<cmd>bp<cr>", "prev buffer" },
  -- ["="] = { "<cmd>bn<cr>", "next buffer" },
  -- ["_"] = { "<cmd>vertical sbp<cr>", "prev buffer and split" },
  -- ["+"] = { "<cmd>vertical sbn<cr>", "next buffer and split" },
  -- Tabs
  ["<C-->"] = { "gT", "prev tab" },
  ["<C-=>"] = { "gt", "next tab" },
  -- Redo
  ["U"] = { "<C-r>", ignored },
  -- Save file
  ["<leader>w"] = { "<cmd>up<cr>", "save" },
  ["<leader>W"] = { "<cmd>bufdo up<cr>", "save all" },
  -- Quit
  ["q"] = { "<cmd>close<cr>", ignored },
  ["<C-q>"] = { "<cmd>up<cr><cmd>qa<cr>", ignored },
  -- Delete Buffer
  ["<C-BS>"] = { "<cmd>tabclose<cr>", "close tab" },
  ["<M-BS>"] = { "<cmd>Bdelete<cr>", "delete buffer" },
  -- ["<leader><A-BS>"] = { "<cmd>Bwipeout<cr>", "delete buffer forcely" },
  -- https://www.reddit.com/r/neovim/comments/114z9ua/comment/j904vaa/
  ["<M-S-BS>"] = { function()
    local api = vim.api
    local active_buffers = {}
    for _, win in ipairs(api.nvim_list_wins()) do
      active_buffers[api.nvim_win_get_buf(win)] = true
    end
    local count = 0
    local buffers = api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
      local bo = vim.bo[buf]
      if active_buffers[buf] ~= true
          and bo.buflisted
          and bo.modified ~= true
      then
        api.nvim_buf_delete(buf, {})
        count = count + 1
      end
    end
    vim.notify(string.format("%d unmodified hidden buffers deleted", count))
  end, "delete unmodified hidden buffers" },
  -- Replace by smart-splits
  -- Move to window using the <ctrl> hjkl keys
  -- ["<C-h>"] = { "<cmd>wincmd h<cr>", ignored },
  -- ["<C-j>"] = { "<cmd>wincmd j<cr>", ignored },
  -- ["<C-k>"] = { "<cmd>wincmd k<cr>", ignored },
  -- ["<C-l>"] = { "<cmd>wincmd l<cr>", ignored },
  -- Move window
  -- ["<C-M-left>"] = { "<cmd>wincmd H<cr>", ignored },
  -- ["<C-M-down>"] = { "<cmd>wincmd J<cr>", ignored },
  -- ["<C-M-up>"] = { "<cmd>wincmd K<cr>", ignored },
  -- ["<C-M-right>"] = { "<cmd>wincmd L<cr>", ignored },
  -- Resize window
  -- ["<C-M-k>"] = { "<cmd>resize +4<cr>", "increase window height" },
  -- ["<C-M-j>"] = { "<cmd>resize -4<cr>", "decrease window height" },
  -- ["<C-M-h>"] = { "<cmd>vertical resize -4<cr>", "decrease window width" },
  -- ["<C-M-l>"] = { "<cmd>vertical resize +4<cr>", "increase window width" },
  ["<C-M-=>"] = { "<cmd>wincmd =<cr>", "equal window size" },
  -- ["<leader>-"] = { "<cmd>wincmd |<cr>", "max out height" },
  ["<C-M-\\>"] = { function()
    if vim.g.full_window then
      vim.cmd [[wincmd =]]
    else
      vim.cmd [[wincmd _]]
      vim.cmd [[wincmd |]]
    end
    vim.g.full_window = not vim.g.full_window
  end, "toggle full window" },
  -- Scroll
  ["<Up>"] = { "<C-y>k", ignored },
  ["<Down>"] = { "<C-e>j", ignored },
  -- ["<Left>"] = { "10zh", ignored },
  -- ["<Right>"] = { "10zl", ignored },
}

local opts = {}
for key, mapping in pairs(mappings) do
  local mode = mapping.mode or "n"
  local lhs = key
  local rhs = mapping[1]
  local desc = mapping[2]
  map(mode, lhs, rhs, desc, opts)
end

-- Press key twice to jump fist blank char of link
-- https://luyuhuang.tech/2023/03/21/nvim.html#跳转到行开头
local function home()
  local head = (vim.api.nvim_get_current_line():find("[^%s]") or 1) - 1
  local cursor = vim.api.nvim_win_get_cursor(0)
  cursor[2] = cursor[2] == head and 0 or head
  vim.api.nvim_win_set_cursor(0, cursor)
end
-- map({ "n", "x", "o" }, "H", "v:count == 0 ? 'g^' : '^'", nil, { expr = true })
-- map({ "n", "x", "o" }, "L", "v:count == 0 ? 'g$' : ':lua home()'", nil, { expr = true })
map({ "n", "i" }, "<Home>", home)
map({ "n", "x", "o" }, "H", home)
map({ "n", "x", "o" }, "0", home)
map({ "n", "x", "o" }, "L", "$")
map({ "n", "x", "o" }, "gH", "g^")
map({ "n", "x", "o" }, "gL", "g$")
map({ "n", "x", "o" }, "$", "L", "H")
map({ "n", "x", "o" }, "^", "H", "L")
-- map({ "n", "x", "o" }, "<M-S-L>", "L", "L (bottom)")
-- map({ "n", "x", "o" }, "<M-S-H>", "H", "H (top)")

-- Reverse ` and "
map({ "n", "x", "o" }, "'")
map({ "n", "x", "o" }, "`")
