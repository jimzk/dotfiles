return {
  -- Allow you to edit (c) and commit (C) in current nvim instance
  -- * https://www.reddit.com/r/neovim/comments/1aox1us/things_im_still_using_vs_code_for
  "kdheepak/lazygit.nvim",
  event = "VeryLazy",
  enabled = false,
  keys = {
    { "<M-g>", "<CMD>LazyGit<CR>", desc = "LazyGit" },
    { mode = "t", "<M-g>", "<C-\\><C-n><CMD>hide<CR>", desc = "Close LazyGit" },
    { "<M-S-g>", "<CMD>LazyGitFilter<CR>", desc = "LazyGit Commits" },
    -- { "<leader>g<C-l>", "<CMD>LazyGitConfig<CR>", desc = "LazyGit Configuration" },
    -- { "<leader>gL", "<CMD>Telescope lazygit<CR>", desc = "All LazyGit" },
  },
  config = function()
    vim.g.lazygit_floating_window_winblend = 0
    vim.cmd([[
      if has('nvim') && executable('nvr')
        let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
      endif
    ]])

    -- Fix "is not a valid git repository".
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lazygit" },
      callback = function()
        local repo_root = require("lazygit.utils").project_root_dir()
        vim.cmd("lcd" .. repo_root)
      end,
    })

    require("telescope").load_extension("lazygit")
  end,
}
