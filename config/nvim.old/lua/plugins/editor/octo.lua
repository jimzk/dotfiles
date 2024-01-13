return {
  -- Smooth GitHub PR review experience
  "pwntester/octo.nvim",
  event = "VeryLazy",
  -- In PR telescope (Octo pr list):
  -- * <C-b> to open in browser
  -- * <C-o> to checkout PR
  -- * <C-y> to copy PR url
  -- keys = {
  --   { "<leader>gp", "<cmd>Oct pr list<cr>", desc = "review PR" },
  -- },
  init = function()
    map("n", "<leader>gP", "<cmd>Octo pr list<cr>", "review PR (octo)")
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "octo", -- PR panel
      callback = function(options)
        local opts = { buffer = options.buf }
        map("n", "r", "<cmd>Octo review resume<cr>", "review PR", opts)
        -- map("n", "R", "<cmd>Octo review start<cr>", "review PR", opts)
      end,
    })
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      -- octo://pwntester/octo.nvim/review/PRR_kwDOEdDlnM5MUEy8/file/LEFT/README.md
      pattern = {
        "*octo.nvim/review/*", -- diff in review mode
        "*octo.nvim/OctoChangedFiles*", -- file panel in review mode
      },
      callback = function(options)
        local opts = { buffer = options.buf }
        map("n", "q", "<cmd>Octo review close<cr>", "close review", opts)
      end,
    })
  end,
  opts = {
    mappings = {
      pull_request = {
        list_commits = { lhs = "L", desc = "list PR commits" },
        list_changed_files = { lhs = "F", desc = "list PR changed files" },
        open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
      },
      review_diff = {
        add_review_comment = { lhs = "a", desc = "add a new review comment" },
        add_review_suggestion = { lhs = "A", desc = "add a new review suggestion" },
        select_prev_entry = { lhs = "{", desc = "move to next changed file" },
        select_next_entry = { lhs = "}", desc = "move to previous changed file" },
      },
      file_panel = {
        select_prev_entry = { lhs = "{", desc = "move to next changed file" },
        select_next_entry = { lhs = "}", desc = "move to previous changed file" },
      },
    },
  }
}
