return {
  -- GPT prompt
  "robitx/gp.nvim",
  event = "VeryLazy",
  enabled = false,
  keys = {
    { "<M-y>", "<CMD>GpChatToggle split<CR>", desc = "ChatGPT Chat" },
    -- { "<leader>T", "<CMD>GpRewrite<CR>", desc = "ChatGPT Rewrite" },
  },
  opts = function()
    return {
      openai_api_key = os.getenv("OPENAI_API_KEY"),
      openai_api_endpoint = os.getenv("OPENAI_API_ENDPOINT") or "https://api.openai.com/v1/chat/completions",
      chat_topic_gen_model = "gpt-4",
      agents = {
        -- Use GPT4 for chat commands like :GpChatNew
        {
          name = "ChatGPT4",
          chat = true,
          command = false,
          model = { model = "gpt-4", temperature = 1.1, top_p = 1 },
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
        -- Use GPT4 for text/command commands like :GpRewrite, :GpNew
        {
          name = "CodeGPT4",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4", temperature = 0.8, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are an AI working as a code editor.\n\n"
            .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
            .. "START AND END YOUR ANSWER WITH:\n\n```",
        },
      },
      chat_confirm_delete = true,
      chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-CR>" },
      chat_shortcut_delete = { modes = { "n" }, shortcut = "<BS>" },
      chat_shortcut_stop = { modes = { "n" }, shortcut = "<C-x>" },
      chat_shortcut_new = { modes = { "n" }, shortcut = "<C-t>" },
    }
  end,
  config = function(_, opts)
    local gp = require("gp")
    gp.setup(opts)
    -- https://github.com/Robitx/gp.nvim/discussions/85
    gp._state.chat_agent = "ChatGPT4"
  end,
}
