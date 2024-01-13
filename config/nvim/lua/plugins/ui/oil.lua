return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "Oil" },
  keys = {
    {
      "<C-r>o",
      function()
        require("oil").open()
        vim.defer_fn(function()
          require("oil").open_preview()
        end, 200)
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
  opts = {
    columns = {
      "icon",
      "size",
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
      ["<CR>"] = "actions.select",

      -- ["<Esc>"] = { callback = "<CMD>close<CR>", desc = "close", mode = "n" }, -- close window
      ["<Esc>"] = "actions.close",
      ["<BS>"] = "actions.close",

      ["<C-v>"] = "actions.select_vsplit",
      ["<C-s>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",

      ["<C-p>"] = "actions.preview",
      ["<C-r>"] = "actions.refresh",

      ["-"] = "actions.parent",
      ["="] = "actions.select",
      ["_"] = "actions.open_cwd", -- Change Oil to current CWD
      ["`"] = "actions.cd", -- tcd to Oil directory
      ["~"] = "actions.tcd", -- tcd (only change current tab cd) to Oil directory

      ["<M-h>"] = "actions.toggle_hidden",
      ["<M-s>"] = "actions.change_sort",
      ["<M-y>"] = "actions.copy_entry_path",
      ["<M-o>"] = "actions.open_external", -- Open item by external App
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
  },
}
