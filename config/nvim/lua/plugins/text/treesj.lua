return {
  -- Split and join
  "Wansmer/treesj",
  dependencies = {
    {
      "AndrewRadev/splitjoin.vim",
      init = function()
        vim.g.splitjoin_join_mapping = ""
        vim.g.splitjoin_split_mapping = ""
      end,
    },
  },
  event = "VeryLazy",
  opts = {
    use_default_keymaps = false,
  },
  config = function(_, opts)
    require("treesj").setup(opts)
    -- fallback: https://github.com/Wansmer/treesj/discussions/19
    local langs = require("treesj.langs")["presets"]
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "*",
      callback = function()
        local key_join = "J"
        local key_split = "S"
        local opts = { buffer = true }
        if langs[vim.bo.filetype] then
          map("n", key_join, "<Cmd>TSJJoin<CR>", nil, opts)
          map("n", key_split, "<Cmd>TSJSplit<CR>", nil, opts)
        else
          if vim.fn.maparg(key_join) == "" then
            map("n", key_join, "<Cmd>SplitjoinJoin<CR>", nil, opts)
          end
          if vim.fn.maparg(key_split) == "" then
            map("n", key_split, "<Cmd>SplitjoinSplit<CR>", nil, opts)
          end
        end
      end,
    })
  end
}
