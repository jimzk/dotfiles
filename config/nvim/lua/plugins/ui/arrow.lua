return {
  "otavioschwanck/arrow.nvim",
  event = "VeryLazy",
  dependencies = {
    { "chentoast/marks.nvim", enabled = false },
    { "tomasky/bookmarks.nvim", enabled = false },
  },
  keys = function()
    local commands = require("arrow.commands").commands
    local arrow = require("arrow.persist")
    local keys = {
      -- marks in local file
      { "<M-j>", commands.next_buffer_bookmark, mode = { "n", "v" }, desc = "Next Mark (Arrow)" },
      { "<M-k>", commands.prev_buffer_bookmark, mode = { "n", "v" }, desc = "Prev Mark (Arrow)" },
      { "-", arrow.previous, desc = "Prev File (Arrow)" },
      { "=", arrow.next, desc = "Next File (Arrow)" },
    }
    for i = 1, 9 do
      table.insert(keys, {
        "<M-" .. i .. ">",
        function()
          arrow.go_to(i)
        end,
        desc = i == 1 and "Navigate File 1 (Arrow)" or "which_key_ignore",
      })
    end
    return keys
  end,
  opts = {
    leader_key = "<C-c>", -- Recommended to be a single key
    buffer_leader_key = "m", -- Per Buffer Mappings
    always_show_path = true,
    separate_save_and_remove = false,
    mappings = {
      toggle = "m", -- used as save if separate_save_and_remove is true
      remove = "X", -- only used if separate_save_and_remove is true
      edit = "e",
      delete_mode = "d",
      clear_all_items = "D",
      open_vertical = "v",
      open_horizontal = "s",
      quit = "q",
      next_item = "l",
      prev_item = "h",
    },
    per_buffer_config = {
      lines = 5,
    },
  },
}
