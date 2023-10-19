return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Oil break rust-tools' :RustOpenExternalDocs (https://github.com/simrat39/rust-tools.nvim/pull/431)
  -- But it works for rustaceanvim.
  event = "BufRead",
  keys = {
    {
      "<leader>\\",
      "<CMD>Neotree close<CR><CMD>vert topleft split<CR><CMD>vertical resize 40<CR><CMD>Oil<CR>",
      desc = "open parent directory by Oil"
    }
  },
  opts = {
    delete_to_trash = true,
    use_default_keymaps = false,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-s>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<Esc>"] = { callback = "<CMD>close<CR>", desc = "close", mode = "n" }, -- close window
      ["<C-r>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["="] = "actions.select",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
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
    }
  },

}
