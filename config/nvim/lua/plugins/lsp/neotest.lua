local M = {
  -- Test Everything
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
  },
}

M.keys = function()
  -- stylua: ignore
  return {
    { "<leader>t<M-S-cr>", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Tests in Workspace" },
    { "<leader>t<S-cr>", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run All Tests in File" },
    { "<leader>t<cr>", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last Test" },

    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
    { "<leader>tD", function() require("neotest").run.run_last({ strategy = "dap" }) end, desc = "Debug Last Test" },

    { "<leader>tp", function() require("neotest").run.stop({ interactive = true }) end, desc = "Stop Test" },

    { "<leader>to", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary Panel" },
    { "<leader>tr", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Test Result" },
    { "<leader>tR", function() require("neotest").output_panel.toggle() end, desc = "Toggle Test Result Panel" },
    { "<leader>ts", function() require("neotest").run.attach({ interactive = true }) end, desc = "Show Test Running Status" },
  }
end

return M
