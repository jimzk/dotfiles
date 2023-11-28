return {
  -- REST API client
  -- Examples: https://github.com/rest-nvim/rest.nvim/tree/main/tests
  "rest-nvim/rest.nvim",
  dependencies = { { "nvim-lua/plenary.nvim" } },
  keys = {
    {
      "<leader>sn",
      "<cmd>vs new_request.http<cr>i# Examples: <cr>https://github.com/rest-nvim/rest.nvim/tree/main/tests<cr><c-u>GET https://example.com<esc>",
      desc = "new http request (rest)",
    },
    { "<leader>s<cr>", "<Plug>RestNvim", desc = "run http request (rest)" },
    { "<leader>sp", "<Plug>RestNvimPreview", desc = "preview http request (rest)" },
    { "<leader>sl", "<Plug>RestNvimLast", desc = "run last http request (rest)" },
  },
  opts = {}
}
