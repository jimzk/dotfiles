return {
  "kevinhwang91/nvim-hlslens",
  event = "VeryLazy",
  dependencies = { {
    "petertriho/nvim-scrollbar",
    optional = true,
  } },
  config = function(_, opts)
    if package.loaded["scrollbar"] then
      -- setup up and overwrite hlslens
      -- https://github.com/petertriho/nvim-scrollbar#setup-packer
      require("scrollbar.handlers.search").setup({
        enable_incsearch = false,
        -- Modify from https://github.com/kevinhwang91/nvim-hlslens#vim-visual-multi
        -- Only show len of current match in virtual text
        override_lens = function(render, posList, nearest, idx, _)
          local lnum, col = unpack(posList[idx])
          local cnt = #posList
          local text = ("[%d/%d]"):format(idx, cnt)
          local highlight = nearest and "HlSearchLensNear" or "HlSearchLens"
          local chunks = { { " " }, { text, highlight } }
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)

          -- if not nearest then
          --   return
          -- end
          -- local _ = relIdx
          -- local lnum, col = unpack(posList[idx])
          -- local text, chunks
          -- text = ("[%d/%d]"):format(idx, #posList)
          -- chunks = { { " ", "Ignore" }, { text, "HlSearchNear" } }
          -- render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end,
      })
    else
      require("hlslens").setup(opts)
    end

    vim.cmd([[hi! link HlSearchNear CurSearch]])
    vim.cmd([[hi! link HlSearchLensNear CurSearch ]])
    -- vim.cmd([[hi! link HlSearchNear @text.todo]])
    -- vim.cmd([[hi! link HlSearchLensNear @text.todo]])

    -- Integrate hslens with visual-multi
    -- https://github.com/kevinhwang91/nvim-hlslens#vim-visual-multi
    local hlslens = require("hlslens")
    local overrideLens = function(render, posList, nearest, idx, relIdx)
      local _ = relIdx
      local lnum, col = unpack(posList[idx])

      local text, chunks
      if nearest then
        text = ("[%d/%d]"):format(idx, #posList)
        chunks = { { " ", "Ignore" }, { text, "VM_Extend" } }
      else
        text = ("[%d]"):format(idx)
        chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
      end
      render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
    end
    local lensBak
    local config = require("hlslens.config")
    local gid = vim.api.nvim_create_augroup("VMlens", {})
    vim.api.nvim_create_autocmd("User", {
      pattern = { "visual_multi_start", "visual_multi_exit" },
      group = gid,
      callback = function(ev)
        if ev.match == "visual_multi_start" then
          lensBak = config.override_lens
          config.override_lens = overrideLens
        else
          config.override_lens = lensBak
        end
        hlslens.start()
      end,
    })
  end,
}
