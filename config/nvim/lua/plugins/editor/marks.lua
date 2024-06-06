local M = {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  enabled = false,
  keys = {
    -- {
    --   "<M-m>",
    --   function()
    --     if vim.bo.ft == "qf" then
    --       vim.cmd("wincmd p")
    --     else
    --       vim.cmd("MarksListAll")
    --       -- Go to Last selected item in quickfix window
    --       Util.feedkeys("'\"")()
    --     end
    --   end,
    --   desc = "List All Marks",
    -- },
    { "m<CR>a", "<CMD>MarksListAll<CR>", desc = "List All Marks" },
    { "m<CR>g", "<CMD>MarksListGlobal<CR>", desc = "List Global Marks" },
    { "m<CR>b", "<CMD>MarksListBuf<CR>", desc = "List Marks in Buffer" },
    -- { "m<CR>o", "<CMD>BookmarksListAll<CR>", desc = "List Bookmarks" },
    -- { "<leader>oM", "<CMD>MarksToggleSign<CR>", desc = "Toggle Marks Sign" },
  },
}

M.opts = function()
  local opts = {
    default_mappings = false,
    -- excluded_filetypes = { "neo-tree" },
    -- excluded_buftypes = {},
    -- sign_priority = { lower = 2, upper = 3, builtin = 1, bookmark = 4 },
    mappings = {
      toggle = "m<space>",
      delete_buf = "dm<space>",
      delete = "dm",
      -- ISSUE: need  :q to quite preview window
      -- https://github.com/chentoast/marks.nvim/issues/86
      preview = "m<tab>",
      annotate = false,
    },
  }
  for i = 0, 9, 1 do
    local sign = tostring(i)
    opts["bookmark_" .. sign] = {
      sign = sign,
      annotate = false,
    }
  end
  return opts
end

M.config = function(_, opts)
  local marks = require("marks")
  marks.setup(opts)
  vim.cmd([[hi! link MarkSignNumHL LineNr]])
  require("which-key").register({
    dm = {
      name = "+delete marks",
      a = { desc = "Delete Mark a" },
      A = { desc = "Delete Mark A" },
      ["<space>"] = { desc = "Delete Lowercase Marks in Buffer" },
    },
    m = {
      name = "+marks/jumps/changes",
      -- m = { desc = "Add/Delete Marks in Current Line" },
      ["<tab>"] = { desc = "Preview Mark" },
      ["<CR>"] = { name = "list marks" },
      ["<space>"] = { desc = "Toggle Mark" },
    },
  })

  local map_repeat = Util.map_repeatable_move
  map_repeat("n", { "]m", "[m" }, { marks.next, marks.prev }, { "Next Mark", "Prev Mark" })
  map_repeat("n", { "m;", "m," }, { marks.next, marks.prev }, { "Next Mark (]m)", "Prev Mark ([m)" })

  -- local map = Util.map
  -- for i = 0, 9, 1 do
  --   local n = tostring(i)
  --   local is_1 = i == 1
  --   map("n", "m" .. n, marks["set_bookmark" .. n], is_1 and "Set Bookmark 1" or nil)
  --   map("n", "dm" .. n, marks["delete_bookmark" .. n], is_1 and "Delete Bookmark 1" or nil)
  --   local next_bookmark, _ =
  --     Util.make_repeatable_move_pair(marks["next_bookmark" .. n], marks["prev_bookmark" .. n])
  --
  --   -- Tips: m1 to mark several position, <leader>1 to move and ,/; to repeat
  --   map("n", "<leader>" .. n, function()
  --     local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  --     ts_repeat_move.set_last_move(next_bookmark, { forward = true })
  --     next_bookmark()
  --   end, is_1 and "Move to Bookmark 1" or nil)
  -- end
end

return M
