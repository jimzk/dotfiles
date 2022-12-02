-- require_all loads all lua files under folder
local require_all = function(folder)
  for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config')..'/lua/' .. folder, [[v:val =~ '\.lua$']])) do
    require(folder .. "." .. file:gsub('%.lua$', ''))
  end
end

require("plugin")
require_all("plugin")
require("plugin.telescope")
require("plugin.lspconfig")
require("plugin.development")
require_all("keymap")
require("color")

--[[
 TODO:
- peek the method name where the cursor
- hightlight the usage of a variable in method
- show hierarchy of method call
- a good solution to search and replace text
  - can remember result or keep result window
- how to only search in screen?
- move to next parameter?
- Search git changed files

 NOTE:: plugin to-try list
- https://www.reddit.com/r/neovim/comments/z0tep4/whats_the_best_solution_to_searchreplace_text
- https://www.reddit.com/r/neovim/comments/z0yrku/nvimtreeclimber_structured_editing_movement_and/
- https://github.com/Shatur/neovim-session-manager
- https://github.com/ojroques/nvim-lspfuzzy
- use "vim-ctrlspace/vim-ctrlspace"  -- Manage tabs, buffers, files, workspace, bookmarks
- use "ctrlpvim/ctrlp.vim"
- use "tpope/vim-unimpaired"
- use "yazgoo/yank-history"
- use "tpope/vim-vinegar"
- https://github.com/dyng/ctrlsf.vim
- https://github.com/sindrets/diffview.nvim
- use "nvim-telescope/telescope-file-browser"
- use "nvim-telescope/telescope-github.nvim"  -- Manage github
- use "pwntester/octo.nvim"  -- Manage github
- https://github.com/ray-x
- https://github.com/jose-elias-alvarez/null-ls.nvim
- tpope
- simrat39/symbols-outline.nvim

Appearance
-  https://github.com/AckslD/nvim-neoclip.lua

Development
- https://github.com/simrat39/rust-tools.nvim/
- https://github.com/ray-x/navigator.lua
- https://github.com/kevinhwang91/nvim-bqf

Alternative
- https://www.reddit.com/r/neovim/comments/z3l5v0/glancenvim_a_pretty_window_for_previewing/

--]]
