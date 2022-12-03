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
require("appearance")
require("editor")

--[[ NOTE
## Recommended material
- https://github.com/nanotee/nvim-lua-guide

## Troubleshotting
[Inspect]
- `:lua =obj` prints deatils of lua obj, e.g. `vim` or `vim.o.ruler`.
  - `:lua print(vim.inspect(obj))` and `:lua vim.pretty_print(obj)` have same effect.
  - `:set ruler?` shows value of option.
  - `:echo g:undotree_CursorLin` shows value of global variable.
- `:verbose map <keymap>` shows details of keymap
- `:call g:undotree#UndotreeFocus()` calls vim script function.
[Plugin conflict]
- `:checkhealth` checks status of plugins and nvim
- `:scriptnames` shows loading order of configuration files
- `:h load-plugins` see help about loading order.
[Startup time]
- `nvim --startuptime time.txt` shows startup time
- `:LuaCacheProfile` shows startup time provided by lewis6991/impatient.nvim

## Where to find plugins
- https://github.com/rockerBOO/awesome-neovim
- https://neoland.dev/
- https://neovimcraft.com/

--]]

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
- https://github.com/ojroques/nvim-lspfuzzy
- use "vim-ctrlspace/vim-ctrlspace"  -- Manage tabs, buffers, files, workspace, bookmarks
- use "ctrlpvim/ctrlp.vim"
- use "yazgoo/yank-history"
- use "tpope/vim-vinegar"
- https://github.com/sindrets/diffview.nvim
- use "nvim-telescope/telescope-file-browser"
- use "nvim-telescope/telescope-github.nvim"  -- Manage github
- use "pwntester/octo.nvim"  -- Manage github
- https://github.com/ray-x
- https://github.com/jose-elias-alvarez/null-ls.nvim
  - https://github.com/lewis6991/gitsigns.nvim#null-ls
- tpope
- [x] junegunn
- simrat39/symbols-outline.nvim
- https://github.com/junegunn/gv.vim
- https://github.com/dense-analysis/ale
- skywind3000/asyncrun.vim/blob/master/README-cn.md
- utilyre/barbecue.nvim
- weilbith/nvim-code-action-menu

Appearance
-  https://github.com/AckslD/nvim-neoclip.lua

Development
- https://github.com/simrat39/rust-tools.nvim/
- https://github.com/ray-x/navigator.lua
- https://github.com/kevinhwang91/nvim-bqf

Alternative
- https://www.reddit.com/r/neovim/comments/z3l5v0/glancenvim_a_pretty_window_for_previewing/

--]]
