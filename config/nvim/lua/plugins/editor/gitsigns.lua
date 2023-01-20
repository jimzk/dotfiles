-- git signs
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  -- stylua: ignore
  opts = {
    signs      = {
      add          = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      change       = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      delete       = { hl = 'GitSignsDelete', text = '契', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      topdelete    = { hl = 'GitSignsDelete', text = '契', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      changedelete = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      untracked    = { text = "▎" },
    },
    signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
    numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    on_attach  = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      map({ "n", "x", "o" }, ")", gs.next_hunk, "[G] next git change")
      map({ "n", "x", "o" }, "(", gs.prev_hunk, "[G] prev git change")
      map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<CR>", "[G] Git change")

      map({ "n", "v" }, "<leader>a", "<cmd>Gitsigns stage_hunk<CR><cmd>up<cr>", "[G] stage hunk")
      map("n", "<leader>A", function()
        gs.stage_buffer()
        vim.cmd [[up]]
      end, "[G] stage buffer")
      map("n", "<leader><C-a>", gs.undo_stage_hunk, "[G] undo staged hunk")

      map({ "n", "v" }, "<leader>u", "<cmd>Gitsigns reset_hunk<CR>", "[G] revert hunk")
      map("n", "<leader>U", gs.reset_buffer, "[G] revert buffer")

      map("n", "<leader><cr>", gs.preview_hunk, "[G] preview hunk")

      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "[G] line blame")
    end,
  },
}
