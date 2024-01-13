local M = {
  "neovim/nvim-lspconfig",
}

-- https://www.reddit.com/r/neovim/comments/1ai19ux/execute_current_file_script_using_a_keymap_i_use/
local run_lua_file = function()
  local file = vim.fn.expand("%:p") -- Get the current file name
  local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands
  vim.cmd("!chmod +x " .. escaped_file) -- Make the file executable
  vim.cmd("vsplit") -- Split the window vertically
  vim.cmd("terminal lua " .. escaped_file) -- Open terminal and execute the file
  vim.api.nvim_feedkeys("i", "n", false) -- Enter insert mode, moves to end of prompt if there's one
end

M.opts = {
  servers = {
    lua_ls = {
      keys = {
        {
          "<leader>n.",
          run_lua_file,
          desc = "Execute Current Lua File",
        },
      },
      -- capabilities = {
      --   textDocument = {
      --     completion = {
      --       completionItem = {
      --         snippetSupport = false,
      --       },
      --     },
      --   },
      -- },
      settings = {
        -- https://luals.github.io/wiki/configuration/#configuration-file
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            -- Replace: complete with arguments
            -- Dsiable: completion withoutarguments.
            callSnippet = "Replace",
          },
        },
      },
      handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "single",
        }),
        -- Call vim.lsp.definition under `local foo = function() end` shows
        -- two results in the same line. Seems like a lua_ls bug. Fix it.
        -- https://www.reddit.com/r/neovim/comments/19cvgtp/comment/kj1yevl
        ["textDocument/definition"] = function(err, result, ctx, config)
          if result and #result == 2 and type(result) == "table" then
            result = { result[2] }
          end
          vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
        end,
      },
    },
  },
}

return M
