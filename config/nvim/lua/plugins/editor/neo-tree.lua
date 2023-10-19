-- file explorer
return {
  "nvim-neo-tree/neo-tree.nvim",
  event = "VeryLazy", -- Loading on demand will cause first invoking slow
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "s1n7ax/nvim-window-picker",
      event = "VeryLazy",
      -- keys = {
      --   { "<leader>`", Util.focus_win, desc = "pick a window" }
      -- },
      opts = {
        hint = "floating-big-letter",
        filter_rules = {
          include_current_win = false,
          bo = {
            filetype = { "NvimTree", "neo-tree", "notify", "aerial" },
            -- buftype = { "terminal" },
            buftype = { "terminal", "quickfix" },
          },
        },
      },
    },
  },
  keys = {
    -- {
    --   "<leader>e",
    --   function() require("neo-tree.command").execute({ toggle = true, dir = Util.get_root() }) end,
    --   desc = "neo-tree (root dir)",
    -- },
    -- { "<leader>E", "<cmd>Neotree action=focus<cr>", desc = "file explorer" },
    -- { "<leader>e", "<cmd>Neotree show<cr>", desc = "show neo-tree" },
    { "<M-space>", "<cmd>Neotree reveal action=focus<cr>", desc = "focus on buffer (neo-tree)" },
    { "<leader><space>", "<cmd>Neotree toggle<cr>", desc = "focus (neo-tree)" },
  },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = function()
    local close_tree_in_buf = function()
      local path = vim.api.nvim_buf_get_name(0)
      local in_neo_tree = string.find(path, "neo%-tree filesystem")
      if not in_neo_tree then
        vim.cmd("Neotree close")
      end
    end
    local opts = {
      window = {
        -- :h neo-tree-mappings
        mappings = {
          -- Switch between filesystem, buffers and git_status
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#switch-between-filesystem-buffers-and-git_status
          ["1"] = "view_filesystem",
          ["2"] = "view_git_status",
          ["3"] = "view_buffers",
          -- Disable prev/next_source
          [">"] = "noop",
          ["<"] = "noop",
          -- Open
          v = "vsplit_with_window_picker",
          s = "split_with_window_picker",
          V = "vsplit_with_window_picker_and_close",
          S = "split_with_window_picker_and_close",
          o = "open_with_window_picker",
          O = "open_with_window_picker_and_close",
          ["<space>"] = "noop",
          -- open_drop: If file is already opened in one window, jump to that window instead of opening it in current window
          ["<cr>"] = "open_drop",
          ["."] = "open_with_vscode",
          P = { "toggle_preview", config = { use_float = false } },
          I = "focus_preview",
          w = "noop",
          -- Navigation with HJKL
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Tips#navigation-with-hjkl
          h = "prev_level",
          l = "next_level",
          R = "noop",
          ["<M-r>"] = "refresh",
          ["<C-r>"] = "spectre_replace",
          ["<M-space>"] = "close_window",
        },
      },
      commands = {
        open_with_window_picker_and_close = function(state)
          -- copy(state.commands)  -- List all available commands
          state.commands["open_with_window_picker"](state)
          close_tree_in_buf()
        end,
        split_with_window_picker_and_close = function(state)
          state.commands["split_with_window_picker"](state)
          close_tree_in_buf()
        end,
        vsplit_with_window_picker_and_close = function(state)
          state.commands["vsplit_with_window_picker"](state)
          close_tree_in_buf()
        end,
        open_with_vscode = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.jobstart({ "code", path }, { detach = true })
        end,
        -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Tips#open-file-without-losing-sidebar-focus
        open_without_focus = function(state)
          local node = state.tree:get_node()
          if require("neo-tree.utils").is_expandable(node) then
            state.commands["toggle_node"](state)
          else
            state.commands["open"](state)
            vim.cmd("Neotree reveal")
          end
        end,
        view_filesystem = function()
          vim.api.nvim_exec("Neotree focus filesystem left", true)
        end,
        view_buffers = function()
          vim.api.nvim_exec("Neotree focus buffers left", true)
        end,
        view_git_status = function()
          vim.api.nvim_exec("Neotree focus git_status left", true)
        end,
        prev_level = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" and node:is_expanded() then
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        next_level = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            if not node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            elseif node:has_children() then
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else
            -- open or focus
            local file_win_id = nil
            local node_path = node.path
            local win_ids = vim.api.nvim_list_wins()
            for _, win_id in pairs(win_ids) do
              local buf_id = vim.api.nvim_win_get_buf(win_id)
              local path = vim.api.nvim_buf_get_name(buf_id)
              if node_path == path then
                file_win_id = win_id
              end
            end
            if file_win_id then
              vim.api.nvim_set_current_win(file_win_id)
            else
              state.commands["open"](state)
              vim.cmd("Neotree reveal")
            end
          end
        end,
        { "toggle_preview", config = { use_float = true } },
        open_or_focus = function(state)
          local node = state.tree:get_node()
          local node_path = node.path
          local win_ids = vim.api.nvim_list_wins()
          for _, win_id in pairs(win_ids) do
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            local path = vim.api.nvim_buf_get_name(buf_id)
            if node_path == path then
              vim.api.nvim_set_current_win(win_id)
              vim.notify(path)
              return
            end
          end
        end,
        reveal_file = function()
          local win_id = require("window-picker").pick_window()
          local buf_id = vim.api.nvim_win_get_buf(win_id)
          local path = vim.api.nvim_buf_get_name(buf_id)
          vim.cmd("Neotree reveal_file=" .. path)
        end,
        -- https://www.reddit.com/r/neovim/comments/187kdod/comment/kbi8xfl
        spectre_replace = function(state)
          local opts = { is_close = false }
          local node = state.tree:get_node()
          if node.type == "directory" then
            opts.cwd = node.path
          else
            local path = node.path
            -- local parent = vim.fn.fnamemodify(path, ":h")
            local basename = vim.fn.fnamemodify(path, ":t")
            opts.path = basename
          end
          require("spectre").open(opts)
          vim.cmd("Neotree close")
        end,
      },
      filesystem = {
        -- follow_current_file = true,
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
        window = {
          width = 40,
          mappings = {
            ["<C-x>"] = "noop",
            F = { "clear_filter" },
            ["]g"] = "noop",
            ["[g"] = "noop",
            J = "next_git_modified",
            K = "prev_git_modified",
            ["-"] = "navigate_up",
            ["="] = "set_root",
            ["<bs>"] = "noop",
            ["."] = "noop",
          },
        },
      },
    }
    return opts
  end,
  config = function(_, opts)
    local cc = require("neo-tree.sources.common.commands")
    -- Open file in new tab with neotree shown
    cc.open_tabnew = (function(func)
      return function(...)
        func(...)
        vim.cmd([[Neotree reveal action=show]])
      end
    end)(cc.open_tabnew)
    require("neo-tree").setup(opts)
  end,
}
