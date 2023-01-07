-- Tweak: I don't want to sign line highlight
-- Function from https://github.com/chentoast/marks.nvim/blob/a69253e4b471a2421f9411bc5bba127eef878dc0/lua/marks/utils.lua#L9
local utils = require("marks.utils")
utils.add_sign = function(bufnr, text, line, id, group, priority)
  -- hide mark v as I have special use
  -- if text == "v" then return end
  priority = priority or 10
  local sign_name = "Marks_" .. text
  if not utils.sign_cache[sign_name] then
    utils.sign_cache[sign_name] = true
    vim.fn.sign_define(sign_name, { text = text, texthl = "MarkSignHL" })
  end
  vim.fn.sign_place(id, group, sign_name, bufnr, { lnum = line, priority = priority })
end

-- https://github.com/chentoast/marks.nvim#setup
require("marks").setup {
  default_mappings = true,
  -- NOTE: If float buffer of lsp.hover() has marks then it shows signcolumn and can't have enought width
  -- Makr . must be hidden as it always shows in float buffer of lsp.
  builtin_marks = { "<", ">", ".", "`", '"' },
  -- I don't know what it is. I think it may afffect jumplist
  cyclic = false,
  force_write_shada = false,
  refresh_interval = 250,
  sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
  excluded_filetypes = Utils.non_code_filetypes,
  mappings = {
    toggle = false,
    -- FIX: need  :q to quite preview window
    -- https://github.com/chentoast/marks.nvim/issues/86
    preview = "m;",
    delete_line = "dm<space>",
    delete_buf = "dm-",
    annotate = false,
    set_bookmark0 = false,
    set_bookmark1 = false,
    set_bookmark2 = false,
    set_bookmark3 = false,
    set_bookmark4 = false,
    set_bookmark5 = false,
    set_bookmark6 = false,
    set_bookmark7 = false,
    set_bookmark8 = false,
    set_bookmark9 = false,
    delete_bookmark0 = false,
    delete_bookmark1 = false,
    delete_bookmark2 = false,
    delete_bookmark3 = false,
    delete_bookmark4 = false,
    delete_bookmark5 = false,
    delete_bookmark6 = false,
    delete_bookmark7 = false,
    delete_bookmark8 = false,
    delete_bookmark9 = false,
  }
}

-- color definied by marks.nvm
vim.cmd("autocmd ColorScheme * highlight link MarkSignNumHL LineNr")

set("n", "tm", function() -- Trouble version :MarksListBuf
  require 'marks'.mark_state:buffer_to_list()
  require("trouble").open('loclist')
end, { desc = "list LOCAL marks in current buffer" })
set("n", "tM", function() -- Trouble version MarksListGlobal
  require 'marks'.mark_state:global_to_list()
  require("trouble").open('loclist')
end, { desc = "list LOCAL marks in current buffer" })
