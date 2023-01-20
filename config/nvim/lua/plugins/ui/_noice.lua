-- noicer ui
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      progress = {
        enabled = false,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = false,
      long_message_to_split = true,
    },
    routes = {
      -- kind list: https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages#handling-hit-enter-messages
      --
      -- Fix Noice breaks nvim.surround when using min.ai together
      -- https://github.com/echasnovski/mini.nvim/issues/163#issuecomment-1321762041
      {
        filter = {
          event = "msg_show",
          kind = "echomsg",
          find = "No textobject",
        },
        opts = { skip = true },
      },
      -- Avoid written messages
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      -- Avoid modifiable message
      {
        filter = {
          event = "msg_show",
          kind = "emsg",
          find = "modifiable",
        },
        opts = { skip = true },
      },
      -- Avoid change message
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "fewer lines",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "change;",
        },
        opts = { skip = true },
      },
      -- Avoid search not found error
      -- {
      --   filter = {
      --     event = "msg_show",
      --     kind = "emsg",
      --     find = "Pattern not found",
      --   },
      --   opts = { skip = true },
      -- },
      -- Avoid search prompt message
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "^/",
        },
        opts = { skip = true },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "redirect cmdline" },
    -- { "<C-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true,
    -- desc = "which_key_ignore" },
    { "<C-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,
      expr = true, desc = "which_key_ignore" },
  },
}
