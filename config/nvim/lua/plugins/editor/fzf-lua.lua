local M = {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  enabled = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim", -- override telescope keys
  },
}
M.keys = {
  -- { "<leader>gf", "<cmd>FzfLua git_bcommits<CR>", desc = "Show Git File Commit (FZF)" },
  -- { "<leader>gF", "<cmd>FzfLua git_commits<CR>", desc = "Show Git Commit (FZF)" },
  -- { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Show Git Status (FZF)" },
  -- { "<leader>gh", "<cmd>FzfLua git_stash<CR>", desc = "Show Git Stash (FZF)" },
  -- { "<leader>gr", "<cmd>FzfLua git_branches<CR>", desc = "Show Git Branch (FZF)" },
  -- Jumps/Location
  { "<leader>q<C-j>", "<cmd>FzfLua jumps<CR>", desc = "List jumps (FZF)" },
  { "<leader>q<C-t>", "<cmd>FzfLua tagstack<CR>", desc = "List tagstack (FZF)" },
  { "<leader>q<C-g>", "<cmd>FzfLua changes<CR>", desc = "List changes (FZF)" },
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
      ["<M-j>"] = "preview-page-down",
      ["<M-k>"] = "preview-page-up",

      ["<C-M-n>"] = "half-page-down",
      ["<C-M-p>"] = "half-page-up",
    },
    fzf = {
      ["ctrl-z"] = "abort",
      ["ctrl-u"] = "unix-line-discard",
      ["ctrl-a"] = "beginning-of-line",
      ["ctrl-e"] = "end-of-line",
      -- ["alt-a"] = "toggle-all",

      -- Only valid with fzf previewers (bat/cat/git/etc)
      ["f3"] = "toggle-preview-wrap",
      ["f4"] = "toggle-preview",

      ["alt-j"] = "preview-page-down",
      ["alt-k"] = "preview-page-up",

      ["ctrl-alt-n"] = "half-page-down",
      ["ctrl-alt-p"] = "half-page-up",
    },
  },
}

M.config = function(_, opts)
  require("fzf-lua").setup(opts)
end

return M
