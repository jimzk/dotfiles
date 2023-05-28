local M = {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>mm", "<CMD>MarksListAll<CR>", desc = "show marks all" },
    { "<leader>mb", "<CMD>MarksListBuf<CR>", desc = "show marks in current buf" },
    { "<leader>m<space>", "<CMD>MarksListGlobal<CR>", desc = "show GLOBAL (uppercase) marks" },
  }
}

M.opts = function()
  local opts = {
    default_mappings = true,
    -- NOTE: If float buffer of lsp.hover() has marks then it shows signcolumn and can't have enought width
    -- Makr . must be hidden as it always shows in float buffer of lsp.
    builtin_marks = {},
    signs = true,
    -- I don't know what it is. It may affect jumplist
    cyclic = false,
    force_write_shada = false,
    refresh_interval = 250,
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    excluded_filetypes = Util.unlisted_filetypes,
    mappings = {
      toggle = false,
      -- FIX: need  :q to quite preview window
      -- https://github.com/chentoast/marks.nvim/issues/86
      preview = "'<space>",
      delete_line = "dm<space>",
      delete_buf = "dm<bs>",
      annotate = false,
    },
  }
  for i = 0, 9, 1 do
    opts.mappings["set_bookmark" .. i] = false
    opts.mappings["delete_bookmark" .. i] = false
  end
  return opts
end

M.config = function(_, opts)
  -- Tweak: I don't want to signline highlight
  -- Function from https://github.com/chentoast/marks.nvim/blob/a69253e4b471a2421f9411bc5bba127eef878dc0/lua/marks/utils.lua#L9
  local utils = require("marks.utils")
  utils.add_sign = function(bufnr, text, line, id, group, priority)
    -- hide mark v as I have special use
    if text == "v" then return end
    priority = priority or 10
    local sign_name = "Marks_" .. text
    if not utils.sign_cache[sign_name] then
      utils.sign_cache[sign_name] = true
      vim.fn.sign_define(sign_name, { text = text, texthl = "MarkSignHL" })
    end
    vim.fn.sign_place(id, group, sign_name, bufnr, { lnum = line, priority = priority })
  end
  require("marks").setup(opts)
end

return M
