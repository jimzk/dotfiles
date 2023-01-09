local yank = require("yanky")
local utils = require("yanky.utils")
local mapping = require("yanky.telescope.mapping")

yank.setup({
  highlight = {
    on_put = false,
    on_yank = false,
  },
  preserve_cursor_position = {
    enabled = true,
  },
  picker = {
    telescope = {
      mappings = {
        default = mapping.put("p"),
        i = {
          -- ["<c-p>"] = mapping.put("p"),
          -- ["<c-k>"] = mapping.put("P"),
          ["<c-d>"] = mapping.delete(),
          ["<c-r>"] = mapping.set_register(utils.get_default_register()),
        },
      }
    }
  }
})

-- Smart put
set("n", "p", "<Plug>(YankyPutAfter)")
set("n", "P", "<Plug>(YankyPutBefore)")
-- No yank at visual put
set("x", "p", '"_<Plug>(YankyPutIndentAfterCharwise)')
set("x", "P", '"_<Plug>(YankyPutIndentAfterCharwise)')
-- Yank linewise
set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")

-- Preserve cursor position on yank
set({ "n", "x" }, "y", "<Plug>(YankyYank)")
set({ "n", "x" }, "Y", "<Plug>(YankyYank)$")

require("telescope").load_extension("yank_history")
set("n", "<leader>ep", require("telescope").extensions.yank_history.yank_history, { desc = "yank history" })
