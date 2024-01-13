-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L115
local lazy_util = require("lazyvim.util")
local M = {
  "nvim-telescope/telescope.nvim",
}

M.keys = function()
  return {
    { "<leader><Tab>", "<cmd>Telescope resume<cr>", desc = "Resume Telescope" },
    -- find files
    { "<C-b>f", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Find Buffers" },
    {
      "<leader>ff",
      lazy_util.telescope("find_files", {
        cwd = false,
        hidden = false,
        no_ignore = false,
        follow = true,
      }),
      desc = "Find Files",
    },
    -- { "<leader>fF", lazy_util.telescope("files"), desc = "Find Files (Root)" },
    {
      "<leader>fg",
      lazy_util.telescope("git_files", {
        show_untracked = true,
      }),
      desc = "Find Files (Git Files)",
    },
    {
      "<leader>f<C-f>",
      function()
        local path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
        local home = os.getenv("HOME")
        local shorter_path = string.gsub(path, "^" .. home, "~")
        lazy_util.telescope("find_files", {
          cwd = path,
          prompt_title = "Find Files (" .. shorter_path .. "/)",
          hidden = true,
          no_ignore = true,
          follow = true,
        })()
      end,
      desc = "Find Files (File Directory)",
    },

    {
      "<leader>fr",
      function()
        local path = vim.loop.cwd()
        local home = os.getenv("HOME")
        local shorter_path = string.gsub(path, "^" .. home, "~")
        lazy_util.telescope("oldfiles", {
          cwd = path,
          prompt_title = "Oldfiles (" .. shorter_path .. "/)",
        })()
      end,
      desc = "Find Recent Files (cwd)",
    },
    {
      "<leader>fR",
      "<cmd>Telescope oldfiles prompt_title=Oldfiles\\ (Global)<cr>",
      desc = "Find Recent Files (Global)",
    },
    -- git
    { "<leader>gc", "<cmd>Telescope git_bcommits<CR>", desc = "Git File Commit" },
    { "<leader>gC", "<cmd>Telescope git_commits<CR>", desc = "Git Commit" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
    { "<leader>gS", "<cmd>Telescope git_stash<CR>", desc = "Git Stash" },
    { "<leader>gh", "<cmd>Telescope git_branches<CR>", desc = "Git Branch" },
    -- search
    { '<leader>"', "<cmd>Telescope registers<cr>", desc = "Registers" },

    -- Not use
    -- { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },

    -- { "<leader>mj", "<cmd>Telescope marks<cr>", desc = "Jump to Mark (Telescope)" },

    -- Configurations
    { "<F1>", "<CMD>Telescope help_tags<CR>", desc = "List Helps" },
    { "<leader>n<F1>", "<CMD>Telescope help_tags<CR>", desc = "List Helps" },
    { "<leader>nn", "<CMD>Telescope filetypes<CR>", desc = "Set Filetype" },
    { "<leader>nh", "<cmd>Telescope highlights<cr>", desc = "List Highlights" },
    { "<leader>na", "<cmd>Telescope autocommands<cr>", desc = "List Auto-Commands" },
    { "<leader>nk", "<cmd>Telescope keymaps<cr>", desc = "List Keymaps" },
    { "<leader>no", "<cmd>Telescope vim_options<cr>", desc = "List Vim Options" },
    { "<leader>n:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    -- { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>nc", lazy_util.telescope("colorscheme", { enable_preview = true }), desc = "List Colorschemes" },

    { "<leader>nm", "<cmd>norm! K<cr>", desc = "Man Page under Cursor Word" },
    { "<leader>nM", "<cmd>Telescope man_pages<cr>", desc = "List Man Pages" },

    -- Search Text
    -- { "<leader>/", lazy_util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
    -- { "<C-f>", lazy_util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
    -- { "<C-f>", lazy_util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Grep (cwd)" },
    -- { "<C-M-f>", lazy_util.telescope("live_grep"), desc = "Grep (root dir)" },
    -- { "<C-M-f>", lazy_util.telescope("grep_string"), mode = "v", desc = "Grep (root dir)" },

    -- stylua: ignore start
    -- { "<leader><C-f>", lazy_util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Grep Word under Cursor (cwd)", },
    -- { "<leader><C-M-f>", lazy_util.telescope("grep_string", { word_match = "-w" }), desc = "Grep Word under Cursor (root dir)" },
    -- stylua: ignore end

    -- Symbols
    {
      "<leader>yt",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({
          symbols = { "Class", "Enum", "Interface", "Struct", "Trait", "TypeParameter" },
          prompt_title = "LSP Workspace Symbols (Type)",
        })
      end,
      desc = "List Types",
    },
    {
      "<leader>yT",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = { "Class", "Enum", "Interface", "Struct", "Trait", "TypeParameter" },
          prompt_title = "LSP Workspace Symbols (Type) in Buffer",
        })
      end,
      desc = "List Types in Buffer",
    },
    {
      "<leader>yf",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({
          symbols = { "Function", "Method", "Constructor" },
          prompt_title = "LSP Workspace Symbols (Function)",
        })
      end,
      desc = "List Functions",
    },
    {
      "<leader>yF",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = { "Function", "Method", "Constructor" },
          prompt_title = "LSP Workspace Symbols (Function) in Buffer",
        })
      end,
      desc = "List Functions in Buffer",
    },
    {
      "<leader>ym",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({
          symbols = { "Package", "Namespace", "Module" },
          prompt_title = "LSP Workspace Symbols (Module)",
        })
      end,
      desc = "List Modules",
    },
    -- {
    --   "<leader>yc",
    --   function()
    --     require("telescope.builtin").lsp_dynamic_workspace_symbols({
    --       -- symbols = require("lazyvim.config").get_kind_filter(),
    --       symbols = { "Constant", "String", "Number", "Boolean" },
    --       prompt_title = "LSP Workspace Symbols (Constant)",
    --     })
    --   end,
    --   desc = "List Constants",
    -- },
    {
      "<leader>ya",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({
          -- List: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#documentSymbolParams
          -- symbols = require("lazyvim.config").get_kind_filter(),
          prompt_title = "LSP Workspace Symbols (All)",
        })
      end,
      desc = "List All Symbols",
    },
  }
end

M.opts = function()
  local actions = require("telescope.actions")

  local open_with_trouble = function(...)
    return require("trouble.providers.telescope").open_with_trouble(...)
  end
  local open_selected_with_trouble = function(...)
    return require("trouble.providers.telescope").open_selected_with_trouble(...)
  end

  local open_selected_with_qflist = function(...)
    actions.smart_send_to_qflist(...)
    actions.open_qflist(...)
  end

  return {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      -- path_display = {
      --   truncate = true, -- truncate long file name
      -- },
      results_title = false, -- hide results title
      dynamic_preview_title = true, -- Use dynamic preview title if avaliable
      -- sorting_strategy = "ascending", -- cursor starts from top result
      layout_strategy = "vertical", -- flex, bottom_pane, curcor, center, horizontal, vertical
      layout_config = {
        -- prompt_position = "top",
        flex = {
          -- use vertical layout when window column < filp_columns
          flip_columns = 160,
        },
        vertical = {
          -- flip location of results/prompt and preview windows
          -- mirror = true,
          preview_height = 0.4,
        },
        horizontal = {},
        bottom_pane = {
          height = { 0.5, min = 25, max = 50 },
        },
      },

      file_ignore_patterns = { "node_modules", "/dist", "target" },
      wrap_results = true,

      -- open files in the first window that is an actual file.
      -- use the current window if no other window is available.
      get_selection_window = function()
        local wins = vim.api.nvim_list_wins()
        table.insert(wins, 1, vim.api.nvim_get_current_win())
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then
            return win
          end
        end
        return 0
      end,

      mappings = {
        i = {
          ["<Esc>"] = actions.close, -- disable normal mode
          ["<CR>"] = actions.select_default + actions.center,
          ["<C-s>"] = actions.select_horizontal,
          -- ["<C-t>"] = open_with_trouble,
          ["<M-t>"] = open_selected_with_trouble,
          ["<M-q>"] = open_selected_with_qflist,
          ["<C-\\>"] = require("telescope.actions.layout").toggle_preview,
          -- Navigation
          -- ["<C-Down>"] = actions.cycle_history_next,
          -- ["<C-Up>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<C-M-n>"] = actions.results_scrolling_down,
          ["<C-M-p>"] = actions.results_scrolling_up,
          ["<M-f>"] = actions.preview_scrolling_down,
          ["<M-b>"] = actions.preview_scrolling_up,
          -- Disable defaults
          ["<C-x>"] = false,
          ["<PageUp>"] = false,
          ["<Pagedown>"] = false,
          ["<C-u>"] = false,
          ["<C-d>"] = false,
        },
        n = {
          ["q"] = actions.close,
        },
      },
    },
    pickers = require("plugins.editor.telescope.pickers"),
  }
end

M.config = function(_, opts)
  require("telescope").setup(opts)
  -- Show line number in preview: https://github.com/nvim-telescope/telescope.nvim/issues/1186
  vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")
  -- Wrap Preview
  vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
end

return M
