local ignored = "which_key_ignore"
local mappings = {
  -- Alternative Windows
  ["<Tab>"] = { "<cmd>wincmd p<cr>", "✭ go last accessed win" },
  -- Alternative buffer
  ["<leader>`"] = { "<C-^>", "✭ alternative buffer" },
  ["<leader>~"] = { "<cmd>split #<cr>", "✭ split alternative buffer" },
  -- Tab
  ["-"] = { "<cmd>tabprev<cr>", "prev tab" },
  ["="] = { "<cmd>tabnext<cr>", "next tab" },
  -- Redo
  ["U"] = { "<C-r>", ignored },

  -- Save file
  ["<C-s>"] = { "<cmd>up<cr>", "save", mode = { "i", "v", "n", "s" } },
  ["<C-S-s>"] = { "<cmd>bufdo up<cr>", "save all", mode = { "i", "v", "n", "s" } },
  ["<leader>w"] = { "<cmd>up<cr>", "save" },
  ["<leader>W"] = { "<cmd>bufdo up<cr>", "save all" },

  -- Quit
  ["q"] = { "<cmd>close<cr>", ignored },
  ["<C-q>"] = { "<cmd>up<cr><cmd>qa<cr>", ignored },
  -- Delete Buffer
  ["<BS>"] = { "<cmd>Bwipeout<cr>", "delete buffer" },
  ["<BS><BS>"] = { "<cmd>Bwipeout!<cr>", "delete buffer forcely" },
  ["<S-BS>"] = { "<cmd>bufdo Bwipeout<cr>", "delete all buffer" },

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

  -- Resize window using <ctrl> arrow keys
  ["<C-Up>"] = { "<cmd>resize +2<cr>", "increase window height" },
  ["<C-Down>"] = { "<cmd>resize -2<cr>", "decrease window height" },
  ["<C-Left>"] = { "<cmd>vertical resize -2<cr>", "decrease window width" },
  ["<C-Right>"] = { "<cmd>vertical resize +2<cr>", "increase window width" },

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
      -- vim.notify("Exit full screen", vim.log.levels.INFO, { title = "Window" })
    else
      vim.cmd [[wincmd _]]
      vim.cmd [[wincmd |]]
      -- vim.notify("Enter full screen", vim.log.levels.INFO, { title = "Window" })
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
