-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/coding.lua#L133
return {
  "echasnovski/mini.surround",
  opts = {
    mappings = {
      add = "sa", -- Add surrounding in Normal and Visual modes
      delete = "sd", -- Delete surrounding
      replace = "sr", -- Replace surrounding
      update_n_lines = "", -- Update `n_lines`
      find = "sf", -- Find surrounding (to the right)
      find_left = "sF", -- Find surrounding (to the left)
      highlight = "", -- Highlight surrounding
      suffix_last = "", -- Suffix to search with "prev" method
      suffix_next = "", -- Suffix to search with "next" method
    },
    n_lines = 40,
  },
  init = function()
    require("which-key").register({ ["s"] = { name = "+surrounding" } })
  end,
}
