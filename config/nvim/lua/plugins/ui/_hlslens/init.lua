return {
  "kevinhwang91/nvim-hlslens",
  event = "VeryLazy",
  config = function()
    -- https://github.com/petertriho/nvim-scrollbar#setup-packer
    -- setup up and overwrite hlslens
    require("scrollbar.handlers.search").setup({
      -- virtual text (https://github.com/kevinhwang91/nvim-hlslens#customize-virtual-text) is
      -- distracting so I dismiss all.
      override_lens = function() end
    })

    -- https://github.com/kevinhwang91/nvim-hlslens#vim-visual-multi
    vim.cmd([[
aug VMlens
  au!
  au User visual_multi_start lua require("plugins.ui.hlslens.vmlens").start()
  au User visual_multi_exit lua require("plugins.ui.hlslens.vmlens").exit()
aug END
]]   )
  end
}
