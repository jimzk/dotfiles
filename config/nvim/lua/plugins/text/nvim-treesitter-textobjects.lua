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
        ["]m"] = { query = "@function.outer", desc = "Next Function Start" },
        ["]c"] = { query = "@class.outer", desc = "Next Class Start" },
      },
      goto_next_end = {
        ["]M"] = { query = "@function.outer", desc = "Next Function End" },
        ["]C"] = { query = "@class.outer", desc = "Next Class End" },
      },
      goto_previous_start = {
        ["[m"] = { query = "@function.outer", desc = "Prev Function Start" },
        ["[c"] = { query = "@class.outer", desc = "Prev class Start" },
      },
      goto_previous_end = {
        ["[M"] = { query = "@function.outer", desc = "Prev Function End" },
        ["[C"] = { query = "@class.outer", desc = "Prev Class End" },
      },
      goto_next = {
        ["]o"] = { "@conditional.outer", desc = "Condition" },
      },
      goto_previous = {
        ["[o"] = { "@conditional.outer", desc = "Condition" },
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
  local map = Util.map
  -- Repeat movement with ; and ,
  -- ensure ; goes forward and , goes backward regardless of the last direction
  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

  -- map("n", "<C-ScrollWheelDown>", ']]"yy$', "Next Function", { remap = true })
  -- map("n", "<C-ScrollWheelUp>", '[["yy$', "Prev Function", { remap = true })
end

return M
