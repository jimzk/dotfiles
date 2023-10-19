local text = "┃"
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  keys = {
    { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", "diff current file (gitsigns)" },
    { "<leader>ob", function()
      local lazy_util = require("lazy.core.util")
      if not vim.g.gitsigns_toggle_inline_blame then
        lazy_util.info("Enable Git inline blame", { title = "Option" })
      else
        lazy_util.warn("Disable Git inline blame", { title = "Option" })
      end
      vim.g.gitsigns_toggle_inline_blame = not vim.g.gitsigns_toggle_inline_blame
      vim.cmd [[Gitsigns toggle_current_line_blame]]
    end, "toggle line blame" },
    { "<leader>og", function()
      local lazy_util = require("lazy.core.util")
      if not vim.g.gitsigns_deleted_word_diff_enabled then
        lazy_util.info("Enable highlight on Git deletion and diff", { title = "Option" })
      else
        lazy_util.warn("Disable highlight on Git deletion and diff", { title = "Option" })
      end
      vim.g.gitsigns_deleted_word_diff_enabled = not vim.g.gitsigns_deleted_word_diff_enabled
      vim.cmd [[Gitsigns toggle_deleted]]
      vim.cmd [[Gitsigns toggle_word_diff]]
    end, "toggle git deletion and word diff" },
  },
  opts = {
    signs      = {
      add          = { text = text, hl = "GitSignsAdd", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change       = { text = text, hl = "GitSignsChange", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete       = { text = text, hl = "GitSignsDelete", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete    = { text = text, hl = "GitSignsDelete", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { text = text, hl = "GitSignsChange", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      untracked    = { text = text },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    on_attach  = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      local gs = require("gitsigns")

      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-move
      local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
      local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      map({ "n", "x", "o" }, ")", next_hunk_repeat, "[G] next git change")
      map({ "n", "x", "o" }, "(", prev_hunk_repeat, "[G] prev git change")
      -- map({ "n", "x", "o" }, ")", gs.next_hunk, "[G] next git change")
      -- map({ "n", "x", "o" }, "(", gs.prev_hunk, "[G] prev git change")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "[G] Git change")

      map({ "n", "x" }, "<leader>a", "<cmd>Gitsigns stage_hunk<CR><cmd>up<cr>", "[G] stage hunk")
      map("n", "<leader>A", function()
        gs.stage_buffer()
        vim.cmd [[up]]
      end, "[G] stage buffer")
      map("n", "<leader><C-a>", gs.undo_stage_hunk, "[G] undo staged hunk")

      map({ "n", "v" }, "<leader>u", "<cmd>Gitsigns reset_hunk<CR>", "[G] revert hunk")
      map("n", "<leader>U", gs.reset_buffer, "[G] revert buffer")

      map("n", "S", gs.preview_hunk, "[G] preview hunk")

      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "[G] line blame")

      map("n", "<leader>gq", "<CMD>Gitsigns setqflist<CR>", "[G] list git changes quickfix list")
    end,
  },
}
