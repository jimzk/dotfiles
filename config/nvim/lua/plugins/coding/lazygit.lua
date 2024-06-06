local key = "<M-g>"
return {
  -- Allow you to edit (c) and commit (C) in current nvim instance
  -- * https://www.reddit.com/r/neovim/comments/1aox1us/things_im_still_using_vs_code_for
  -- "kdheepak/lazygit.nvim",
  "jimzk/lazygit.nvim",
  event = "VeryLazy",
  enabled = true,
  keys = {
    { key, "<CMD>LazyGit<CR>", desc = "LazyGit" },
    {
      "<leader>gf",
      function()
        local git_path = vim.api.nvim_buf_get_name(0)
        require("lazygit").lazygitfilter(git_path)
      end,
      desc = "File Commits (Lazygit)",
    },
    { "<leader>gl", "<CMD>LazyGitFilter<CR>", desc = "Git Log (Lazygit)" },
    { "<leader>gB", LazyVim.lazygit.blame_line, desc = "Git Blame Line (LazyGit)" },

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
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lazygit" },
      callback = function(opts)
        local map = Util.map
        map("t", key, "<C-\\><C-n><CMD>hide<CR>", "Close LazyGit", { buffer = opts.buf })
        -- local repo_root = require("lazygit.utils").project_root_dir()
        -- vim.cmd("lcd" .. repo_root)
      end,
    })

    require("telescope").load_extension("lazygit")
  end,
}
