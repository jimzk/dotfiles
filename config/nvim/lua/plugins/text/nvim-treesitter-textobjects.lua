local M = {
  -- Enhance text object to select/move/swap function and class
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "BufReadPost",
}

M.config = function()
  require("nvim-treesitter.configs").setup({
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "[TS] method" },
          ["if"] = { query = "@function.inner", desc = "[TS] method " },
          ["ao"] = { query = "@class.outer", desc = "[TS] class" },
          ["io"] = { query = "@class.inner", desc = "[TS] class" },
          -- mini.ai has already provided aa and ia
          -- ["aa"] = "@parameter.outer",
          -- ["ia"] = "@parameter.inner",
        },
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
        include_surrounding_whitespace = true,
      },
      swap = {
        enable = true,
        swap_next = {
          ["]e"] = { query = "@parameter.inner", desc = "[TS] exchange parameter with next" },
        },
        swap_previous = {
          ["[e"] = { "@parameter.inner", desc = "[TS] exchange parameter with prev" },
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "[TS] next method start" },
          ["]o"] = { query = "@class.outer", desc = "[TS] next class start" },
          ["]h"] = { query = "@conditional.outer", desc = "[TS] next condition start" },
        },
        goto_next_end = {
          ["]F"] = { query = "@function.outer", desc = "[TS] current or next method end" },
          ["]O"] = { query = "@class.outer", desc = "[TS] current or next class end" },
          ["]H"] = { query = "@conditional.outer", desc = "[TS] current or next condition end" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "[TS] current or prev method start" },
          ["[o"] = { query = "@class.outer", desc = "[TS] current or prev class start" },
          ["[h"] = { query = "@conditional.outer", desc = "[TS] current or prev condition start" },
        },
        goto_previous_end = {
          ["[F"] = { query = "@function.outer", desc = "[TS] prev method end" },
          ["[O"] = { query = "@class.outer", desc = "[TS] prev class end" },
          ["[H"] = { query = "@conditional.outer", desc = "[TS] prev condition end" },
        },
        -- goto_next = {
        --   ["]<C-f>"] = { query = "@function.outer", desc = "[TS] next method start or end" },
        --   ["]<C-c>"] = { query = "@class.outer", desc = "[TS] next class start or end" },
        --   ["]<C-d>"] = { query = "@conditional.outer", desc = "[TS] next condition start or start" },
        -- },
        -- goto_previous = {
        --   ["[<C-f>"] = { query = "@function.outer", desc = "[TS] prev method start or end" },
        --   ["[<C-c>"] = { query = "@class.outer", desc = "[TS] prev class start or end" },
        --   ["[<C-d>"] = { query = "@conditional.outer", desc = "[TS] prev condition start or start" },
        -- }
      },
      lsp_interop = {
        enable = false,
        border = "double",
        floating_preview_opts = {},
        peek_definition_code = {
          ["gF"] = { query = "@function.outer", desc = "[TS] peek outer function" },
          -- ["gJ"] = "@class.outer",
        },
      },
    },
  })
end

return M
