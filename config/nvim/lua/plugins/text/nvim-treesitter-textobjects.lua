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
          ["]e"] = { query = "@parameter.inner", desc = "[TS] swap para with next" },
        },
        swap_previous = {
          ["[e"] = { query = "@parameter.inner", desc = "[TS] swap para with prev" },
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "[TS] next method start" },
          ["]]"] = { query = "@class.outer", desc = "[TS] next class start" },
          ["]s"] = { query = "@scope", query_group = "locals", desc = "[TS] next scope" },
        },
        goto_next_end = {
          ["]F"] = { query = "@function.outer", desc = "[TS] current or next method end" },
          ["]["] = { query = "@class.outer", desc = "[TS] current or next class end" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "[TS] current or prev method start" },
          ["[["] = { query = "@class.outer", desc = "[TS] current or prev class start" },
          ["[s"] = { query = "@scope", query_group = "locals", desc = "[TS] prev scope" },
        },
        goto_previous_end = {
          ["[F"] = { query = "@function.outer", desc = "[TS] prev method end" },
          ["[]"] = { query = "@class.outer", desc = "[TS] prev class end" },
        },
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
  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  -- Repeat movement with ; and ,
  -- ensure ; goes forward and , goes backward regardless of the last direction
  local keys = vim.api.nvim_replace_termcodes("zz", true, false, true)
  map({ "n", "x", "o" }, ";", function()
    ts_repeat_move.repeat_last_move_next()
    vim.api.nvim_feedkeys(keys, "m", true)
  end)
  map({ "n", "x", "o" }, ",", function()
    ts_repeat_move.repeat_last_move_previous()
    vim.api.nvim_feedkeys(keys, "m", true)
  end)
end

return M
