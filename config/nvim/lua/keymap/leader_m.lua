local wk = require("which-key")
local opt = { mode = "n", prefix = "<leader>m", noremap = true, silent = true }
wk.register({
  name = "marks",
  m = { "<cmd>MarksListBuf<cr>", "list local marks in current buffer" },
  M = { "<cmd>MarksListGlobal<cr>", "list global marks in all buffers" },
  ["<C-M>"] = { "<cmd>MarksListAll<cr>", "list all marks" },
  b = { function()
    vim.ui.input(
      { prompt = "Enter bookmark group number (0-9): " },
      function(input)
        if not input then
          return
        end
        vim.cmd("BookmarksList " .. input)
      end
    )
  end, "list bookmarks of group #n" },
  B = { "<cmd>MarksListAll<cr>", "list all bookmarks" },
  o = { "<cmd>MarksToggleSigns<cr>", "toggle marks sign" },
  h = { "<cmd>h '[<cr>", "meaning of special mark" },
  d = { -- marks.nvim
    name = "marks.nvim commands",
    ["0"] = { "m, set random mark" },
    ["1"] = { "m1 set mark 1" },
    ["2"] = { "ma set mark a" },
    ["3"] = { "mA set mark A (across buffers)" },
    ["4"] = { "m;a preview mark a" },
    ["5"] = { "m[ move to next mark (m] opposite)" },
    ["6"] = { "m- delete current mark" },
    ["a"] = { "dma delete mark a" },
    ["b"] = { "dm- delete all marks" },
  },
}, opt)
