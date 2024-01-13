local M = {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  event = "BufReadPost",
}

M.init = function()
  -- I don't want foldcolumn to be shown.
  -- And foldcolumn has issue after statuscolumn is introduced.
  -- https://github.com/kevinhwang91/nvim-ufo/issues/4
  vim.o.foldcolumn = "0" -- '0' is not bad
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = -1
  vim.o.foldenable = true
end

-- https://github.com/kevinhwang91/nvim-ufo#customize-fold-text
local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

M.opts = {
  fold_virt_text_handler = handler,
  open_fold_hl_timeout = 150,
  preview = {
    win_config = {
      border = "single",
      winhighlight = "Normal:Normal",
      winblend = 5,
    },
    mappings = {
      scrollU = "<C-b>",
      scrollD = "<C-f>",
    },
  },
}

M.config = function(_, opts)
  local ufo = require("ufo")
  ufo.setup(opts)
  -- Consistent preview window highlight
  vim.cmd([[hi! link UfoPreviewCursorLine @comment]])
  -- More clear foled line
  vim.cmd([[hi Folded guifg=#949cbb guibg=#3b3f52]]) -- link to Highlight of Pmenu

  local map = require("util").map
  map("n", "zR", ufo.openAllFolds)
  map("n", "zM", ufo.closeAllFolds)
  map("n", "zr", ufo.openFoldsExceptKinds)
  map("n", "zm", ufo.closeFoldsWith)

  local next_fold = function()
    ufo.goNextClosedFold()
    ufo.peekFoldedLinesUnderCursor()
  end
  local prev_fold = function()
    ufo.goPreviousClosedFold()
    ufo.peekFoldedLinesUnderCursor()
  end
  local next_fold_proxy, prev_fold_proxy = require("util").make_repeatable_move_pair(next_fold, prev_fold)
  map({ "n", "x", "o" }, "]z", next_fold_proxy, "Next Fold")
  map({ "n", "x", "o" }, "[z", prev_fold_proxy, "Prev Fold")
end

return M
