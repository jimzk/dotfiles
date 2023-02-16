return {
  -- Coding with Copilot
  "zbirenbaum/copilot.lua",
  event = "VeryLazy",
  keys = {
    { mode = { "i" }, "<C-\\>", "<cmd>Copilot panel<CR>", desc = { "Copilot suggection list" } },
  },
  config = function()
    require("copilot").setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      panel = {
        enabled = true,
        auto_refresh = true,
      },
      filetypes = {
        markdown = true,
        gitcommit = true,
        gitrebase = true,
        svn = true,
      }
    }
    local cmp = require("cmp")
    cmp.event:on("menu_opened", function()
      -- require("copilot.suggestion").dismiss()
      vim.b.copilot_suggestion_hidden = true
    end)
    cmp.event:on("menu_closed", function()
      vim.b.copilot_suggestion_hidden = false
    end)

    -- Trigger cmp if cursor is not at the end of line
    -- vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
    --   pattern = "*",
    --   callback = function()
    --     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    --     local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    --     if #text ~= col then
    --       cmp.complete()
    --     end
    --   end
    -- })
  end
}
