return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  enabled = false,
  cmd = { "Oil" },
  keys = {
    {
      "<C-r>o",
      function()
        require("oil").open()
        -- vim.defer_fn(function()
        --   require("oil").open_preview()
        -- end, 1000)
      end,
      desc = "Open Oil",
    },
    {
      "<C-r>O",
      function()
        require("oil").toggle_float()
      end,
      desc = "Open Oil float",
    },
    -- {
    --   "<C-r>o",
    --   function()
    --     if vim.bo.filetype == "oil" then
    --       require("mini.bufremove").delete(0)
    --     else
    --       vim.cmd("Oil --float")
    --     end
    --   end,
    --   desc = "Open Oil",
    -- },
    -- {
    --   "<C-r>v",
    --   "<CMD>vs | Oil<CR>",
    --   desc = "Open Oil Vertical",
    -- },
    -- {
    --   "<C-r>s",
    --   "<CMD>sp | Oil<CR>",
    --   desc = "Open Oil Split",
    -- },
  },
  opts = function()
    local oil = require("oil")
    return {
      columns = {
        "icon",
        "size",
        { "mtime", format = "%Y-%m-%d %H:%M" },
      },
      win_options = {
        signcolumn = "number",
        relativenumber = false,
      },
      -- Remove Oil from jumplist
      cleanup_delay_ms = 100,
      delete_to_trash = true,
      use_default_keymaps = false,
      -- See :h oil-actions
      keymaps = {
        ["?"] = "actions.show_help",
        ["<F1>"] = "actions.show_help",

        ["<C-v>"] = { callback = "actions.select_vsplit", desc = "Open in vertial split" },
        ["<C-s>"] = { callback = "actions.select_split", desc = "Open in horizontal split" },
        ["<C-t>"] = { callback = "actions.select_tab", desc = "Open in new tab" },

        ["<C-p>"] = { callback = "actions.preview", desc = "Toggle preview" },
        ["<C-r>"] = { callback = "actions.refresh", desc = "Refresh" },

        ["h"] = { callback = "actions.parent", desc = "Navigate to parent path", mode = { "n" } },
        ["l"] = {
          callback = function()
            local entry = oil.get_cursor_entry()
            if entry.type == "directory" then
              oil.select()
            end
          end,
          desc = "Navigate to child path",
          mode = { "n" },
        },
        -- "actions.select",
        ["_"] = { callback = "actions.open_cwd", desc = "Change oil to current CWD" },
        ["`"] = { callback = "actions.cd", desc = "tcd to oil directory" },
        ["~"] = { callback = "actions.tcd", desc = "tcd (work only for current tab) to oil directory" },

        ["<M-h>"] = { callback = "actions.toggle_hidden", desc = "Toggle hiddent file" },
        ["<M-s>"] = { callback = "actions.change_sort", desc = "Change sort order" },
        ["<M-y>"] = { callback = "actions.copy_entry_path", desc = "Copy entry path" },
        ["<M-o>"] = { callback = "actions.open_external", desc = "Open entry by external program" },
        -- macOs can't support oil trash. See :h oil-trash
        -- ["<BS>"] = "actions.toggle_trash",

        ["<C-q>"] = "actions.send_to_qflist",
        ["<C-l>"] = "actions.send_to_loclist",
        ["g<C-q>"] = "actions.add_to_qflist",
        ["g<C-l>"] = "actions.add_to_loclist",
      },
      float = {
        padding = 10,
        max_width = 50,
        max_height = 30,
        win_options = {
          winblend = 0,
        },
      },
      preview = {
        min_width = { 100, 0.6 },
      },
    }
  end,
  config = function(_, opts)
    require("oil").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "oil" },
      callback = function(opts)
        local opts = { buffer = opts.buf }
        local oil = require("oil")
        local map = Util.map
        -- Hide these keymappings from help table
        map("n", "<Esc>", oil.close, nil, opts)
        map("n", "q", oil.close, nil, opts)
        map("n", "<Cr>", oil.select, nil, opts)
      end,
    })
  end,
}
