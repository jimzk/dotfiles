local M = {
  "stevearc/aerial.nvim",
  event = "BufReadPost",
}

M.keys = function()
  local next_fn, prev_fn = require("util").make_repeatable_move_pair(function()
    vim.cmd("AerialNext")
  end, function()
    vim.cmd("AerialPrev")
  end)
  return {
    -- { "go", "m`<CMD>AerialToggle float<CR>", desc = "Symbols Popup (Aerial)" },
    {
      "<leader>yo",
      function()
        if vim.bo.ft == "aerial" then
          vim.cmd("q")
        else
          vim.cmd("AerialOpen right")
        end
      end,
      desc = "Symbols (Aerial)",
    },
    { "<leader>yy", "<CMD>AerialNavToggle<CR>", desc = "Navigate Symbols (Aerial)" },
    { "]y", next_fn, desc = "Next Symbol (Aerial)" },
    { "[y", prev_fn, desc = "Prev Symbol (Aerial)" },
  }
end

-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/aerial.lua
local filter_kind = {
  "Class",
  "Constructor",
  "Enum",
  "Function",
  "Interface",
  "Module",
  "Method",
  "Struct",
}

M.opts = function(_, opts)
  opts.filter_kind.rust = vim.deepcopy(opts.filter_kind._)
  table.insert(opts.filter_kind.rust, "Object")

  opts.layout.win_opts = {}
  opts = vim.tbl_deep_extend("force", opts or {}, {
    layout = {
      resize_to_content = false,
      max_width = { 80, 0.6 },
      min_width = 40,
    },
    highlight_mode = "split_width",
    highlight_on_hover = true,
    highlight_on_jump = false,
    show_guides = false,
    autojump = false,
    -- post_jump_cmd = false,
    keymaps = {
      ["g?"] = false,
      ["<esc>"] = "actions.close",
      ["i"] = "actions.scroll",
      -- ["<M-k>"] = "actions.prev",
      -- ["<M-j>"] = "actions.next",

      ["<C-k>"] = false,
      ["<C-j>"] = false,
      ["J"] = "actions.down_and_scroll",
      ["K"] = "actions.up_and_scroll",
    },
    float = {
      relative = "cursor", -- cursor, editor, win
      -- ISSUE: override not work
    },
    nav = {
      min_height = { 10, 0.5 },
      preview = false,
      keymaps = {
        ["<Space>"] = "actions.jump",
        ["<Esc>"] = "actions.close",
      },
    },
  })
  return opts
end

M.config = function(_, opts)
  require("aerial").setup(opts)
  -- Highlight on hover
  vim.cmd("hi! AerialLine gui=bold")
  vim.cmd("hi! link AerialLine QuickFixLine")
  require("telescope").load_extension("aerial")
end

return M
