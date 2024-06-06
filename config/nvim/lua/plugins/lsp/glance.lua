return {
  "dnlhc/glance.nvim",
  event = "VeryLazy",
  enabled = false,
  opts = {
    hooks = {
      before_open = function(results, open, jump, method)
        if method == "definitions" then
          if results and #results >= 2 and type(results) == "table" then
            if results[1].targetRange.start.line == results[2].targetRange.start.line then
              table.remove(results, 1)
            end
          end
          local uri = vim.uri_from_bufnr(0)
          local cursor = vim.api.nvim_win_get_cursor(0)
          for idx, result in pairs(results) do
            if result.targetUri == uri and result.targetRange.start.line == cursor[1] - 1 then
              table.remove(results, idx)
              break
            end
          end
          results = { results[1] }
        end
        if #results == 1 then
          jump(results[1]) -- argument is optional
        else
          open(results) -- argument is optional
        end
      end,
    },
  },
  config = function(_, opts)
    require("glance").setup(opts)
    vim.defer_fn(function()
      local map = Util.map
      -- -- map("n", "<C-LeftMouse>", "<LeftMouse><cmd>Glance definitions<cr>", "Jump to Definition (Galance)")
      -- Util.definitions_or_reference = function()
      --   local cursor1 = vim.api.nvim_win_get_cursor(0)
      --   vim.lsp.buf.definition()
      --   local cursor2
      --   vim.defer_fn(function()
      --     local cursor2 = vim.api.nvim_win_get_cursor(0)
      --     if cursor1[1] == cursor2[1] and cursor1[2] == cursor2[2] then
      --       vim.notify("Stayed", vim.log.levels.INFO, { title = "Notification" })
      --     end
      --   end, 100)
      -- end
      -- map(
      --   "n",
      --   "<C-LeftMouse>",
      --   "<LeftMouse><cmd>lua Util.definitions_or_reference()<cr>",
      --   "Jump to Definition (Galance)"
      -- )
      -- map("n", "<C-2-LeftMouse>", "<cmd>Glance references<cr>", "Jump to References (Galance)")
      -- map("n", "<C-2-LeftMouse>", vim.lsp.buf.references, "Jump to References (Galance)")
      map("n", "<C-2-RightMouse>", "<LeftMouse><cmd>Glance references<cr>", "Jump to References (Galance)")
      -- map("n", "<C-RightMouse>", "<C-o>", "Jump Back")
    end, 1000)
  end,
}
