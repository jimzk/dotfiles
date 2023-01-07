vim.g.matchup_mappings_enabled = 0
vim.g.matchup_matchparen_offscreen = { method = 'popup' }
vim.g.matchup_matchparen_enabled = 1

require("which-key").register({
  ["%"] = { "<Plug>(matchup-%)", "which_key_ignore" },
  [";"] = { "<Plug>(matchup-%)", "alias %" },

  ["]%"] = { "<Plug>(matchup-]%)", "next syntax closing bracket" },
  ["[%"] = { "<Plug>(matchup-[%)", "prev syntax opening bracket" },
  ["];"] = { "<Plug>(matchup-]%)", "alias ]%" },
  ["[;"] = { "<Plug>(matchup-[%)", "alias [%" },
  ["]b"] = { "<Plug>(matchup-]%)", "alias ]%" },
  ["[b"] = { "<Plug>(matchup-[%)", "alias [%" },

  -- yib use mode o, vib use mode x
  -- yib jumps to original place. dib may be accepted. need to handle
  ["ib"] = { "<Plug>(matchup-i%)", "syntax bracket", mode = { "o", "x" } },
  ["ab"] = { "<Plug>(matchup-a%)", "syntax bracket", mode = { "o", "x" } },

  ["<C-;>"] = { "<Plug>(matchup-z%)", "go inside next bracket" },
}, { mode = { "n", "o", "x" }, noremap = true })

-- TODO: How to use <C-o> jumps back to start of visual when using vib and ib ib
-- local object = function(mode)
--   return function()
--     -- Execute command first and then set mark
--     vim.cmd([[exe "normal! \<Plug>(matchup-]] .. mode .. [[%)"]])
--     local left_pos = vim.api.nvim_buf_get_mark(0, "<")
--     local right_pos = vim.api.nvim_buf_get_mark(0, ">")
--     -- Only mark at vib, not in visual
--     local pos = vim.api.nvim_win_get_cursor(0)
--     if left_pos[1] == right_pos[1] and left_pos[2] == right_pos[2] then
--       vim.notify("mark")
--       -- vim.cmd [[normal Gg````]]
--       -- vim.cmd [[normal m`]]
--       vim.api.nvim_buf_set_mark(0, "`", left_pos[1], left_pos[2], {})
--     else
--       -- vim.cmd [[normal m`]]
--       -- vim.cmd [[normal Gg````]]
--       -- vim.cmd [[normal ````]]
--       -- vim.notify("mark cursor")
--       -- local cursor = vim.api.nvim_win_get_cursor(0)
--       -- vim.api.nvim_buf_set_mark(0, "`", cursor[1], cursor[2], {})
--     end
--     -- vim.notify(dump(cursor))
--   end
-- end
-- set("x", "ib", object("i"), { desc = "syntax bracket" })
-- set("x", "ab", object("a"))
-- set("o", "ib", "<Plug>(matchup-i%)")
-- set("o", "ab", "<Plug>(matchup-a%)")

require("nvim-treesitter.configs").setup {
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable_virtual_text = false,
  },
}
