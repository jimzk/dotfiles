-- Better location/quickfix list
-- Override: https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L440
local M = {
  "folke/trouble.nvim",
}

M.keys = function()
  return {
    { "<leader>mQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix (Trouble)" },
    { "<leader>mq", "<cmd>copen<cr>", desc = "Quickfix" },
    { "<leader>mL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    { "<leader>ml", "<cmd>lopen<cr>", desc = "Location List" },

    { "<leader>m<Tab>", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },

    { "<leader>df", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "File Diagnostics (Trouble)" },
    { "<leader>dw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>dF", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "File Diagnostics (Telescope)" },
    { "<leader>dW", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics (Telescope)" },
  }
end

M.opts = {
  position = "bottom",
  height = 15,
  width = 50,
  padding = false,
  action_keys = {
    open_split = { "<c-s>" },
    open_vsplit = { "<c-v>" },
    open_tab = { "<c-t>" },
    hover = "K",
    previous = "<Up>",
    next = "<Down>",
  },
  -- Exclude declaration. See: https://www.reddit.com/r/neovim/comments/r4y1jt/comment/hmjmmb9
  include_declaration = { "lsp_implementations", "lsp_definitions" },
  indent_lines = false,
}

M.config = function(_, opts)
  local trouble = require("trouble")
  trouble.setup(opts)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "Trouble" },
    callback = function()
      local map_opts = { noremap = true, buffer = true, silent = true }
      local map = require("util").map
      -- stylua: ignore start
      map("n", "k", function() trouble.previous({ skip_groups = true, jump = false }) end, "Prev Item", map_opts)
      map("n", "j", function() trouble.next({ skip_groups = true, jump = false }) end, "Next Item", map_opts)
      -- map("n", "H", function() trouble.first({ skip_groups = true, jump = false }) end, "First item", map_opts)
      -- map("n", "L", function() trouble.last({ skip_groups = true, jump = false }) end, "Last item", map_opts)
      -- stylua: ignore end
    end,
  })
end

return M
