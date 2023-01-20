return { "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-rhubarb" -- Support :Browse of fugitive
  },
  event = "VeryLazy",
  cmd = { "Git", "GBrowse" },
  init = function()
    local help_tags = {
      ["fugitiveblame"] = "Git_blame",
      ["fugitive"] = "fugitive-map",
    }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'fugitiveblame', "fugitive" },
      callback = function()
        local cmd = string.format("<cmd>h %s<cr>", help_tags[vim.bo.filetype])
        vim.keymap.set("n", "?", cmd, { buffer = true, silent = true })
      end
    })
  end
}
