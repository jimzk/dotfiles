return {
  -- Split and join
  "Wansmer/treesj",
  dependencies = {
    "AndrewRadev/splitjoin.vim",
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
        local opts = { buffer = true }
        if langs[vim.bo.filetype] then
          map("n", "J", "<Cmd>TSJJoin<CR>", nil, opts)
          map("n", "K", "<Cmd>TSJSplit<CR>", nil, opts)
        else
          if vim.fn.maparg("J") == "" then
            map("n", "J", "<Cmd>SplitjoinJoin<CR>", nil, opts)
          end
          if vim.fn.maparg("K") == "" then
            map("n", "K", "<Cmd>SplitjoinSplit<CR>", nil, opts)
          end
        end
      end,
    })
  end
}
