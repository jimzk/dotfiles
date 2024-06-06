-- Override default gitsigns
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L334-L368
return {
  "lewis6991/gitsigns.nvim",
  -- event = "LazyFile",
  event = "VeryLazy",
  keys = {
    {
      "<leader>ob",
      function()
        Util.toggle(vim.g.gitsigns_toggle_inline_blame, function()
          vim.g.gitsigns_toggle_inline_blame = not vim.g.gitsigns_toggle_inline_blame
          vim.cmd([[Gitsigns toggle_current_line_blame]])
        end, "Git Inline Blame")
      end,
      desc = "Toggle Line Blame (Gitsigns)",
    },
    {
      "<leader>og",
      function()
        Util.toggle(vim.g.gitsigns_deleted_word_diff_enabled, function()
          vim.g.gitsigns_deleted_word_diff_enabled = not vim.g.gitsigns_deleted_word_diff_enabled
          vim.cmd([[Gitsigns toggle_deleted]])
          vim.cmd([[Gitsigns toggle_word_diff]])
        end, "Deletion and Diff")
      end,
      desc = "Toggle Deletion and Diff (Gitsigns)",
    },
  },

  opts = {
    attach_to_untracked = true,
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      local prev_hunk = function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end

      local next_hunk = function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end

      local next_hunk_repeat, prev_hunk_repeat = Util.make_repeatable_move_pair(next_hunk, prev_hunk)
      map({ "n", "x", "o" }, ")", next_hunk_repeat, "[G] Next Git Change")
      map({ "n", "x", "o" }, "(", prev_hunk_repeat, "[G] Prev Git Change")

      -- stylua: ignore start
      map("n", "<leader>a", gitsigns.stage_hunk, "[G] Stage Git Hunk")
      map("v", "<leader>a", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "[G] Stage Git Hunk")
      map("n", "<leader>A", gitsigns.stage_buffer, "[G] Stage Buffer")
      map("n", "<leader><C-a>", gitsigns.undo_stage_hunk, "[G] Undo Stage Hunk")

      map("n", "<leader>u", gitsigns.reset_hunk, "[G] Reset Hunk")
      map("v", "<leader>u", function() gitsigns.reset_hunk ({ vim.fn.line('.'), vim.fn.line('v') }) end, "[G] Reset Hunk")
      map("n", "<leader>U", gitsigns.reset_buffer, "[G] Reset Buffer")

      map("n", "g<CR>", gitsigns.preview_hunk, "[G] Preview Hunk")

      map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, "Git Blame Line (Gitsigns)")
      map("n", "<leader>gd", gitsigns.diffthis, "Diff With Staging Area")
      map("n", "<leader>gD", function() gitsigns.diffthis("~1") end, "Diff With Last Commit")

      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "[G] Git Hunk")
    end,
  },
}
