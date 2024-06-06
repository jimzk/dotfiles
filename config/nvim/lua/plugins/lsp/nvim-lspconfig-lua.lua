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
        ["textDocument/definition"] = function(err, results, ctx, config)
          if results then
            if #results >= 2 and type(results) == "table" then
              if results[1].targetRange.start.line == results[2].targetRange.start.line then
                table.remove(results, 1)
              end
            end
            local uri = vim.uri_from_bufnr(0)
            local cursor = vim.api.nvim_win_get_cursor(0)
            for idx, result in pairs(results) do
              if result.targetUri == uri and result.targetRange.start.line == cursor[1] - 1 then
                table.remove(results, idx)
                -- break
                -- return
              end
            end
            results = { results[1] }
          end
          vim.lsp.handlers["textDocument/definition"](err, results, ctx, config)
        end,
      },
    },
  },
}

return M
