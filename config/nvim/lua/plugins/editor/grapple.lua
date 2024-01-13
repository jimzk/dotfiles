return {
  -- A harpoon-like file management
  -- Ref:
  --   - https://www.reddit.com/r/neovim/comments/1bg73sv/grapplenvim_100_commits_and_10_point_releases/
  "cbochs/grapple.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = true,
  event = "VeryLazy",
  keys = {
    {
      "<C-b>p",
      function()
        require("grapple").toggle()
        require("lualine").refresh({ scope = "tabpage" })
      end,
      desc = "Pin File in Tabline (Grapple)",
    },
    -- { "<C-b>l", "<CMD>Grapple toggle_tags<CR>", desc = "File List (Grapple)" },
    { "<C-c>", "<CMD>Grapple open_tags<CR>", desc = "File List (Grapple)" },
    { "-", "<CMD>Grapple cycle_backward<CR>", desc = "Prev File (Grapple)" },
    { "=", "<CMD>Grapple cycle_forward<CR>", desc = "Next File (Grapple)" },

    { "<M-1>", "<CMD>Grapple select index=1<CR>", desc = "Navigate File 1 (Grapple)" },
    { "<M-2>", "<CMD>Grapple select index=2<CR>", desc = "which_key_ignore" },
    { "<M-3>", "<CMD>Grapple select index=3<CR>", desc = "which_key_ignore" },
    { "<M-4>", "<CMD>Grapple select index=4<CR>", desc = "which_key_ignore" },
    { "<M-5>", "<CMD>Grapple select index=5<CR>", desc = "which_key_ignore" },
    { "<M-6>", "<CMD>Grapple select index=6<CR>", desc = "which_key_ignore" },
    { "<M-7>", "<CMD>Grapple select index=7<CR>", desc = "which_key_ignore" },
    { "<M-8>", "<CMD>Grapple select index=8<CR>", desc = "which_key_ignore" },
    { "<M-9>", "<CMD>Grapple select index=9<CR>", desc = "which_key_ignore" },
  },
  opts = {
    style = "basename",
  },
  config = function(_, opts)
    require("grapple").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "grapple" },
      callback = function(opts)
        vim.defer_fn(function()
          vim.wo.cursorline = true
        end, 0)
      end,
    })
  end,
}
