-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/treesitter.lua#L89
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/treesitter.lua#L21
local M = {
  -- Enhance text object to select/move/swap function and class
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "BufReadPost",
}

M.opts = {
  textobjects = {
    select = {
      -- I configure them in mini.ai
      enable = false,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      -- keymaps = {
      --   ["af"] = { query = "@function.outer", desc = "Method" },
      --   ["if"] = { query = "@function.inner", desc = "Method " },
      --   ["ac"] = { query = "@class.outer", desc = "Class" },
      --   ["ic"] = { query = "@class.inner", desc = "Class" },
      --   ["aa"] = "@parameter.outer",
      --   ["ia"] = "@parameter.inner",
      -- },
    },
    swap = {
      enable = true,
      swap_next = {
        ["]e"] = { query = "@parameter.inner", desc = "Swap Parameter" },
      },
      swap_previous = {
        ["[e"] = { query = "@parameter.inner", desc = "Swap Parameter" },
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]]"] = { query = "@function.outer", desc = "Next Method Start" },
        ["]x"] = { query = "@class.outer", desc = "Next Class Start" },
      },
      goto_next_end = {
        ["]["] = { query = "@function.outer", desc = "Next Method End" },
        ["]X"] = { query = "@class.outer", desc = "Next Class End" },
      },
      goto_previous_start = {
        ["[["] = { query = "@function.outer", desc = "Prev Method Start" },
        ["[x"] = { query = "@class.outer", desc = "Prev class Start" },
      },
      goto_previous_end = {
        ["[]"] = { query = "@function.outer", desc = "Prev Method End" },
        ["[X"] = { query = "@class.outer", desc = "Prev Class End" },
      },
      goto_next = {
        ["]O"] = { "@conditional.outer", desc = "Condition" },
      },
      goto_previous = {
        ["[O"] = { "@conditional.outer", desc = "Condition" },
      },
    },
    lsp_interop = {
      enable = false,
      border = "double",
      floating_preview_opts = {},
      peek_definition_code = {
        -- ["gf"] = { query = "@function.outer", desc = "Peek Definition" },
        -- ["g<C-d>"] = { query = "@class.outer", desc = "Peek Type Definition" },
      },
    },
  },
}

M.config = function(_, opts)
  require("nvim-treesitter.configs").setup(opts)
  -- Repeat movement with ; and ,
  -- ensure ; goes forward and , goes backward regardless of the last direction
  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
end

return M
