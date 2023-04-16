return {
  -- Program with ChatGPT
  "Bryley/neoai.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = {
    "NeoAI",
    "NeoAIOpen",
    "NeoAIClose",
    "NeoAIToggle",
    "NeoAIContext",
    "NeoAIContextOpen",
    "NeoAIContextClose",
    "NeoAIInject",
    "NeoAIInjectCode",
    "NeoAIInjectContext",
    "NeoAIInjectContextCode",
  },
  keys = {
    { "<leader>T", mode = { "x" }, desc = "summarize text by ChatGpt (neoai)" },
    { "<leader>gm", desc = "generate git message by ChatGPT (neoai)" },
    { "<leader>t", "<cmd>NeoAI<cr>", mode = { "n" }, desc = "ask ChatGPT (neoai)" },
    { "<leader>t", ":'<,'>NeoAIContext<cr>", mode = { "x" }, desc = "ask ChatGPT with selection (neoai)" },
  },
  opts = {
    shortcuts = {
      {
        name = "textify",
        key = "<leader>T",
        desc = "fix text with AI",
        use_context = true,
        prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
        modes = { "v" },
        strip_function = nil,
      },
      {
        name = "gitcommit",
        key = "<leader>gm",
        desc = "generate git commit message",
        use_context = false,
        prompt = function()
          return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
        end,
        modes = { "n" },
        strip_function = nil,
      },
    },
  },
}
