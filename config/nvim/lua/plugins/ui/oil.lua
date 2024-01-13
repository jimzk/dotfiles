return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "Oil" },
  keys = {
    {
      "<M-o>",
      function()
        if vim.bo.filetype == "oil" then
          require("mini.bufremove").delete(0)
        else
          vim.cmd("Oil")
        end
      end,
      desc = "Open Oil",
    },
    {
      "<M-S-o>",
      -- "<CMD>Neotree close<CR><CMD>vert topleft split<CR><CMD>vertical resize 44<CR><CMD>Oil<CR>",
      "<CMD>Neotree close<CR><CMD>vert topleft split<CR><CMD>Oil<CR>",
      desc = "Open Oil Split",
    },
  },
  opts = {
    win_options = {
      signcolumn = "number",
      relativenumber = false,
    },
    delete_to_trash = true,
    use_default_keymaps = false,
    keymaps = {
      ["?"] = "actions.show_help",
      ["<Esc>"] = { callback = "<CMD>close<CR>", desc = "close", mode = "n" }, -- close window

      ["<CR>"] = "actions.select",

      -- ["<C-o>"] = "",
      -- ["<C-i>"] = "",

      ["<C-v>"] = "actions.select_vsplit",
      ["<C-s>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",

      ["<C-p>"] = "actions.preview",
      ["<C-r>"] = "actions.refresh",
      ["q"] = "actions.close",

      ["h"] = "actions.parent",
      ["l"] = "actions.select",
      ["_"] = "actions.open_cwd",

      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",

      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",

      ["<C-q>"] = "actions.send_to_qflist",
      ["<C-l>"] = "actions.send_to_loclist",
      ["g<C-q>"] = "actions.add_to_qflist",
      ["g<C-l>"] = "actions.add_to_loclist",
    },
    float = {
      max_width = 50,
      max_height = 50,
      win_options = {
        winblend = 70,
      },
    },
    preview = {
      min_width = { 100, 0.6 },
    },
  },
}
