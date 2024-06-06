return {
  "ThePrimeagen/refactoring.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<leader>rs",
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      mode = { "n", "v" },
      desc = "Refactor",
    },
    {
      "<leader>ri",
      function()
        require("refactoring").refactor("Inline Variable")
      end,
      mode = { "n", "v" },
      desc = "Inline Variable",
    },
    {
      "<leader>rb",
      function()
        require("refactoring").refactor("Extract Block")
      end,
      desc = "Extract Block",
    },
    {
      "<leader>rf",
      function()
        require("refactoring").refactor("Extract Block To File")
      end,
      desc = "Extract Block To File",
    },
    {
      "<leader>rf",
      function()
        require("refactoring").refactor("Extract Function")
      end,
      mode = "v",
      desc = "Extract Function",
    },
    {
      "<leader>rF",
      function()
        require("refactoring").refactor("Extract Function To File")
      end,
      mode = "v",
      desc = "Extract Function To File",
    },
    {
      "<leader>rx",
      function()
        require("refactoring").refactor("Extract Variable")
      end,
      mode = "v",
      desc = "Extract Variable",
    },
    -- Debug
    -- {
    --   "<leader>rL",
    --   function()
    --     require("refactoring").debug.printf({ below = false })
    --   end,
    --   desc = "Debug Print Line Above",
    -- },
    -- {
    --   "<leader>rl",
    --   function()
    --     require("refactoring").debug.printf({ below = true })
    --   end,
    --   desc = "Debug Print Line Below",
    -- },
    -- {
    --   "<leader>rv",
    --   function()
    --     require("refactoring").debug.print_var({ normal = true, below = true })
    --   end,
    --   mode = { "n", "v" },
    --   desc = "Debug Print Variable Below",
    -- },
    -- {
    --   "<leader>rV",
    --   function()
    --     require("refactoring").debug.print_var({ normal = true, below = false })
    --   end,
    --   mode = { "n", "v" },
    --   desc = "Debug Print Variable Below",
    -- },
    -- {
    --   "<leader>rd",
    --   function()
    --     require("refactoring").debug.cleanup({})
    --   end,
    --   desc = "Debug Cleanup",
    -- },
  },
  opts = {
    prompt_func_return_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    prompt_func_param_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
  },
  config = function(_, opts)
    require("refactoring").setup(opts)
    if LazyVim.has("telescope.nvim") then
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("refactoring")
      end)
    end
  end,
}
