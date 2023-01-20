return {
  "simrat39/rust-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap"
  },
  ft = "rust",
  config = function()
    local rt = require("rust-tools")
    rt.setup {
      server = {
        on_attach = function(_, bufnr)
          local opts = { buffer = bufnr }
          map("n", "J", rt.join_lines.join_lines, opts)
          map("n", "gh", function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then rt.hover_actions.hover_actions() end
          end, "[RS] hover or peek fold", opts)
          map("n", "gC", rt.external_docs.open_external_docs, "[RS] open external doc", opts)
          map({ "n", "v" }, "<leader>ck", rt.runnables.runnables, "[RS] check code if runnable", opts)
          map("n", "<leader>cm", rt.open_cargo_toml.open_cargo_toml, "[RS] open cargo.toml", opts)
          map("n", "<leader>cp", rt.parent_module.parent_module, "[RS] go parent module", opts)
          map("n", "<C-M-]", "<cmd>RustMoveItemDown<cr>", "[RS] move item down", opts)
          map("n", "<C-M-[", "<cmd>RustMoveItemUp<cr>", "[RS] move item up", opts)
          map("v", "gh", rt.hover_range.hover_range, "[RS] hover", opts)
        end
      },
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
