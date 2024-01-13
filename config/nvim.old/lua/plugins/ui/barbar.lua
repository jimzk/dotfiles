M = {
  "romgrk/barbar.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lualine/lualine.nvim" },
}

M.opts = {
  animation = false,
  exclude_ft = {},
  exclude_name = { "package.json", "lazy-lock.json" },
  hide = { extensions = true }, -- hide invisible buffer, more clean!
  highlight_alternate = true,
  highlight_inactive_file_icons = true,
  highlight_visible = true,
  icons = {
    buffer_index = true,
    button = false,
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
      [vim.diagnostic.severity.WARN] = { enabled = false },
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = false },
    },
    pinned = { button = "", filename = true },
    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
    alternate = { filetype = { enabled = true } },
    current = { buffer_index = true },
    inactive = { button = false },
    visible = { modified = { buffer_number = false } },
  },
  maximum_padding = 1,
  minimum_padding = 1,
  maximum_length = 30,
  minimum_length = 0,
}

M.config = function(_, opts)
  require("bufferline").setup(opts)
  -- override default mapping
  vim.defer_fn(function()
    -- Buffers
    map("n", "-", "<CMD>BufferPrevious<CR>", "previous buffer")
    map("n", "=", "<CMD>BufferNext<CR>", "next buffer")
    -- map("n", "_", "<CMD>vs<CR><CMD>BufferPrevious<CR>", "split previous buffer")
    -- map("n", "+", "<CMD>vs<CR><CMD>BufferNext<CR>", "split next buffer")
    -- Move buffers
    map("n", "_", "<CMD>BufferMovePrevious<CR>", "move buffer to previous")
    map("n", "+", "<CMD>BufferMoveNext<CR>", "move buffer to next")
    -- Remove buffers
    map("n", "<BS>", "<CMD>BufferClose<CR>", "delete buffer")
    map("n", "<S-BS>", "<CMD>BufferCloseAllButVisible<CR>", "delete all buffer")
    -- Restore buffer
    map("n", "<M-S-t>", "<CMD>BufferRestore<CR>", "restore buffer")
    -- Pin buffer
    map("n", "<M-p>", "<CMD>BufferPin<CR>", "pin buffer")
    -- Go to buffer
    map("n", "<M-1>", "<CMD>BufferGoto 1<CR>")
    map("n", "<M-2>", "<CMD>BufferGoto 2<CR>")
    map("n", "<M-3>", "<CMD>BufferGoto 3<CR>")
    map("n", "<M-4>", "<CMD>BufferGoto 4<CR>")
    map("n", "<M-5>", "<CMD>BufferGoto 5<CR>")
    map("n", "<M-6>", "<CMD>BufferGoto 6<CR>")
    map("n", "<M-7>", "<CMD>BufferGoto 7<CR>")
    map("n", "<M-8>", "<CMD>BufferGoto 8<CR>")
    map("n", "<M-9>", "<CMD>BufferGoto 9<CR>")
    map("n", "<M-0>", "<CMD>BufferLast<CR>", "go to last buffer")
  end, 0)

  -- local set_hl = function(status, styles)
  --   -- NOTE: icon highlight will be overriten by web-devicons
  --   local parts = { "", "Icon", "Sign", "Index", "Target", "Mod", "ERROR", "INFO", "WARN", "HINT", "ADDED", "CHANGED",
  --     "DELETED" }
  --   for _, value in pairs(parts) do
  --     local hl = "Buffer" .. status .. value
  --     vim.cmd([[hi! ]] .. hl .. " " .. styles)
  --   end
  -- end
  -- set_hl("DefaultVisible", "guibg=#303446")
  -- set_hl("DefaultCurrent", "gui=bold guibg=#51576d")
  -- vim.cmd [[hi BufferDefaultVisibleADDED guifg=#a6d189]]
  -- vim.cmd [[hi BufferDefaultVisibleDELETED guifg=#e78284]]
  -- vim.cmd [[hi BufferDefaultVisibleIndex guifg=#f4b8e4]]
  -- local fg_color = "#c2c2c2"
  -- vim.cmd("hi BufferDefaultCurrent guifg=" .. fg_color)
  -- vim.cmd("hi BufferDefaultVisible guifg=" .. fg_color)
  -- vim.cmd("hi BufferDefaultCurrentMod guifg=" .. fg_color) -- Highlight for modified buffers
  vim.cmd [[hi BufferDefaultTabpageFill guibg=none]]
end

-- -- https://github.com/romgrk/barbar.nvim#integration-with-filetree-plugins
-- local nvim_tree_events = require("nvim-tree.events")
-- local bufferline_api = require("bufferline.api")

-- local function get_tree_size()
--   return require "nvim-tree.view".View.width
-- end

-- nvim_tree_events.subscribe("TreeOpen", function()
--   bufferline_api.set_offset(get_tree_size())
-- end)

-- nvim_tree_events.subscribe("Resize", function()
--   bufferline_api.set_offset(get_tree_size())
-- end)

-- nvim_tree_events.subscribe("TreeClose", function()
--   bufferline_api.set_offset(0)
-- end)
return M
