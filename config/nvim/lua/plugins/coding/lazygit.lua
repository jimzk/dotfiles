local key = "<M-g>"
return {
  -- Allow you to edit (c) and commit (C) in current nvim instance
  -- * https://www.reddit.com/r/neovim/comments/1aox1us/things_im_still_using_vs_code_for
  "kdheepak/lazygit.nvim",
  event = "VeryLazy",
  enabled = true,
  keys = {
    { key, "<CMD>LazyGit<CR>", desc = "LazyGit" },
    { "<leader>gf", "<CMD>LazyGitFilter<CR>", desc = "Current Repo Commits (LazyGit)" },
    -- { "<leader>g<C-l>", "<CMD>LazyGitConfig<CR>", desc = "LazyGit Configuration" },
    -- { "<leader>gL", "<CMD>Telescope lazygit<CR>", desc = "All LazyGit" },
  },
  init = function()
    vim.cmd([[
    if has('nvim') && executable('nvr')
      let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
    endif
    ]])
  end,
  config = function()
    vim.g.lazygit_floating_window_winblend = 0
    -- Fix "is not a valid git repository".
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lazygit" },
      callback = function()
        local map = Util.map
        map("t", key, "<C-\\><C-n><CMD>hide<CR>", "Close LazyGit")
        -- local repo_root = require("lazygit.utils").project_root_dir()
        -- vim.cmd("lcd" .. repo_root)
      end,
    })

    require("telescope").load_extension("lazygit")
  end,
}
