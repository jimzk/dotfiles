local M = {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
  },
}

M.init = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "neotest-summary" },
    callback = function()
      vim.wo.signcolumn = "no"
    end,
  })
end

M.keys = function()
  -- stylua: ignore
  return {
    { "<leader>tw", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Tests in Workspace" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run All Tests in File" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last Test" },

    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
    -- { "<leader>tD", function() require("neotest").run.run_last({ strategy = "dap" }) end, desc = "Debug Last Test" },

    { "<leader>ts", function() require("neotest").run.stop({ interactive = true }) end, desc = "Stop Test" },

    { "<leader>tO", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary Panel" },
    { "<leader>tp", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Test Result" },
    { "<leader>tP", function() require("neotest").output_panel.toggle() end, desc = "Toggle Test Result Panel" },

    { "<leader>ta", function() require("neotest").run.attach({ interactive = true }) end, desc = "Attach Test" },
  }
end

return M
