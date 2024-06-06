local M = {
  "sindrets/diffview.nvim",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { "DiffviewOpen", "DiffviewToggleFiles" },
  keys = {
    {
      "<leader>gd",
      ":DiffviewFileHistory<cr>",
      desc = "Diff",
      mode = { "n", "x" },
    },
  },
}

-- TODO: https://www.reddit.com/r/neovim/comments/1b7cyhe/comment/kti5lbx
local get_keymaps = function()
  local actions = require("diffview.actions")
  local keymaps = {
    disable_defaults = false,
    view = {
      { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
      ["[x"] = false,
      ["]x"] = false,
      { "n", "[C", actions.prev_conflict, { desc = "In merge-tool: jump to previous conflict" } },
      { "n", "]C", actions.next_conflict, { desc = "In merge-tool: jump to next conflict" } },
    },
    diff1 = {
      ["g?"] = false,
      { "n", "?", actions.help({ "view", "diff1" }), { desc = "diffview_ignore" } },
    },
    diff2 = {
      ["g?"] = false,
      { "n", "?", actions.help({ "view", "diff2" }), { desc = "diffview_ignore" } },
    },
    diff3 = {
      ["g?"] = false,
      { "n", "?", actions.help({ "view", "diff3" }), { desc = "diffview_ignore" } },
    },
    diff4 = {
      ["g?"] = false,
      { "n", "?", actions.help({ "view", "diff4" }), { desc = "diffview_ignore" } },
    },
    file_panel = {
      { "n", "<esc>", actions.toggle_files, { desc = "Close panel" } },
      { "n", "q", actions.toggle_files, { desc = "Close panel" } },

      {
        "n",
        "J",
        function()
          actions.next_entry()
          local line = vim.api.nvim_get_current_line()
          if not (line:find("") or line:find("")) then -- not toggle folder
            actions.select_entry()
          end
        end,
        { desc = "Go next file and open diff" },
      },
      {
        "n",
        "K",
        function()
          actions.prev_entry()
          local line = vim.api.nvim_get_current_line()
          if not (line:find("") or line:find("")) then
            actions.select_entry()
          end
        end,
        { desc = "Go previous file and open diff" },
      },

      {
        "n",
        "A",
        function()
          if vim.g.diffview_is_all_staged then
            actions.unstage_all()
            vim.g.diffview_is_all_staged = false
            vim.notify("Unstage all!")
          else
            actions.stage_all()
            vim.g.diffview_is_all_staged = true
            vim.notify("Stage all!")
          end
        end,
        { desc = "Stage / unstage all files" },
      },

      ["[x"] = false,
      ["]x"] = false,
      { "n", "[x", actions.prev_conflict, { desc = "Go previous conflict" } },
      { "n", "]x", actions.next_conflict, { desc = "Go next conflict" } },

      ["g?"] = false,
      { "n", "?", actions.help("file_panel"), { desc = "Open the help panel" } },
    },
    file_history_panel = {
      -- { "n", "`", actions.toggle_files, { desc = "Close panel" } },
      { "n", "<esc>", actions.close, { desc = "Close panel" } },
      { "n", "q", actions.close, { desc = "Close panel" } },

      {
        "n",
        "J",
        function()
          actions.next_entry()
          local line = vim.api.nvim_get_current_line()
          if not (line:find("") or line:find("")) then
            actions.select_entry()
          end
        end,
        { desc = "Go next file and open diff" },
      },
      {
        "n",
        "K",
        function()
          actions.prev_entry()
          local line = vim.api.nvim_get_current_line()
          if not (line:find("") or line:find("")) then
            actions.select_entry()
          end
        end,
        { desc = "Go previous file and open diff" },
      },

      ["g?"] = false,
      { "n", "?", actions.help("file_history_panel"), { desc = "Open the help panel" } },
    },
    option_panel = {
      { "n", "<esc>", actions.close, { desc = "Close panel" } },
      { "n", "q", actions.close, { desc = "Close panel" } },
      ["g?"] = false,
      { "n", "?", actions.help("option_panel"), { desc = "diffview_ignore" } },
    },
    help_panel = {
      { "n", "<esc>", actions.close, { desc = "Close help menu" } },
      { "n", "q", actions.close, { desc = "Close help menu" } },
      ["g?"] = false,
      { "n", "?", actions.close, { desc = "Close help menu" } },
    },
  }

  -- local presets = {
  --   { "n", "<C-o>", "<Nop>", { desc = "diffview_ignore" } },
  --   { "n", "<C-i>", "<Nop>", { desc = "diffview_ignore" } },
  --   { "n", "<C-[>", "<Nop>", { desc = "diffview_ignore" } },
  --   { "n", "<C-]>", "<Nop>", { desc = "diffview_ignore" } },
  --   { "n", "<C-g>", "<Nop>", { desc = "diffview_ignore" } },
  --   { "n", "<C-M-g>", "<Nop>", { desc = "diffview_ignore" } },
  --   { "n", "<leader>gd", "<Nop>", { desc = "diffview_ignore" } },
  --   { "n", "<leader>gh", "<Nop>", { desc = "diffview_ignore" } },
  -- }
  -- for _, v in pairs(keymaps) do
  --   if type(v) == "table" then
  --     for _, vv in pairs(presets) do
  --       table.insert(v, vv)
  --     end
  --   end
  -- end
  return keymaps
end

M.config = function()
  require("diffview").setup({
    enhanced_diff_hl = true,
    hooks = {
      view_leave = function(_)
        vim.cmd([[DiffviewClose]])
      end,
      diff_buf_read = function()
        vim.wo.signcolumn = "no"
      end,
    },
    keymaps = get_keymaps(),
  })
end

return M
