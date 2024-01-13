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
    { "<leader>s<cr>", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
    { "<leader>s<S-cr>", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run All Tests in File" },
    { "<leader>s<M-S-cr>", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Tests in Workspace" },
    { "<leader>sl", function() require("neotest").run.run_last() end, desc = "Run Last Test" },

    { "<leader>sd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
    { "<leader>sD", function() require("neotest").run.run_last({ strategy = "dap" }) end, desc = "Debug Last Test" },

    { "<leader>sp", function() require("neotest").run.stop({ interactive = true }) end, desc = "Stop Test" },

    { "<leader>so", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary Panel" },
    { "<leader>sr", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Test Result" },
    { "<leader>sR", function() require("neotest").output_panel.toggle() end, desc = "Toggle Test Result Panel" },
    { "<leader>ss", function() require("neotest").run.attach({ interactive = true }) end, desc = "Show Test Running Status" },
  }
end

return M
