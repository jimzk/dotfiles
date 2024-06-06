-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L300
local M = {
  "folke/which-key.nvim",
}

M.opts = function()
  return {
    plugins = {
      marks = false,
      briefmarks = false, -- my which-key plugins
      spelling = true,
      presets = {
        -- text_objects = false,
        -- operators = false,
        -- motions = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
  }
end

M.config = function(_, opts)
  local wk = require("which-key")
  wk.setup(opts)

  local ignored = "which_key_ignore"
  wk.register({
    mode = { "n", "v" },
    ["g"] = { mode = { "n", "o" }, name = "+goto" },
    ["s"] = { mode = { "n", "x" }, name = "+misc" },
    ["]"] = { mode = { "n", "o" }, name = "+next" },
    ["["] = { mode = { "n", "o" }, name = "+prev" },
    -- ["<leader><tab>"] = { name = "+tabs" },
    ["<C-t>"] = { name = "+tab" },
    ["<C-r>"] = { name = "+neo-tree" },
    ["<leader>"] = { name = "+leader" },
    ["<leader>c"] = { name = "+code" },
    ["<leader>f"] = { name = "+file" },
    ["<leader>g"] = {
      name = "+git",
      g = {
        name = "git status",
      },
    },
    ["<leader>h"] = { name = "+file operation" },
    ["<leader>d"] = { name = "+diagnostic/todos" },
    -- ["<leader>q"] = { name = "+quit/session" },
    -- ["<leader>u"] = { name = "+ui" },
    ["<leader>o"] = { name = "+toggle option" },
    ["<leader>q"] = { name = "+quickfix/trouble" },
    ["<leader>e"] = { name = "+debug" },
    ["<leader>r"] = { name = "+refactor" },
    ["<leader>t"] = { name = "+test/run" },
    ["<leader>i"] = { name = "+symbols" },
    ["<leader>p"] = { name = "+session" },
    ["<leader>s"] = { name = "+search/replace" },
    ["<leader>n"] = { name = "+nvim config" },
    ["<leader>x"] = {
      name = ignored,
      l = ignored,
      q = ignored,
    },

    ["{"] = "Prev Blank Line",
    ["}"] = "Next Blank Line",
    ["<C-Left>"] = "Decrease Window Width (←↑→↓)",
  }, {})

  vim.defer_fn(function()
    -- stylua: ignore
    local ignored_keys = {
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
      "<C-e>", "<C-y>", "<C-d>", "<C-u>", "<C-u>", "<C-u>",
      "w", "b", "e", "ge", "f", "F", "h", "j", "k", "l", "V", "G", "U", "Y", "<C-Y>", "^", "$", "t", "T", "c", "d", "y",
      "gg",
      ",", ";",
      "<C-Right>", "<C-Up>", "<C-Down>",
    }
    for _, key in ipairs(ignored_keys) do
      wk.register({ [key] = { desc = ignored }, mode = { "n", "x", "o" } })
    end
  end, 1000)

  require("plugins.editor.which-key.presets")

  -- Get back to original poistion from visual mode
  -- Use case: after vib to select and <esc> to cancel the visual, <C-o> can jump back
  local map = Util.map
  map("n", "v", "m`v")
  map("n", "vv", "m`v$o")
  map("n", "V", "m`V")
  map("n", "<C-V>", "m`<C-V>")
  -- Use ` to compatible with treesitter incremental_selection which marks v continusouly
  map("n", "gv", "m`gv")
end

return M
