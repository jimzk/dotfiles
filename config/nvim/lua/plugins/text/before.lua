return {
  -- https://www.reddit.com/r/neovim/comments/1b89dmj/beforenvim_cycle_through_edits_across_buffers/
  -- NOTE: experimental
  "bloznelis/before.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {
    history_wrap_enabled = true,
  },
  config = function(opts)
    local before = require("before")
    before.setup(opts)

    -- local map = util.map
    -- local jump_to_next_edit, jump_to_last_edit =
    --   util.make_repeatable_move_pair(before.jump_to_next_edit, before.jump_to_next_edit)
    -- map("n", "]\\", jump_to_next_edit, "Next changelist in Buffer")
    -- map("n", "[\\", jump_to_last_edit, "Prev changelist in Buffer")

    vim.defer_fn(function()
      local map = Util.map
      -- local del = vim.keymap.del
      -- del({ "n", "i", "v" }, "<M-j>")
      -- del({ "n", "i", "v" }, "<M-k>")
      map({ "n", "v" }, "<M-l>", before.jump_to_last_edit, "Prev Changelist in Buffer")
      map({ "n", "v" }, "<M-h>", before.jump_to_next_edit, "Next Changelist in Buffer")
    end, 500)
  end,
}
