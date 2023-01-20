-- Templates of this configuration comes from: https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/plugins.lua
local fn = vim.fn

-- Automatically install packer
-- default location: ~/.local/share/site/pack/packer/start/
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Fix "too many files" when using :PackerUpdate and :PackerSync
vim.fn.system("ulimit -S -n 200048")

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  -- The compiled file from Packer should be loaded by vim automatically, OR setup and config fail to work.
  -- See :h 'runtimepath' for more.
  -- default value: stdpath("config") .. "/site/plugin/packer_compiled.lua"
  compile_path = fn.stdpath("data") .. "/site/plugin/packer_compiled.lua",
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

local plugins = function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself
  ------ Cheatsheet
  use "folke/which-key.nvim"  -- Display popup of keymap hint (together with keybinding)
                              -- :checkhealth which_key checks conflicting keymaps.
                              -- :WhichKey shows all mapping, :WhichKey <leader>g shows all <leader>g mapping
                              -- In popup, <backspace> go up one level, <c-d> and <c-u> scroll page.
  ------ Fuzzy search
  use {
    "nvim-telescope/telescope.nvim",  -- Fuzzy search
    tag = '0.1.0',
    requires = "nvim-lua/plenary.nvim"
  }
  use {
    "nvim-telescope/telescope-fzf-native.nvim",  -- Support fzf-like syntax in telescope searching
    run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
  }
  use {
    "nvim-telescope/telescope-frecency.nvim",  -- Smater algorithms to sort history files
    requires = {"kkharji/sqlite.lua"},
  }
  use "nvim-telescope/telescope-project.nvim"         -- Quick access projects
  -- Among fuzzy search plugins Telescope.
  -- fzf.vim is hard to extend.
  -- Telescope's seach and git is not perfect and need time to configure
  -- Finally I choose fzf-lua.
  use "ibhagwan/fzf-lua"
  use "ThePrimeagen/harpoon" -- Mark and find files

  ------ Navigation
  use {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "rcarriga/nvim-notify",  -- More elegant notification
      { "nvim-tree/nvim-web-devicons", opt = true } -- More beautiful icons
    },
    -- cmd = { "NvimTreeToggle", "NvimTreeFocus" },  -- Load plugin when first invoking these commands
  }
  use "chentoast/marks.nvim"  -- Visualiaze marks

  ------- Jump & text objects
  use "bkad/CamelCaseMotion" -- Camel case text object
  use 'echasnovski/mini.nvim' -- Use: mini.ai, mini.indentscope
  use "kana/vim-textobj-user"      -- Dependency of vim-textobj-*
  use "kana/vim-textobj-entire"    -- ae, ie select entire content
  use "kana/vim-textobj-line"      -- al, il select entire line
  use "glts/vim-textobj-indblock"  -- ao, io, aO, iO select indent
  use "ggandor/leap.nvim" -- Jump to anywhere

  ------ Edit
  use {
    "mg979/vim-visual-multi",  -- Multi selection in visual block mode (ctrl-v)
    config = function()        -- All operations only work in visual block mode.
      -- Help: :h vm-highlight
      vim.g.VM_Mono_hl = 'Cursor' -- All cursors
      vim.g.VM_Cursor_hl = 'Cursor' -- Cursor in selection
      vim.g.VM_Extend_hl = 'Visual' -- Selected items in selection
      -- vim.g.VM_Insert_hl = 'IncSearch' -- Multi insert place atfer selection
      set("n", "<M-j>", "<Plug>(VM-Add-Cursor-Down)")
      set("n", "<M-k>", "<Plug>(VM-Add-Cursor-Up)")
      vim.g.VM_leader = ",,"
    end
  }
  use {
    "tpope/vim-commentary",  -- gcc toggles comment, gcu uncomments.
    keys = {"gc"}  -- Load plugins when first pressing gc
  }
  use {
    "tommcdo/vim-exchange", -- Exchange two selections
    config = function()
      vim.g.exchange_no_mappings = true
      vim.keymap.set({ "n", "x" }, "X", "<Plug>(Exchange)", { silent = true, noremap = true, desc = "exchange" })
      vim.keymap.set("n", "Xc", "<Plug>(ExchangeClear)", { silent = true, noremap = true, desc = "exchange clear" })
      vim.keymap.set("n", "XX", "<Plug>(ExchangeLine)", { silent = true, noremap = true, desc = "exchange line" })
    end
  }
  use {
    "AndrewRadev/splitjoin.vim",   -- gS expand (split) and gJ shrink (join) line by language grammar.
                                   -- Only work in normal mode
    setup = function()
      vim.g.splitjoin_join_mapping = 'J'
      -- I don't want K fallback
      vim.g.splitjoin_split_mapping = ''
      set("n", "K", "<cmd>SplitjoinSplit<cr>")
    end,
  }
  use "kylechui/nvim-surround" -- surrounding operations. More customizable than vim-surround and mini.surround
  use "windwp/nvim-autopairs"  -- Auto insert/delete bracket or quotes in pair
                               -- <M-e>: wrap next content (fast wrap)

  ------ Editor
  use "nvim-pack/nvim-spectre" -- Search and replace text
  use "tpope/vim-sleuth"  -- Auto detect indent width in file
  use "mbbill/undotree"  -- Undo history
  use { "akinsho/toggleterm.nvim", tag = '*', } -- Toggle terminal
  use "moll/vim-bbye" -- Delete buffer without messing up layout (:bdelete enhancement).
  -- use "mhinz/vim-startify"    -- Startup page
  use "stevearc/resession.nvim"
  use "andymass/vim-matchup"  -- Enhance matchit (%)
  use {
    "Pocco81/auto-save.nvim", -- Save file automatically
    config = function()
      require("auto-save").setup {
        trigger_events = { "InsertLeave" }, -- Event TextChanged breaks up autopair <CR>
      }
    end
  }
  -- TODO: https://github.com/smjonas/inc-rename.nvim
  use 'stevearc/dressing.nvim'  -- Beautify vim.ui.select and vim.ui.input
  use "gbprod/yanky.nvim"  -- Enhance y and p
  use {
    'kevinhwang91/nvim-ufo', -- Fold
    requires = 'kevinhwang91/promise-async',
  }

  ------ Git
  use "tpope/vim-fugitive"  -- Integrate git commands
  use "tpope/vim-rhubarb"   -- Support :Browse of fugitive
  use "lewis6991/gitsigns.nvim"  -- Git changes visualization. :Gitsigns toggle<Tab> to toggle signs.
                                 -- :Gitsigns diffthis diffs buffers.
                                 -- There are also useful operations for hunk.
  -- use "junegunn/gv.vim"
  use {
    "sindrets/diffview.nvim",  -- Git diff enhancement
    requires = 'nvim-lua/plenary.nvim'
  }

  ------ Development
  use "neovim/nvim-lspconfig"              -- Neovim LSP support
  use "williamboman/mason.nvim"            -- Manage LSP servers, DAP servers, linters, and formatters
  use "williamboman/mason-lspconfig.nvim"  -- Automatically install LSP servers
  use "stevearc/aerial.nvim"               -- More clean and effective than lsp and symbols-outline
  use "glepnir/lspsaga.nvim"               -- Beautify lsp popup (hover, reference, definition and etc.)
  use  'rmagatti/goto-preview'             -- Preview lsp definition, reference, implements etc.
  use {
    "RRethy/vim-illuminate",              -- Highlight usage of variable under cursor
    config = function()
      vim.cmd[[au ColorScheme * hi! IlluminatedWordText gui=underline]]
      vim.cmd[[au ColorScheme * hi! IlluminatedWordRead gui=underline]]
      vim.cmd[[au ColorScheme * hi! IlluminatedWordWrite gui=underline]]
    end
  }
  use {
    "folke/trouble.nvim",  -- Show lsp reference/implements/definition and diagnostics in location list and
    requires = "kyazdani42/nvim-web-devicons",
  }
  use 'kevinhwang91/nvim-bqf' -- Better quick fix
  use {
    "folke/todo-comments.nvim",  -- highlight TODO,NOTE,FIX
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        signs = false,
      }
    end
  }
  use {
    "nvim-treesitter/nvim-treesitter",  -- Syntax highlight
    run = ":TSUpdate"                   -- :TSInstall <language> to install parser
  }                                     -- :TSUpdate to update parser
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",  -- Enhance text object to select/move/swap function, class
    requires = "nvim-treesitter/nvim-treesitter"
  }
  use {
    "nvim-treesitter/nvim-treesitter-context",      -- Show function context in first line
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.cmd [[au ColorScheme * hi! link TreesitterContext Normal]]
      vim.cmd [[au ColorScheme * hi! link TreesitterContextButton Normal]]
      vim.cmd [[au ColorScheme * hi TreesitterContext gui=bold]]
      vim.cmd [[au ColorScheme * hi TreesitterContextLineNumber gui=bold]]
    end
  }
  use "nvim-treesitter/playground"

  ----- Status line & Winbar
  use {
    "nvim-lualine/lualine.nvim",  -- Statusline and winbar
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use {
    "utilyre/barbecue.nvim", -- VSCode like winbar
    requires = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
    },
    after = "nvim-web-devicons",
    config = function()
      require("barbecue").setup {
        include_buftypes = { "", "acwrite", "help", "quickfix", "notwrite" }
      }
    end,
  }
  use {
    'j-hui/fidget.nvim',  -- Show lsp status at right bottom
    config = function()
      require"fidget".setup{}
    end
  }
  use {
    "danymat/neogen", -- Generate class/function comment
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('neogen').setup {}
    end,
  }

  ----- Auto completion
  use 'hrsh7th/nvim-cmp'      -- Core plugin
  use 'onsails/lspkind-nvim'  -- Completion menu UI
  -- nvim-cmp source
  use 'hrsh7th/cmp-nvim-lsp'  -- Completion from LSP server
  use 'hrsh7th/cmp-nvim-lsp-document-symbol'  -- Symbol from LSP (jump to symbol easily)
  use 'hrsh7th/cmp-buffer'    -- Content from buffer
  use 'hrsh7th/cmp-path'      -- Path
  use 'hrsh7th/cmp-cmdline'   -- Commands
  use 'hrsh7th/cmp-calc'      -- Math calc
  use {
    'petertriho/cmp-git',     -- Git. :<Tab> see commits
    ft = {"gitcommit"},
    config = function()
      require("cmp_git").setup()
    end
  }
  use {
    'saadparwaiz1/cmp_luasnip',  -- Support LuaSnip in nvim-cmp
    after = "LuaSnip",
  }
  use {
    "L3MON4D3/LuaSnip", tag = "v1.*.*",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/snippets/vscode" } })
      require("snippets.lua")
    end
  }
  use "ray-x/lsp_signature.nvim" -- SHow method signature when typing
  -- Neovim
  use "folke/neodev.nvim" --  Full signature help for neovim method
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup()
    end
  }
  -- Rust
  use {
    "rust-lang/rust.vim",  --Rrust command integration
    requires = "mattn/webapi-vim",
  }
  use {
    "simrat39/rust-tools.nvim",  -- Rust development improvement
    requires = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",  -- For debuging
    }
  }
  use {
    'saecki/crates.nvim',  -- crates auto completion
    tag = 'v0.3.0',
    ft = {'toml'},
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
      vim.api.nvim_create_autocmd("BufEnter", {  -- lazy load
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          require("cmp").setup.buffer({
            sources = require("cmp").config.sources(
              {{ name = 'crates' }},
              {{ name = 'nvim_lsp' }}
            )
          })
        end,
      })
    end,
  }
  -- Other languages
  use {
    "iamcco/markdown-preview.nvim",  -- :MarkdownPreviewToggle toggles preview
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },  -- Load plugin when opening md
  }

  ------ Appearance
  use "nvim-tree/nvim-web-devicons"  -- Icon used by several plugins
  use {
    "p00f/nvim-ts-rainbow", -- Rainbow bracket
    requires = "nvim-treesitter/nvim-treesitter",
  }
  use {
    "rcarriga/nvim-notify",  -- Notification manager
    config = function()
      vim.notify = require("notify")
      vim.notify.setup {
        timeout = 1500,
        minimum_width = 40,
      }
    end
  }
  use {
    "folke/zen-mode.nvim",  -- Zen mode
    requires = "folke/twilight.nvim",
    config = function()
      require("twilight").setup {
        context = 20,
      }
      require("zen-mode").setup {
        backdrop = 0.15,
        width = 160,
        plugins = {
          options = {
            ruler = true,
            -- showcmd = true,
          }
        }
      }
    end
  }
  use "petertriho/nvim-scrollbar"  -- Scrollbar
  use "kevinhwang91/nvim-hlslens"  -- Glance search info in virtual text. Integrated with nvim-scrollbar and vim-visual-multi.
  use {
    "EdenEast/nightfox.nvim",  -- ColorScheme. Alternative choices: everforest, tokyonight
    after = {  -- plugins that setts highlight group
      "nvim-treesitter-context",
      "vim-visual-multi",
      "vim-illuminate",
      "nvim-scrollbar",
    },
    config = function()
      vim.cmd [[colorscheme nordfox]]
    end
  }
  use "lukas-reineke/indent-blankline.nvim"  -- Indent guide line

  -- MISC
  use {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require 'mind'.setup()
      set("n", "<leader>m", "<cmd>MindOpenMain<cr>")
      vim.cmd[[autocmd FileType mind map <buffer> ? :h mind-config-keymaps<cr>]]
    end
  }
  use {
    "lewis6991/impatient.nvim",  -- Improve startup time
    config = function ()
      require('impatient').enable_profile()  -- Enable :LuaCacheProfile
    end
  }
  -- TODO:
  -- https://github.com/nathom/filetype.nvim
  -- https://github.com/hkupty/iron.nvim

  ----- Abandoned plugins
  -- jiangmiao/auto-pairs      -- Replace with nvim-autopairs
  -- folke/noice.nvim          -- UI for messages, cmdline and popupmenu. depend on nvim-notify. To noisy.
  -- hrsh7th/cmp-nvim-lua      -- Neovim Lua API. Not much useful.
  -- farmergreg/vim-lastplace  -- Use session manager to remember cursur position
  -- https://git.sr.ht/~whynothugo/lsp_lines.nvim  -- Show diagnostics in individual line. Distracting.
  -- romgrk/barbar.nvim        -- Tabline. Pretty but not support only show tab, see https://github.com/romgrk/barbar.nvim/issues/108.
  -- nvim-treesitter/nvim-treesitter-refactor  -- Variable usage is not accurate. vim-illuminate is better though it always can't find anything in rust.
  -- numToStr/Comment.nvim     -- Uncomment is unsupported (https://github.com/numToStr/Comment.nvim/issues/22)
  -- terryma/vim-expand-region -- +/_ expands/shrinks visual selection. Replace by treesitter-textobjects.
  -- gen740/SmoothCursor.nvim  -- Fancy indicate cursor line. Distracting.
  -- edluffy/specs.nvim        -- Amination to show where cursor is. Distracting.
  -- akinsho/bufferline.nvim   -- Style is not my type. Old config: https://github.com/fjchen7/dotfiles/blob/da25997575234eb211e8773051b4db67f88c85c1/config/nvim/lua/plugin.lua#L363.
  -- karb94/neoscroll.nvim   -- Smooth scroll for <C-d>, zz and so on. Performance issue.
  -- wellle/targets.vim      -- Replaced by mini.nvim#mini.ai. The latter does not support A/I but I don't need them
  -- michaeljsmith/vim-indent-object  -- ai, ii, aI, iI select indent content. Replaced by mini.nvim#mini.indentscope.
  -- goolord/alpha-nvim      -- Start-up page. Use vim-startify instead.
  -- rmagatti/auto-session   -- Auto save session. Use vim-startify instead.
  -- rmagatti/session-lens   -- List avaliable sessions by telescope. Use vim-startify instead.
  -- ahmedkhalf/project.nvim -- List recent projects. It tries to detect change cwd, which brings unexpected affects for plugins like vim-startify.
  -- phaazon/hop.nvim        -- Easymotion-like plugin. Bug "col value outside range" not fixed.
  -- justinmk/vim-sneak      -- I love it, but leap.nvim is a better solution.
  -- nvim-lua/lsp-status.nvim  -- Replaced by j-hui/fidget
  --
  ----- Abandoned cmp source
  -- hrsh7th/cmp-nvim-lsp-signature-help     -- Distracting
  -- davidsierradz/cmp-conventionalcommits   -- Not much userful
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end

return packer.startup {
  plugins,
  config = {
    display = {
      open_fn = function()
        -- using floating window
        return require("packer.util").float({ border = "single" })
      end,
    },
  }
}
