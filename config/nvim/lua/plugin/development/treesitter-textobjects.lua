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
        -- mini.ai has already provide aa and ia
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
        [",a"] = { query = "@parameter.inner", desc = "swap with next parameter" },
      },
      swap_previous = {
        [",A"] = { "@parameter.inner", desc = "swap with prev parameter" }
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]]"] = { query = "@function.outer", desc = "[T] next method start" },
        ["]c"] = { query = "@class.outer", desc = "[T] next class start" },
      },
      goto_next_end = {
        ["]["] = { query = "@function.outer", desc = "[T] current or next method end" },
        ["]C"] = { query = "@class.outer", desc = "[T] current or next class end" },
      },
      goto_previous_start = {
        ["[["] = { query = "@function.outer", desc = "[T] current or prev method start" },
        ["[c"] = { query = "@class.outer", desc = "[T] current or prev class start" },
      },
      goto_previous_end = {
        ["[]"] = { query = "@function.outer", desc = "[T] prev method end" },
        ["[C"] = { query = "@class.outer", desc = "[T] prev class end" },
      },
    },
    lsp_interop = {
      enable = true,
      border = 'double',
      floating_preview_opts = {},
      peek_definition_code = {
        ["gf"] = { query = "@function.outer", desc = "[T] peek outer function" },
        -- ["gJ"] = "@class.outer",
      },
    },
  },
}
