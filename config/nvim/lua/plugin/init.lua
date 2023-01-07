local require = function(filename)
  local module_name = "plugin." .. filename
  local ok, modula = pcall(require, module_name)
  if ok then
    return modula
  else
    vim.notify("Can't load module " .. module_name,
      vim.log.levels.ERROR,
      { title = "Configuration", }
    )
  end
end

require("autopairs")
require("barbar")
require("diffview")
require("fugitive")
require("fzf")
require("gitsigns")
require("harpoon")
require("indent-blankline")
require("lualine")
require("marks")
require("matchup")
require("mini")
require("nvim-tree")
require("spectre")
require("startify")
require("toggleterm")
require("undotree")
require("which-key")

require("telescope")
require("lsp")
require("development")
require("search")
