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
          ["aC"] = { query = "@class.outer", desc = "[TS] class" },
          ["iC"] = { query = "@class.inner", desc = "[TS] class" },
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
          ["]e"] = { query = "@parameter.inner", desc = "exchange with next parameter" },
        },
        swap_previous = {
          ["[e"] = { "@parameter.inner", desc = "exchange with prev parameter" },
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]]"] = { query = "@function.outer", desc = "[TS] next method start" },
          ["]c"] = { query = "@class.outer", desc = "[TS] next class start" },
        },
        goto_next_end = {
          ["]["] = { query = "@function.outer", desc = "[TS] current or next method end" },
          ["]C"] = { query = "@class.outer", desc = "[TS] current or next class end" },
        },
        goto_previous_start = {
          ["[["] = { query = "@function.outer", desc = "[TS] current or prev method start" },
          ["[c"] = { query = "@class.outer", desc = "[TS] current or prev class start" },
        },
        goto_previous_end = {
          ["[]"] = { query = "@function.outer", desc = "[TS] prev method end" },
          ["[C"] = { query = "@class.outer", desc = "[TS] prev class end" },
        },
      },
      lsp_interop = {
        enable = true,
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
