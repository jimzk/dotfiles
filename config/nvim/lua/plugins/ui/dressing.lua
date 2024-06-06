return {
  "stevearc/dressing.nvim",
  opts = {
    input = {
      start_in_insert = true,
    },
    select = {
      get_config = function(opts)
        if opts.kind == "codeaction" then
          return {
            backend = "telescope",
            telescope = require("telescope.themes").get_dropdown({
              layout_config = {
                width = { 0.8, min = 50, max = 140 },
              },
            }),
          }
        end
      end,
    },
  },
}
