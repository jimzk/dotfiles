-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
local telescope = require("telescope")
telescope.setup {
  extensions = {
    auto_quoting = true,
    -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim/issues/40
    live_grep_args = {
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.4,
        width = 140
      },
      mappings = {
        i = {
          ["<C-r>"] = require("telescope-live-grep-args.actions").quote_prompt(),
          ["<C-g>"] = require("telescope-live-grep-args.actions").quote_prompt( { postfix = " --iglob " } )
        }
      },
      wrap_results = false,
      results_title = "|search: ^r(by file name) ^g(by regex name)"
    }
  }
}
telescope.load_extension("live_grep_args")
