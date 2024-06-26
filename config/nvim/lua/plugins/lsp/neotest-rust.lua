return {
  "rouge8/neotest-rust",
  ft = "rust",
  enabled = false,
  dependencies = {
    "nvim-neotest/neotest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rust")({
          args = { "--no-capture", "--run-ignored all" },
        }),
      },
    })
  end,
}
