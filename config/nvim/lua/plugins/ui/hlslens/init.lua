return {
  "kevinhwang91/nvim-hlslens",
  event = "VeryLazy",
  config = function()
    -- https://github.com/petertriho/nvim-scrollbar#setup-packer
    -- setup up and overwrite hlslens
    require("scrollbar.handlers.search").setup({
      -- Modify from https://github.com/kevinhwang91/nvim-hlslens#vim-visual-multi
      -- Only show len of current match in virtual text
      override_lens = function(render, posList, nearest, idx, relIdx)
        if not nearest then
          return
        end
        local _ = relIdx
        local lnum, col = unpack(posList[idx])
        local text, chunks
        text = ("[%d/%d]"):format(idx, #posList)
        chunks = { { " ", "Ignore" }, { text, "HlSearchNear" } }
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end,
    })

    -- HACK: * and / will highlighted by CurSearch but not InSearch.
    -- I guess catppucin changes it.
    vim.cmd([[hi! link HlSearchNear CurSearch]])
    vim.cmd([[hi! link HlSearchLensNear CurSearch ]])

    -- https://github.com/kevinhwang91/nvim-hlslens#vim-visual-multi
    vim.cmd [[
    aug VMlens
      au!
      au User visual_multi_start lua require("plugins.ui.hlslens.vmlens").start()
      au User visual_multi_exit lua require("plugins.ui.hlslens.vmlens").exit()
    aug END ]]
  end,
}
