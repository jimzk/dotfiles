-- Override default gitsigns
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L334-L368
return {
  "lewis6991/gitsigns.nvim",
  event = "LazyFile",
  keys = {
    { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", "diff current file (gitsigns)" },
    {
      "<leader>ob",
      function()
        local lazy_util = require("lazy.core.util")
        if not vim.g.gitsigns_toggle_inline_blame then
          lazy_util.info("Enable Git inline blame", { title = "Option" })
        else
          lazy_util.warn("Disable Git inline blame", { title = "Option" })
        end
        vim.g.gitsigns_toggle_inline_blame = not vim.g.gitsigns_toggle_inline_blame
        vim.cmd([[Gitsigns toggle_current_line_blame]])
      end,
      desc = "Toggle Line Blame (Gitsigns)",
    },
    {
      "<leader>og",
      function()
        local lazy_util = require("lazy.core.util")
        if not vim.g.gitsigns_deleted_word_diff_enabled then
          lazy_util.info("Enable highlight on Git deletion and diff", { title = "Option" })
        else
          lazy_util.warn("Disable highlight on Git deletion and diff", { title = "Option" })
        end
        vim.g.gitsigns_deleted_word_diff_enabled = not vim.g.gitsigns_deleted_word_diff_enabled
        vim.cmd([[Gitsigns toggle_deleted]])
        vim.cmd([[Gitsigns toggle_word_diff]])
      end,
      desc = "Toggle Deletion and Diff (Gitsigns)",
    },
  },
  opts = {
    attach_to_untracked = true,
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- stylua: ignore start
      local next_hunk_repeat, prev_hunk_repeat = require("util").make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      map({ "n", "x", "o" }, ")", next_hunk_repeat, "[G] Next Git Change")
      map({ "n", "x", "o" }, "(", prev_hunk_repeat, "[G] Prev Git Change")
      map({ "n", "v" }, "<leader>a", ":Gitsigns stage_hunk<CR>", "[G] Stage Git Hunk")
      map("n", "<leader>A", gs.stage_buffer, "[G] Stage Buffer")
      map("n", "<leader><C-a>", gs.undo_stage_hunk, "[G] Undo Stage Hunk")
      map({ "n", "v" }, "<leader>u", ":Gitsigns reset_hunk<CR>", "[G] Reset Hunk")
      map("n", "<leader>U", gs.reset_buffer, "[G] Reset Buffer")

      map("n", "g<CR>", gs.preview_hunk, "[G] Preview Hunk")

      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Git Blame Line")
      map("n", "<leader>gd", gs.diffthis, "Diff This")
      map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")

      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "[G] Git Hunk")
    end,
  },
}
