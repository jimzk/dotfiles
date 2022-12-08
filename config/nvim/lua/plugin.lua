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

-- Install your plugins here
return packer.startup(function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself

  ------ Cheatsheet
  use "folke/which-key.nvim"  -- Display popup of keymap hint (together with keybinding)
                              -- :checkhealth which_key checks conflicting keymaps.
                              -- :WhichKey shows all mapping, :WhichKey <leader>g shows all <leader>g mapping
                              -- In popup, <backspace> go up one level, <c-d> and <c-u> scroll page.
  ------ Fuzzy search
  use {
    "nvim-telescope/telescope.nvim",  -- Fuzzy search
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
  use "nvim-telescope/telescope-live-grep-args.nvim"  -- Grep with regex file name
  -- TODO: project.nvim is not much useful???
  use "ahmedkhalf/project.nvim"                       -- Recent project

  ------ Navigation
  use {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "rcarriga/nvim-notify",  -- More elegant notification
      { "nvim-tree/nvim-web-devicons", opt = true } -- More beautiful icons
    },
    -- cmd = { "NvimTreeToggle", "NvimTreeFocus" },  -- Load plugin when first invoking these commands
  }
  use "easymotion/vim-easymotion"
  use "chentoast/marks.nvim"  -- Visualiaze marks

  ------- Jump & text objects
  use "bkad/CamelCaseMotion"  -- <leader> + w/b/e/ge select camel case word
  use "wellle/targets.vim"  -- Select content inside bracket, quote, separator (, . ; etc.), argument and tags
                            -- Work like di' and support i a I a
                            -- Most frequently used: ib(bracket), iq(quote), ia(argument)
                            -- inx/ilx select next/last objects, x can be any char
  use "michaeljsmith/vim-indent-object"  -- ai, ii, aI, iI select content in the same indent
  use "kana/vim-textobj-user"      -- Dependency of vim-textobj-*
  use "kana/vim-textobj-entire"    -- ae, ie select entire content
  use "kana/vim-textobj-line"      -- al, il select entire line
  use "glts/vim-textobj-indblock"  -- ao, io, aO, iO select indent
  use "dbakker/vim-paragraph-motion"  -- Include blank lines when using { and } to select paragraph

  ------ Edit
  use {
    "mg979/vim-visual-multi",           -- Multi selection in visual block mode (ctrl-v)
    setup = function()                  -- All operations only work in visual block mode.
      -- Help: :h vm-highlight          -- Ctrl-n selects word, q/N select next/previous match
      vim.g.VM_Mono_hl = 'Cursor'       -- q/Q skip current
      -- Cursor in selection            -- ]/[ go to next/previous selection
      vim.g.VM_Cursor_hl = 'Cursor'     -- i/a/I/A edit
      -- Selected items in selection
      vim.g.VM_Extend_hl = 'CurSearch'
      -- Multi insert place atfer selection
      -- vim.g.VM_Insert_hl = 'Cursor'
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
    "AndrewRadev/splitjoin.vim",   -- gS expand (like split) and gJ shrink (like join) line by language grammar.
                                   -- Only work in normal mode
    -- TODO: to remove? no much useful as it always fail to work
    setup = function()
      -- FIX: thie keymap will fallback to origial function
      -- It can't work when setting them in `config` field. Don't know why
      vim.g.splitjoin_split_mapping = 's]'
      vim.g.splitjoin_join_mapping = 's['
    end,
  }
  use "tpope/vim-surround"  -- Operate on surroundings (parentheses, brackets, quotes, XML tags)
                           -- cs"'  :  "Hello world!-- -> 'Hello world!'
                           -- cs]}  :  [Hello] world! -> {Hello} world!
                           -- cs]{  :  [Hello] world! -> { Hello } world!
                           -- ysiw] :  Hello world!   -> [Hello] world!
                           -- ds--   :  "Hello world!-- -> Hello world!
                           -- yss)  :  Hello world    -> (Hello world!)（wrap all line)
  use "windwp/nvim-autopairs"  -- Auto insert/delete bracket or quotes in pair
                               -- <M-e>: wrap next content (fast wrap)
  -- FIX: https://github.com/abecodes/tabout.nvim/issues/39
  --      https://github.com/abecodes/tabout.nvim/issues/40
  use {
    'abecodes/tabout.nvim',  -- <tab> jumps out of bracket
    requires = "nvim-treesitter/nvim-treesitter",
    after = {'nvim-cmp'},
    config = function()
      require('tabout').setup {
        ignore_beginning = false,
        act_as_tab = true,
      }
    end
  }

  ------ Editor
  use "nvim-pack/nvim-spectre" -- Search and replace text
  use "tpope/vim-sleuth"  -- Auto detect indent width in file
  use "mbbill/undotree"  -- Undo history
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  }
  use {"akinsho/toggleterm.nvim", tag = '*',}  -- Toggle terminal
  use "moll/vim-bbye"  -- Delete buffer without messing up layout (:bdelete enhancement)
  use {
    'rmagatti/auto-session',  -- Auto store session under vim.fn.stdpath('data').."/sessions/"
    config = function()       -- vim without any argument open session automatically
      -- https://github.com/rmagatti/auto-session#recommended-sessionoptions-config
      -- https://github.com/windwp/nvim-autopairs/issues/173
      -- FIX: Vim is broken by other plugins like autopairs or alpha if storing `localoptions` in session.
      vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,resize,winsize,winpos,terminal"
      require("auto-session").setup {
        -- auto_session_enable_last_session = true,  -- load loaded session (other folder) if current dir has session.
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/workspace", "~/Downloads", "/"},
      }
    end
  }
  use {
    'rmagatti/session-lens',   -- Search session from auto-session
    requires = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'},
    config = function()
      require('session-lens').setup {
          results_title = "|delete: ^d",
        }
    end
  }

  ------ Git
  use "tpope/vim-fugitive"  -- Integrate git commands
                            -- :Git opens summary window, and g? shows help.
                            -- :Gsplit HEAD~3:% load current file of HEAD~3
  use "lewis6991/gitsigns.nvim"  -- Git changes visualization. :Gitsigns toggle<Tab> to toggle signs.
                                 -- :Gitsigns diffthis diffs buffers.
                                 -- There are also useful operations for hunk.
  -- use "junegunn/gv.vim"
  -- use "sindrets/diffview.nvim"

  ------ Development
  use "neovim/nvim-lspconfig"              -- Neovim LSP support
  use "williamboman/mason.nvim"            -- Manage LSP servers, DAP servers, linters, and formatters
  use "williamboman/mason-lspconfig.nvim"  -- Automatically install LSP servers
  use "glepnir/lspsaga.nvim"               -- Beautify lsp popup (hover, reference, definition and etc.)
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
  use {
    "p00f/nvim-ts-rainbow", -- Rainbow bracket
    requires = "nvim-treesitter/nvim-treesitter",
  }
  use {
    'ldelossa/litee-calltree.nvim',  -- Incoming/outcoming calls tree
    requires = 'ldelossa/litee.nvim',
  }

  ----- Status line & Winbar
  use {
    "nvim-lualine/lualine.nvim",  -- Statusline and winbar
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use "nvim-lua/lsp-status.nvim"  -- Provide lsp status for lualine
  use {
    "SmiteshP/nvim-navic",  -- Show context in winbar
    requires = "neovim/nvim-lspconfig",
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
  use { "L3MON4D3/LuaSnip", tag = "v1.*.*",
    after = "nvim-cmp",
  }
  use {
    'saadparwaiz1/cmp_luasnip',  -- Support LuaSnip in nvim-cmp
    after = "LuaSnip",
  }
  use {
    'rafamadriz/friendly-snippets',  -- Collections of snippets
    event = "InsertEnter",  -- Load plugin when first detecting event
    config = function()
      -- https://github.com/L3MON4D3/LuaSnip#add-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  }
  -- For specific language
  use "folke/neodev.nvim"  --  Full signature help for neovim method
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
    "rcarriga/nvim-notify",  -- Notification manager
    config = function()
      Notify = require("notify")
      Notify.setup {
        timeout = 1000,
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
        width = 140,
        plugins = {
          options = {
            ruler = true,
            -- showcmd = true,
          }
        }
      }
    end
  }
  use {
    "karb94/neoscroll.nvim",  -- smooth scroll
    config = function()
      require('neoscroll').setup()
      local t = {}
      t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '200'}}
      t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '200'}}
      t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '300'}}
      t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '300'}}
      t['<C-y>'] = {'scroll', {'-0.03', 'false', '10'}}
      t['<C-e>'] = {'scroll', { '0.03', 'false', '10'}}
      t['zt']    = {'zt', {'200'}}
      t['zz']    = {'zz', {'200'}}
      t['zb']    = {'zb', {'200'}}
      require('neoscroll.config').set_mappings(t)
    end
  }
  use "petertriho/nvim-scrollbar"  -- Scrollbar
  use "kevinhwang91/nvim-hlslens"  -- Glance search info in virtual text. Integrated with nvim-scrollbar and vim-visual-multi.
  use {
    "EdenEast/nightfox.nvim",  -- Themes. Other choices: everforest, tokyonight
    after = {  -- plugins that setts highlight group
      "nvim-treesitter-context",
      "vim-visual-multi",
      "vim-illuminate",
      "nvim-scrollbar",
    },
    config = function()
      vim.cmd [[colorscheme nightfox]]
    end
  }
  use "lukas-reineke/indent-blankline.nvim"  -- Indent guide line

  -- MISC
  use {
    "lewis6991/impatient.nvim",  -- Improve startup time
    config = function ()
      require('impatient').enable_profile()  -- Enable :LuaCacheProfile
    end
  }

  ----- Abandoned plugins
  -- andymass/vim-matchup      -- Extend % to syntax controll follow (like if else). Neovim has already support it
  -- jiangmiao/auto-pairs      -- Replace with nvim-autopairs
  -- folke/noice.nvim          -- UI for messages, cmdline and popupmenu. depend on nvim-notify. To noisy.
  -- hrsh7th/cmp-nvim-lua      -- Neovim Lua API. Not much useful.
  -- farmergreg/vim-lastplace  -- Use session manager to remember cursur position
  -- ray-x/lsp_signature       -- Show signature hint when calling functions
                               -- Problem: can't scroll preview: https://github.com/ray-x/lsp_signature.nvim/issues/228
                               -- Can be replaced by native vim.lsp.buf.signature_help
  -- https://git.sr.ht/~whynothugo/lsp_lines.nvim  -- Show diagnostics in individual line. Distracting.
  -- romgrk/barbar.nvim        -- Tabline. Pretty but not support only show tab, see https://github.com/romgrk/barbar.nvim/issues/108.
  -- nvim-treesitter/nvim-treesitter-refactor  -- Variable usage is not accurate. vim-illuminate is better though it always can't find anything in rust.
  -- numToStr/Comment.nvim     -- Uncomment is unsupported (https://github.com/numToStr/Comment.nvim/issues/22)
  -- terryma/vim-expand-region -- +/_ expands/shrinks visual selection. Replace by treesitter-textobjects.
  -- gen740/SmoothCursor.nvim  -- Fancy indicate cursor line. Distracting.
  -- edluffy/specs.nvim        -- Amination to show where cursor is. Distracting.
  -- akinsho/bufferline.nvim   -- Style is not my type. Old config: https://github.com/fjchen7/dotfiles/blob/da25997575234eb211e8773051b4db67f88c85c1/config/nvim/lua/plugin.lua#L363.
  --
  ----- Abandoned cmp source
  -- hrsh7th/cmp-nvim-lsp-signature-help     -- Distracting
  -- davidsierradz/cmp-conventionalcommits   -- Not much userful
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
