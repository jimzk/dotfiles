-- local map = require("util").map

local M = {
  "romgrk/barbar.nvim",
  event = "BufReadPost",
  dependencies = {
    {
      "akinsho/bufferline.nvim",
      enabled = false,
    },
  },
}

M.init = function()
  vim.g.barbar_auto_setup = false
end

M.opts = {
  animation = true,
  exclude_ft = {},
  exclude_name = { "package.json", "lazy-lock.json" },
  hide = { extensions = true },
  highlight_alternate = true,
  highlight_inactive_file_icons = false,
  highlight_visible = true,
  icons = {
    buffer_index = true,
    button = false,
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true },
      [vim.diagnostic.severity.WARN] = { enabled = true },
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
  minimum_padding = 1,
  maximum_padding = 1,
  no_name_title = "[New File]",
}

M.config = function(_, opts)
  require("bufferline").setup(opts)
  local map = require("util").map
  -- override default mapping
  vim.defer_fn(function()
    -- Buffers
    map("n", "-", "<CMD>BufferPrevious<CR>", "Previous Buffer")
    map("n", "=", "<CMD>BufferNext<CR>", "Next Buffer")
    -- Move buffers
    map("n", "_", "<CMD>BufferMovePrevious<CR>", "Move Buffer to Previous")
    map("n", "+", "<CMD>BufferMoveNext<CR>", "Move Buffer to Next")
    -- Remove buffers
    map("n", "<C-w><BS>", "<CMD>BufferClose<CR><CMD>wincmd q<CR>", "Delete Buffer and Close Window")
    map("n", "<BS>", "<CMD>BufferClose<CR>", "Delete Buffer")
    map("n", "<C-b>dd", "<BS>", "Delete Buffer (<BS>)", { remap = true })
    map("n", "<C-b>do", "<CMD>BufferCloseAllButCurrentOrPinned<CR>", "Delete Other Buffers")
    map("n", "<S-BS>", "<CMD>BufferCloseAllButCurrentOrPinned<CR>", "Delete Other Buffers")
    map("n", "<C-b>dp", "<CMD>BufferPickDelete<CR>", "Delete Buffer by Pick")
    map("n", "<C-b>dl", "<CMD>BufferCloseBuffersLeft<CR>", "Delete Buffers Left")
    map("n", "<C-b>dr", "<CMD>BufferCloseBuffersRight<CR>", "Delete Buffers Right")

    -- Order
    map("n", "<C-b>on", "<CMD>BufferOrderByBufferNumber<CR>", "Order by Buffer Number")
    map("n", "<C-b>od", "<CMD>BufferOrderByDirectory<CR>", "Order by Directory")
    map("n", "<C-b>ol", "<CMD>BufferOrderByLanguage<CR>", "Order by Language")
    map("n", "<C-b>ow", "<CMD>BufferOrderByWindowNumber<CR>", "Order Window Number")

    -- Utilities
    map("n", "<C-b>r", "<CMD>BufferRestore<CR>", "Restore Buffer")
    map("n", "<C-b><Tab>", "<CMD>BufferPick<CR>", "Pick Buffer")
    -- Pin buffer
    -- map("n", "<M-p>", "<CMD>BufferPin<CR>", "Pin Buffer")
    -- map("n", "<C-b>p", "<M-p>", "Pin Buffer (<M-p>)", { remap = true })

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
    map("n", "<M-0>", "<CMD>BufferLast<CR>", "Go Last Buffer")

    vim.cmd([[hi BufferDefaultAlternate guifg=#a6d18a]])
  end, 0)
end

return M
