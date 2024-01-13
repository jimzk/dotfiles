-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L300
local M = {
  "folke/which-key.nvim",
}

M.opts = function()
  return {
    plugins = {
      marks = false,
      briefmarks = true,
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
    ["g"] = { name = "+goto" },
    ["]"] = { name = "+next" },
    ["["] = { name = "+prev" },
    -- ["<leader><tab>"] = { name = "+tabs" },
    ["<C-t>"] = { name = "+tab" },
    ["<C-b>"] = { name = "+buffer" },
    ["<leader>"] = { name = "+leader" },
    ["<leader>c"] = { name = "+code" },
    ["<leader>f"] = { name = "+file" },
    ["<leader>g"] = { name = "+git" },
    ["<leader>h"] = { name = "+file operation" },
    ["<leader>d"] = { name = "+diagnostic" },
    -- ["<leader>gh"] = { name = "+hunks" },
    -- ["<leader>q"] = { name = "+quit/session" },
    -- ["<leader>u"] = { name = "+ui" },
    ["<leader>o"] = { name = "+toggle option" },
    ["<leader>m"] = { name = "+quickfix/trouble" },
    ["<leader>s"] = { name = "+test/debug" },
    ["<leader>i"] = { name = "+symbols" },
    ["<leader>p"] = { name = "+session" },
    ["<leader>r"] = { name = "+replace/search" },
    ["<leader>n"] = { name = "+nvim config" },
    ["<leader>x"] = {
      name = ignored,
      l = ignored,
      q = ignored,
    },

    ["{"] = "Prev Blank Line",
    ["}"] = "Next Blank Line",
    ["<C-Left>"] = "Decrease Window Width (←↑→↓)",

    -- <M-t>: alternative tab
    -- <M-b>: alternative buffer
    -- <M-w>: alternative win
    --
    -- <M-r>: Ranger
    -- <M-o>/<M-O>: Oil
    -- <M-space>: locate file in neo-tree
    --
    -- <M-Esc>: go parent context
    -- _/+: go prev/next unmatch synatx
    -- <M-i>: navbuddy
    -- <M-m>: list all marks (bookmarks.nvim)
    -- <C-;>/<C-,>: next/prev mark (marks.nvim)
    --
    -- <M-s>: signature
    -- <M-y>: gp (ChatGPT)
    -- <M-g>/<M-G>: lazyGit
  }, {})

  vim.defer_fn(function()
    -- stylua: ignore
    local ignored_keys = {
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
      "<C-e>", "<C-y>", "<C-d>", "<C-u>", "<C-u>", "<C-u>",
      "w", "b", "e", "ge", "f", "F", "h", "j", "k", "l", "V", "G", "U", "Y", "<C-Y>", "^", "$", "t", "T",
      ",", ";",
      "<C-Right>", "<C-Up>", "<C-Down>",
    }
    for _, key in ipairs(ignored_keys) do
      wk.register({ [key] = { desc = ignored }, mode = { "n", "x", "o" } })
    end
  end, 1000)

  require("plugins.editor.which-key.presets")
end

return M
