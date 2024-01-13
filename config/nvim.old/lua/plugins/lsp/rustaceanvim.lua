return {
  -- A heavily modified fork of rust-tools
  "mrcjkb/rustaceanvim",
  version = "^3", -- Recommended
  dependencies = {
    "nvim-lua/plenary.nvim",

    "mfussenegger/nvim-dap",
    {
      "lvimuser/lsp-inlayhints.nvim",
      opts = {},
    },
  },
  ft = { "rust" },
  config = function()
    local default_opts = require("plugins.lsp.servers.default_opts")()
    local server_opts = require("plugins.lsp.servers.rust_analyzer")
    server_opts = vim.tbl_extend("force", default_opts, server_opts)
    server_opts.on_attach = function(client, bufnr)
      require("lsp-inlayhints").on_attach(client, bufnr)
      require("lsp-inlayhints").show()
      local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end
      map("n", "J", "<CMD>RustLsp joinLines<CR>", "[RS] join lines")
      map("n", "gh", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        -- :h ufo.txt
        if winid then
          local buf = vim.api.nvim_win_get_buf(winid)
          local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
          for _, k in ipairs(keys) do
            vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = buf })
          end
        else
          vim.cmd("RustLsp hover actions")
        end
      end, "[RS] hover or peek fold")
      map("x", "gh", "<CMD>RustLsp hover range<CR>", "[RS] hover types")
      map("n", "gO", "<CMD>RustLsp externalDocs<CR>", "[RS] open documentation on cursor")
      map("n", "<leader>cK", "<CMD>RustLsp runnables<CR>", "[RS] run or test code")
      map("n", "<leader>ck", "<CMD>RustLsp runnables last<CR>", "[RS] re-run or test code")
      map("n", "<leader>cm", "<CMD>RustLsp openCargo<CR>", "[RS] open cargo.toml")
      map("n", "<leader>cp", "<CMD<RustLsp parentModule<CR>", "[RS] go parent module")
      map("n", "<leader>ca", "<CMD>RustLsp expandMacro<CR>", "[RS] expand macro")
      map("n", "<M-down>", "<cmd>RustMoveItemDown<cr>", "[RS] move item down")
      map("n", "<M-up>", "<cmd>RustMoveItemUp<cr>", "[RS] move item up")
      map("n", "<leader>c.", function()
        vim.cmd([[silent !open "https://rust-analyzer.github.io/manual.html\#magic-completions"]])
        vim.cmd([[silent !open "https://rust-analyzer.github.io/manual.html\#format-string-completion"]])
      end, "[RS] open doc for postfix completion")
    end
    -- https://github.com/mrcjkb/rustaceanvim/blob/master/lua/rustaceanvim/config/internal.lua
    vim.g.rustaceanvim = {
      tools = {
        hover_actions = {
          auto_focus = true,
        },
      },
      server = server_opts,
    }
  end,
}
