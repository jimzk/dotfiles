-- better vim.ui
return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  init = function()
    --- @diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    --- @diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
  opts = {
    input = {
      get_config = function(opts)
        -- possession.nvim
        if opts.prompt == "New session name: " then
          return {
            relative = 'win'
          }
        end
      end,
      win_options = {
        winblend = 0,
      },
    },
    select = {
      backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
      telescope = require("telescope.themes").get_cursor({
        prompt_prefix = " ",
        initial_mode = "normal",
      }),
      builtin = {
        max_width = { 150, 0.9 },
        min_width = { 50, 0.25 },
        height = nil,
      },
    },
  },
}
