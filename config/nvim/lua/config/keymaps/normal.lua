local ignored = "which_key_ignore"
local mappings = {
  -- Alternative Windows
  -- ["<Tab>"] = { "<cmd>wincmd p<cr>", "✭ go last accessed win" },
  -- Alternative buffer
  ["<leader>`"] = { "<C-^>", "✭ alternative buffer" },
  ["<leader>~"] = { "<cmd>split #<cr>", "✭ split alternative buffer" },
  -- Tab
  ["-"] = { "gT", "prev tab" },
  ["="] = { "gt", "next tab" },
  -- Redo
  ["U"] = { "<C-r>", ignored },
  -- Save file
  ["<C-s>"] = { "<cmd>up<cr>", "save", mode = { "i", "v", "n", "s" } },
  ["<leader>w"] = { "<cmd>up<cr>", "save" },
  ["<leader>W"] = { "<cmd>bufdo up<cr>", "save all" },
  -- Quit
  ["q"] = { "<cmd>close<cr>", ignored },
  ["<C-q>"] = { "<cmd>up<cr><cmd>qa<cr>", ignored },
  -- Delete Buffer
  ["<BS>"] = { "<cmd>Bdelete<cr>", "delete buffer" },
  ["<BS><BS>"] = { "<cmd>Bwipeout<cr>", "delete buffer forcely" },
  ["<C-BS>"] = { "<cmd>tabclose<cr>", "close tab" },
  -- https://www.reddit.com/r/neovim/comments/114z9ua/comment/j904vaa/
  ["<S-BS>"] = { function()
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
  -- Move to window using the <ctrl> hjkl keys
  ["<C-h>"] = { "<cmd>wincmd h<cr>", ignored },
  ["<C-j>"] = { "<cmd>wincmd j<cr>", ignored },
  ["<C-k>"] = { "<cmd>wincmd k<cr>", ignored },
  ["<C-l>"] = { "<cmd>wincmd l<cr>", ignored },
  -- Move window
  ["<C-S-h>"] = { "<cmd>wincmd H<cr>", ignored },
  ["<C-S-j>"] = { "<cmd>wincmd J<cr>", ignored },
  ["<C-S-k>"] = { "<cmd>wincmd K<cr>", ignored },
  ["<C-S-l>"] = { "<cmd>wincmd L<cr>", ignored },
  -- Resize window
  ["<C-M-k>"] = { "<cmd>resize +4<cr>", "increase window height" },
  ["<C-M-j>"] = { "<cmd>resize -4<cr>", "decrease window height" },
  ["<C-M-h>"] = { "<cmd>vertical resize -4<cr>", "decrease window width" },
  ["<C-M-l>"] = { "<cmd>vertical resize +4<cr>", "increase window width" },
  -- Maximize window
  -- ["<C-->"] = { function()
  --   local height = vim.api.nvim_win_get_height(0)
  --   local v = (height + 8 >= vim.o.lines) and "vertical " or ""
  --   vim.cmd(v .. "wincmd _")
  -- end, "max win height" },
  -- ["<C-\\>"] = { function()
  --   local width = vim.api.nvim_win_get_width(0)
  --   local h = (width + 8 >= vim.o.columns) and "horizontal " or ""
  --   vim.cmd(h .. "wincmd |")
  -- end, "max win width" },
  ["<C-=>"] = { function()
    if vim.g.full_window then
      vim.cmd [[wincmd =]]
    else
      vim.cmd [[wincmd _]]
      vim.cmd [[wincmd |]]
    end
    vim.g.full_window = not vim.g.full_window
  end, "toggle full window" },
  ["<F1>"] = { "<cmd>Telescope help_tags<cr>", "help" },
  -- Scroll
  ["<Up>"] = { "<C-y>k", ignored },
  ["<Down>"] = { "<C-e>j", ignored },
  ["<Left>"] = { "10zh", ignored },
  ["<Right>"] = { "10zl", ignored },
}

local opts = {}
for key, mapping in pairs(mappings) do
  local mode = mapping.mode or "n"
  local lhs = key
  local rhs = mapping[1]
  local desc = mapping[2]
  map(mode, lhs, rhs, desc, opts)
end
