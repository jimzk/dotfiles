-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua#L7
local M = {
  -- File explorer
  "nvim-neo-tree/neo-tree.nvim",
}

M.dependencies = {
  "MunifTanjim/nui.nvim",
  {
    "s1n7ax/nvim-window-picker",
    event = "VeryLazy",
    opts = {
      hint = "floating-big-letter",
      filter_rules = {
        include_current_win = false,
        bo = {
          filetype = {
            "incline",
            "NvimTree",
            "neo-tree",
            "notify",
            "aerial",
            "fidget",
            "edgy",
            "help",
            -- https://github.com/nvim-zh/colorful-winsep.nvim/blob/alpha/lua/colorful-winsep/line.lua#L10
            "NvimSeparator",
          },
          buftype = { "terminal", "quickfix", "nofile" },
        },
      },
    },
  },
}

local is_neo_tree_shown = function()
  -- Check if neo-tree is open
  -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/826#discussioncomment-5429747
  local manager = require("neo-tree.sources.manager")
  local renderer = require("neo-tree.ui.renderer")
  local ok, state = pcall(manager.get_state, "filesystem")
  if not ok then
    return false
  end
  local window_exists = renderer.window_exists(state)
  return window_exists
end

Util.is_neo_tree_shown = is_neo_tree_shown

M.keys = function()
  return {
    {
      "<C-r>r",
      function()
        -- if is_neo_tree_shown() then
        if vim.bo.ft == "neo-tree" then
          vim.cmd("wincmd p")
        else
          vim.cmd("Neotree position=top filesystem")
        end
        -- else
        --   vim.cmd("Neotree reveal action=focus")
        --   -- require("neo-tree.command").execute({ toggle = true, action = "show", dir = vim.loop.cwd() })
        -- end
      end,
      desc = "Open NeoTree or Focus",
    },
    -- {
    --   "<leader>fE",
    --   function()
    --     local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    --     -- local dir = Util.root()
    --     require("neo-tree.command").execute({ action = "focus", dir = dir, reveal = true })
    --   end,
    --   desc = "NeoTree (File Directory)",
    -- },
    -- {
    --   "<C-r>u",
    --   function()
    --     require("neo-tree.command").execute({
    --       source = "git_status",
    --       position = "float",
    --       action = "focus",
    --       reveal = true,
    --     })
    --   end,
    --   desc = "Git NeoTree",
    -- },
    -- {
    --   "<leader>gge",
    --   "<C-r>u",
    --   remap = true,
    --   desc = "Git NeoTree",
    -- },
    {
      "<C-r>g",
      "<cmd>Neotree position=bottom git_status<cr>",
      desc = "Git NeoTree",
    },

    {
      "<C-r>b",
      "<cmd>Neotree position=right buffers<cr>",
      desc = "Buffer NeoTree",
    },
    {
      "<C-r>f",
      function()
        if is_neo_tree_shown() then
          if vim.bo.ft == "neo-tree" then
            -- pick file and reval
            require("plugins.ui.neo-tree.commands").reveal_file()
          else
            vim.cmd("Neotree reveal action=focus")
          end
        else
          vim.cmd("Neotree reveal action=focus")
          -- vim.cmd("Neotree reveal action=show")
        end
      end,
      desc = "Reveal File in NeoTree",
    },
  }
end

M.opts = {
  default_component_configs = {
    indent = {
      with_markers = false,
      indent_size = 2,
    },
  },
  enable_git_status = true,
  enable_diagnostics = false,
  commands = require("plugins.ui.neo-tree.commands"),
  close_if_last_window = true,
  sources = { "filesystem", "buffers", "git_status", "document_symbols", "netman.ui.neo-tree" },
  -- source_selector = {
  --   winbar = false, -- toggle to show selector on winbar
  --   statusline = true, -- toggle to show selector on statusline
  --   show_scrolled_off_parent_node = false, -- boolean
  --   tabs_layout = "center",
  --   sources = { -- table
  --     {
  --       source = "filesystem", -- string
  --       display_name = "󰉓 Files", -- string | nil
  --     },
  --     {
  --       source = "git_status", -- string
  --       display_name = "󰊢 Git", -- string | nil
  --     },
  --     {
  --       source = "buffers", -- string
  --       display_name = "󰈚 Buffers", -- string | nil
  --     },
  --     {
  --       source = "remote", -- string
  --       display_name = "󰈚 Remote", -- string | nil
  --     },
  --   },
  -- },
}

