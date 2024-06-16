local map = Util.map

-- Get back to original poistion from visual mode
-- Use case: after vib to select and <esc> to cancel the visual, <C-o> can jump back
map("n", "v", "m`v")
-- map("n", "vv", "m`v$o")
map("n", "V", "m`V")
map("n", "<C-V>", "m`<C-V>")
-- Use ` to compatible with treesitter incremental_selection which marks v continusouly
map("n", "gv", "m`gv")

-- vim.api.nvim_create_autocmd("BufLeave", {
--   pattern = "*",
--   callback = function()
--     -- No preserve visual start point
--     vim.api.nvim_buf_del_mark(0, "v")
--   end,
-- })

-- Update jumplist for [cound]j/k
-- for i = 1, 99, 1 do
--   local j_fn, k_fn = Util.make_repeatable_move_pair(function()
--     vim.cmd("normal! m`" .. i .. "j")
--   end, function()
--     vim.cmd("normal! m`" .. i .. "k")
--   end)
--   map("n", i .. "j", j_fn)
--   map("n", i .. "k", k_fn)
-- end

-- Replacement
-- * https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjojs2y
-- * https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjn1kww
-- map("n", "<leader>rx", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace Cursor Word (Exact)")
-- & to repeat search
map(
  "n",
  "<leader>rl",
  ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>",
  "Replace in Current Line"
)
map(
  "x",
  "<leader>rv",
  ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>",
  "Replace in Visual Range"
)

map("v", "<leader>rw", '"hy:%s/\\c<C-r>h/<C-r>h/gc<left><left><left>', "Replace") -- g for global replace, c for confirmation
map("n", "<leader>rw", ":%s/\\c<C-r><C-w>/<C-r><C-w>/gcI<Left><Left><Left><Left>", "Replace Cursor Word") -- I for word identification
map("n", "<leader>rw", ":%s/\\c<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>", "Replace Cursor Word") -- I for word identification
map("v", "<leader>rW", '"hy:%s/\\C<C-r>h/<C-r>h/gc<left><left><left>', "Replace (Case-sensitive)")
map("n", "<leader>rW", ":%s/\\C<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>", "Replace Cursor Word (Case-sensitive)")

require("which-key").register({
  ["<leader>rp"] = { name = "replace snippets" },
})

-- https://www.reddit.com/r/neovim/comments/1ajdtvi/replacing_a_with_b_in_every_line_that_contains_c/
map("n", "<leader>rpr", ":g/C/g!/D/s/A/B/g", "Replace A by B in lines having C and not D")

-- Search in visual range
map("x", "/", '"hy/<C-r>h', "Search Cursor Word")
map("n", "<leader>/", "/<C-r>/", "Last Search")
map("x", "<leader>r/", "<Esc>/\\%V", "Search in the Visual")

-- Search in visible range (:h search-range)
map("n", "<leader>rg", function()
  vim.wo.scrolloff = 0
  local topline = vim.fn.winsaveview().topline
  local bottomline = vim.api.nvim_win_get_height(0) + topline
  local keys = string.format([[/\%%>%sl\%%<%sl]], topline - 1, bottomline)
  Util.feedkeys(keys)()
end, "Search in Visible Area")
