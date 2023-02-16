local M = {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  cmd = { "DiffviewOpen", "DiffviewToggleFiles" },
}

local get_keymaps = function()
  local actions = require("diffview.actions")
  local keymaps = {
    disable_defaults = true, -- Disable the default keymaps
    view = {
      { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
      { "n", "<C-n>", actions.select_next_entry, { desc = "Open diff for next file" } },
      { "n", "<C-p>", actions.select_prev_entry, { desc = "Open diff for previous file" } },

      { "n", "<cr>", actions.goto_file_edit, { desc = "Close diffview and open file" } },
      { "n", "<S-cr>", actions.goto_file, { desc = "Close diffview and open file in split" } },

      { "n", "<tab>", actions.focus_files, { desc = "Focus on file panel" } },

      { "n", "\\", actions.cycle_layout, { desc = "Change view layout" } },

      { "n", "[x", actions.prev_conflict, { desc = "In merge-tool: jump to previous conflict" } },
      { "n", "]x", actions.next_conflict, { desc = "In merge-tool: jump to next conflict" } },
      { "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose OURS version for conflict" } },
      { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS version for conflict" } },
      { "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose BASE version for conflict" } },
      { "n", "<leader>ca", actions.conflict_choose("all"), { desc = "Choose all versions for conflict" } },
      { "n", "dx", actions.conflict_choose("none"), { desc = "Delete conflict region" } },
    },
    diff1 = {
      -- Mappings in single window diff layouts
      { "n", "?", actions.help({ "view", "diff1" }), { desc = "diffview_ignore" } },
    },
    diff2 = {
      -- Mappings in 2-way diff layouts
      { "n", "?", actions.help({ "view", "diff2" }), { desc = "diffview_ignore" } },
    },
    diff3 = {
      -- Mappings in 3-way diff layouts
      { { "n", "x" }, "2do", actions.diffget("ours"),
        { desc = "Obtain diff hunk from OURS version" } },
      { { "n", "x" }, "3do", actions.diffget("theirs"),
        { desc = "Obtain diff hunk from THEIRS version" } },
      { "n", "?", actions.help({ "view", "diff3" }), { desc = "diffview_ignore" } },
    },
    diff4 = {
      -- Mappings in 4-way diff layouts
      { { "n", "x" }, "1do", actions.diffget("base"),
        { desc = "Obtain diff hunk from BASE version" } },
      { { "n", "x" }, "2do", actions.diffget("ours"),
        { desc = "Obtain diff hunk from OURS version" } },
      { { "n", "x" }, "3do", actions.diffget("theirs"),
        { desc = "Obtain diff hunk from THEIRS version" } },
      { "n", "?", actions.help({ "view", "diff4" }), { desc = "diffview_ignore" } },
    },
    file_panel = {
      { "n", "<tab>", Util.focus_win, { desc = "diffview_ignore" } },
      { "n", "<esc>", actions.toggle_files, { desc = "Close panel" } },
      { "n", "q", actions.toggle_files, { desc = "Close panel" } },

      -- { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
      { "n", "j", actions.next_entry, { desc = "diffview_ignore" } },
      { "n", "<down>", actions.next_entry, { desc = "diffview_ignore" } },
      { "n", "k", actions.prev_entry, { desc = "diffview_ignore" } },
      { "n", "<up>", actions.prev_entry, { desc = "diffview_ignore" } },
      { "n", "J", function()
        actions.next_entry()
        local line = vim.api.nvim_get_current_line()
        if not (line:find("") or line:find("")) then -- not toggle folder
          actions.select_entry()
        end
      end, { desc = "Go next file and open diff" } },
      { "n", "K", function()
        actions.prev_entry()
        local line = vim.api.nvim_get_current_line()
        if not (line:find("") or line:find("")) then
          actions.select_entry()
        end
      end, { desc = "Go previous file and open diff" } },

      { "n", "o", actions.select_entry, { desc = "Open diff" } },
      { "n", "<2-LeftMouse>", actions.select_entry, { desc = "diffview_ignore" } },
      { "n", "O", actions.focus_entry, { desc = "Open diff and jump" } },
      { "n", "<cr>", actions.focus_entry, { desc = "Open diff and jump" } },

      { "n", "<C-b>", actions.scroll_view( -0.2), { desc = "Scroll view up" } },
      { "n", "<C-f>", actions.scroll_view(0.2), { desc = "Scroll view down" } },

      { "n", "a", actions.toggle_stage_entry, { desc = "Stage / unstage file" } },
      { "n", "A", function()
        if vim.g.diffview_is_all_staged then
          actions.unstage_all()
          vim.g.diffview_is_all_staged = false
          vim.notify("Unstage all!")
        else
          actions.stage_all()
          vim.g.diffview_is_all_staged = true
          vim.notify("Stage all!")
        end
      end, { desc = "Stage / unstage all files" } },

      { "n", "U", actions.restore_entry, { desc = "Revert to verseion on left side" } },
      { "n", "l", actions.open_commit_log, { desc = "Open commit details" } },

      { "n", "<C-S-space>", actions.goto_file, { desc = "Close diffview and open file in split" } },
      { "n", "<C-space>", actions.goto_file_edit, { desc = "Close diffview and open file" } },

      { "n", "i", actions.listing_style, { desc = "Toggle listing style" } },
      { "n", "r", actions.refresh_files, { desc = "Refresh files" } },
      { "n", "\\", actions.cycle_layout, { desc = "Change view layout" } },
      { "n", "[x", actions.prev_conflict, { desc = "Go previous conflict" } },
      { "n", "]x", actions.next_conflict, { desc = "Go next conflict" } },
      { "n", "?", actions.help("file_panel"), { desc = "Open the help panel" } },
    },
    file_history_panel = {
      { "n", "<tab>", Util.focus_win, { desc = "diffview_ignore" } },
      { "n", "<esc>", actions.toggle_files, { desc = "Close panel" } },
      { "n", "q", actions.toggle_files, { desc = "Close panel" } },

      -- { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
      { "n", "j", actions.next_entry, { desc = "diffview_ignore" } },
      { "n", "<down>", actions.next_entry, { desc = "diffview_ignore" } },
      { "n", "k", actions.prev_entry, { desc = "diffview_ignore" } },
      { "n", "<up>", actions.prev_entry, { desc = "diffview_ignore" } },
      { "n", "J", function()
        actions.next_entry()
        local line = vim.api.nvim_get_current_line()
        if not (line:find("") or line:find("")) then
          actions.select_entry()
        end
      end, { desc = "Go next file and open diff" } },
      { "n", "K", function()
        actions.prev_entry()
        local line = vim.api.nvim_get_current_line()
        if not (line:find("") or line:find("")) then
          actions.select_entry()
        end
      end, { desc = "Go previous file and open diff" } },

      { "n", "o", actions.select_entry, { desc = "Open diff" } },
      { "n", "<2-LeftMouse>", actions.select_entry, { desc = "diffview_ignore" } },
      { "n", "<cr>", actions.focus_entry, { desc = "Open diff and jump" } },
      { "n", "<C-cr>", actions.open_in_diffview, { desc = "Open file in new diffview" } },

      { "n", "<C-b>", actions.scroll_view(-0.2), { desc = "Scroll view up" } },
      { "n", "<C-f>", actions.scroll_view(0.2), { desc = "Scroll view down" } },

      { "n", "!", actions.options, { desc = "Open the option panel" } },
      { "n", "y", actions.copy_hash, { desc = "Copy commit hash of entry" } },
      { "n", "l", actions.open_commit_log, { desc = "Show commit details" } },
      { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
      { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },

      { "n", "<C-S-space>", actions.goto_file, { desc = "Close diffview and open file in split" } },
      { "n", "<C-space>", actions.goto_file_edit, { desc = "Close diffview and open file" } },

      { "n", "\\", actions.cycle_layout, { desc = "Change view layout" } },
      { "n", "?", actions.help("file_history_panel"), { desc = "Open the help panel" } },
    },
    option_panel = {
      { "n", "<cr>", actions.select_entry, { desc = "Toggle or set option" } },
      { "n", "<esc>", actions.close, { desc = "Close panel" } },
      { "n", "q", actions.close, { desc = "Close panel" } },
      { "n", "!", actions.close, { desc = "Close panel" } },
      { "n", "?", actions.help("option_panel"), { desc = "diffview_ignore" } },
    },
    help_panel = {
      { "n", "q", actions.close, { desc = "Close help menu" } },
      { "n", "<esc>", actions.close, { desc = "Close help menu" } },
      { "n", "?", actions.close, { desc = "Close help menu" } },
      { "n", "\\", "<Nop>", { desc = "diffview_ignore" } },
    }
  }

  local presets = {
    { "n", "<C-o>", "<Nop>", { desc = "diffview_ignore" } },
    { "n", "<C-i>", "<Nop>", { desc = "diffview_ignore" } },
    { "n", "<C-[>", "<Nop>", { desc = "diffview_ignore" } },
    { "n", "<C-]>", "<Nop>", { desc = "diffview_ignore" } },
    { "n", "<C-g>", "<Nop>", { desc = "diffview_ignore" } },
    { "n", "<C-S-g>", "<Nop>", { desc = "diffview_ignore" } },
    { "n", "<leader>gd", "<Nop>", { desc = "diffview_ignore" } },
    { "n", "<leader>gD", "<Nop>", { desc = "diffview_ignore" } },
    { "n", "<leader>gh", "<Nop>", { desc = "diffview_ignore" } },
  }
  for _, v in pairs(keymaps) do
    if type(v) == "table" then
      for _, vv in pairs(presets) do
        table.insert(v, vv)
      end
    end
  end
  return keymaps
end

M.config = function()
  require("diffview").setup {
    enhanced_diff_hl = true,
    hooks = {
      view_leave = function(_)
        vim.cmd [[DiffviewClose]]
      end,
      diff_buf_read = function()
        vim.wo.signcolumn = "no"
      end
    },
    keymaps = get_keymaps(),
  }
end

return M