M.opts.window = {
  -- :h neo-tree-mappings
  mappings = {
    -- Switch between filesystem, buffers and git_status
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#switch-between-filesystem-buffers-and-git_status
    -- ["1"] = "view_filesystem",
    -- ["2"] = "view_git_status",
    -- ["3"] = "view_buffers",
    -- ["4"] = "view_remote",

    -- prev/next_source
    [">"] = "noop",
    ["<"] = "noop",
    ["-"] = "prev_source",
    ["="] = "next_source",
    -- Open
    -- open_drop: If file is already opened in one window, jump to that window instead of opening it in current window
    -- ["<CR>"] = "open_drop",
    -- ["<S-CR>"] = "open_drop_and_close",
    ["<CR>"] = "open_with_window_picker",
    ["<M-CR>"] = "open_with_window_picker_and_close",
    v = "vsplit_with_window_picker",
    ["<M-v>"] = "vsplit_with_window_picker_and_close",
    s = "split_with_window_picker",
    ["<M-s>"] = "split_with_window_picker_and_close",
    t = "open_tabnew",

    ["<space>"] = "noop",
    P = { "toggle_preview", config = { use_float = false } },
    I = "focus_preview",
    w = "noop",
    d = "trash",
    -- Navigation with HJKL
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Tips#navigation-with-hjkl
    h = "close_node_or_go_parent",
    l = "open_node_or_go_child",
    H = "go_parent",
    L = "go_parent_sibling",
    K = "prev_sibling",
    J = "next_sibling",
    ["c"] = "toggle_node_smart",
    C = "toggle_node",
    A = "noop",
    -- R = "noop",
    Y = "noop",
    ["<M-r>"] = "refresh",
    ["R"] = "spectre_replace",
    ["<M-space>"] = "reveal_file",
    -- Utilities
    ["<C-y>"] = "copy_filename",
    ["<leader>/"] = "telescope_grep",
    ["<M-o>"] = "open_with_vscode",
    -- ["<tab>"] = "fuzzy_finder",
    ["/"] = "noop",
    ["<C-f>"] = "noop",
    ["<C-b>"] = "noop",
    ["<M-n>"] = { "scroll_preview", config = { direction = -10 } },
    ["<M-p>"] = { "scroll_preview", config = { direction = 10 } },
  },
}

M.opts.filesystem = {
  -- File explorer change with cwd
  bind_to_cwd = false,
  follow_current_file = { enabled = false },
  never_show = {
    ".DS_Store",
    "thumbs.db",
  },
  window = {
    width = 35,
    mappings = {
      ["<M-h>"] = "toggle_hidden",
      ["<C-x>"] = "noop",
      F = { "clear_filter" },
      ["]g"] = "noop",
      ["[g"] = "noop",
      [")"] = "next_git_modified",
      ["("] = "prev_git_modified",
      [";"] = "navigate_up",
      ["."] = "set_root",
      ["<bs>"] = "noop",
      -- ["."] = "noop",

      -- ["<C-s>"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "<C-s>" } },
      -- ["<C-s>c"] = { "order_by_created", nowait = false },
      -- ["<C-s>d"] = { "order_by_diagnostics", nowait = false },
      -- ["<C-s>g"] = { "order_by_git_status", nowait = false },
      -- ["<C-s>m"] = { "order_by_modified", nowait = false },
      -- ["<C-s>n"] = { "order_by_name", nowait = false },
      -- ["<C-s>s"] = { "order_by_size", nowait = false },
      -- ["<C-s>t"] = { "order_by_type", nowait = false },
      -- ["oc"] = "noop",
      -- ["od"] = "noop",
      -- ["og"] = "noop",
      -- ["om"] = "noop",
      -- ["on"] = "noop",
      -- ["os"] = "noop",
      -- ["ot"] = "noop",
    },
  },
}

M.opts.git_status = {
  window = {
    mappings = {
      ["g"] = { "show_help", nowait = false, config = { title = "Git Operation", prefix_key = "g" } },
    },
  },
}

M.config = function(_, opts)
  require("neo-tree").setup(opts)
  -- Highlight
  -- vim.cmd("hi! link NeoTreeCursorLine QuickFixLine")
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "neo-tree" },
    callback = function(opts)
      vim.keymap.set("n", "<C-v>", "V", { buffer = opts.buf, remap = false })
    end,
  })
end

return M
