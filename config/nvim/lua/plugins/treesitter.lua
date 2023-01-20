local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
}

local incremental_selection_key = "+"
local decremental_selection_key = "_"
M.opts = {
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = false,
      node_incremental = incremental_selection_key,
      node_decremental = decremental_selection_key,
      scope_incremental = false, -- '<TAB>'
    },
  },
}

M.config = function(_, opts)
  require("nvim-treesitter.configs").setup(opts)
  -- map init_selection by manual for position mark
  map("n", incremental_selection_key, function()
    vim.cmd([[normal! mv]]) -- init range selection
    require("nvim-treesitter.incremental_selection").init_selection()
  end, "incremental selection")
end

return M
