return {
  "simrat39/rust-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap"
  },
  ft = "rust",
  config = function()
    local rt = require("rust-tools")
    Util.on_attach(function(client, bufnr)
      if client.name ~= "rust_analyzer" then return end
      local opts = { buffer = bufnr }
      map("n", "J", rt.join_lines.join_lines, opts)
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
          rt.hover_actions.hover_actions()
        end
      end, "[RS] hover or peek fold", opts)
      map("v", "gh", rt.hover_range.hover_range, "[RS] hover", opts)
      map("n", "gC", rt.external_docs.open_external_docs, "[RS] open external doc", opts)
      map({ "n", "v" }, "<leader>ck", rt.runnables.runnables, "[RS] run or test code", opts)
      map("n", "<leader>cm", rt.open_cargo_toml.open_cargo_toml, "[RS] open cargo.toml", opts)
      map("n", "<leader>cp", rt.parent_module.parent_module, "[RS] go parent module", opts)
      map("n", "<C-M-j>", "<cmd>RustMoveItemDown<cr>", "[RS] move item down", opts)
      map("n", "<C-M-k>", "<cmd>RustMoveItemUp<cr>", "[RS] move item up", opts)
      map("n", "<leader>c.", function()
        vim.cmd [[silent !open "https://rust-analyzer.github.io/manual.html\#magic-completions"]]
        vim.cmd [[silent !open "https://rust-analyzer.github.io/manual.html\#format-string-completion"]]
      end, "open doc for postfix completion")
    end)
    rt.setup {
      server = require("plugins.lsp.servers")["rust_analyzer"],
      tools = {
        inlay_hints = {
          highlight = "NonText",
        },
        hover_actions = {
          auto_focus = true,
        }
      },
    }
  end
}
