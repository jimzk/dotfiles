local M = {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim", -- override telescope keys
  },
}
M.keys = {
  { "<leader>gm", "<cmd>FzfLua git_bcommits<CR>", desc = "Git File Commit (FZF)" },
  { "<leader>gM", "<cmd>FzfLua git_commits<CR>", desc = "Git Commit (FZF)" },
  { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Git Status (FZF)" },
  { "<leader>gS", "<cmd>FzfLua git_stash<CR>", desc = "Git Stash (FZF)" },
  { "<leader>gh", "<cmd>FzfLua git_branches<CR>", desc = "Git Branch (FZF)" },
  -- Jumps/Location
  { "m<C-j>", "<cmd>FzfLua jumps<CR>", desc = "List jumps (FZF)" },
  { "m<C-t>", "<cmd>FzfLua tagstack<CR>", desc = "List tagstack (FZF)" },
  { "m<C-g>", "<cmd>FzfLua changes<CR>", desc = "List changes (FZF)" },
}

M.opts = {
  keymap = {
    -- I can't figure out how the mapping works. Seems both builtin and fzf fields should map the same keys.
    builtin = {
      ["<F1>"] = "toggle-help",
      ["<F2>"] = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"] = "toggle-preview-wrap",
      ["<F4>"] = "toggle-preview",
      -- Rotate preview clockwise/counter-clockwise
      ["<F5>"] = "toggle-preview-ccw",
      ["<F6>"] = "toggle-preview-cw",

      -- ["<S-left>"] = "preview-page-reset",
      ["<M-f>"] = "preview-page-down",
      ["<M-b>"] = "preview-page-up",

      ["<C-M-n>"] = "half-page-down",
      ["<C-M-p>"] = "half-page-up",
    },
    fzf = {
      ["ctrl-z"] = "abort",
      ["ctrl-u"] = "unix-line-discard",
      ["ctrl-a"] = "beginning-of-line",
      ["ctrl-e"] = "end-of-line",
      ["alt-a"] = "toggle-all",

      -- Only valid with fzf previewers (bat/cat/git/etc)
      ["f3"] = "toggle-preview-wrap",
      ["f4"] = "toggle-preview",

      ["alt-f"] = "preview-page-down",
      ["alt-b"] = "preview-page-up",

      ["ctrl-alt-n"] = "half-page-down",
      ["ctrl-alt-p"] = "half-page-up",
    },
  },
}

M.config = function(_, opts)
  require("fzf-lua").setup(opts)
end

return M
