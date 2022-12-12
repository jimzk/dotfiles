require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "[T] method" },
        ["if"] = { query = "@function.inner", desc = "[T] method " },
        ["ac"] = { query = "@class.outer", desc = "[T] class" },
        ["ic"] = { query = "@class.inner", desc = "[T] class" },
        -- targets.vim provides ia and aa for parameter selection. No need treesitter-textobjects for this.
        -- ["aa"] = "@parameter.outer",
        -- ["ia"] = "@parameter.inner",
      },
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      include_surrounding_whitespace = true,
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>cp"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>cP"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = { query = "@function.outer", desc = "[T] next method start" },
        ["]]"] = { query = "@class.outer", desc = "[T] next class start" },
      },
      goto_next_end = {
        ["]F"] = { query = "@function.outer", desc = "[T] current or next method end" },
        ["]["] = { query = "@class.outer", desc = "[T] next class end" },
      },
      goto_previous_start = {
        ["[f"] = { query = "@function.outer", desc = "[T] current or previous method start" },
        ["[["] = { query = "@class.outer", desc = "[T] previous class start" },
      },
      goto_previous_end = {
        ["[F"] = { query = "@function.outer", desc = "[T] previous method end" },
        ["[]"] = { query = "@class.outer", desc = "[T] previous class end" },
      },
    },
  },
}
