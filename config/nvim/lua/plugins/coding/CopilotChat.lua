return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  },
  keys = function()
    local open_set_layout_fn = function(layout)
      return function()
        local chat = require("CopilotChat")
        chat.config.window = vim.tbl_deep_extend("force", chat.config.window, {
          layout = layout,
          height = layout == "horizontal" and 0.4 or 0.6,
        })
        chat.close()
        chat.open()
      end
    end

    local ask_something_fn = function(system_prompt, input_title)
      return function()
        local on_confirm = function(input)
          if vim.fn.empty(input) ~= 1 then
            require("CopilotChat").ask(input, {
              system_prompt = system_prompt .. "\n无论我用什么语言提问，都请用中文回答。",
            })
          end
        end
        vim.ui.input({ prompt = input_title }, on_confirm)
      end
    end

    return {
      { mode = { "n", "x", "i" }, "<C-CR>", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
      { mode = { "n", "x" }, "<leader>kx", "<cmd>CopilotChatReset<CR>", desc = "Clear Copilot Chat" },
      { "<leader>kv", open_set_layout_fn("vertical"), desc = "Layout Vertical Split" },
      { "<leader>ks", open_set_layout_fn("horizontal"), desc = "Layout Split" },
      { "<leader>kf", open_set_layout_fn("float"), desc = "Layout Float" },
      {
        "<leader>kn",
        ask_something_fn(
          [[你是一个精通Neovim和Lua的专家。我会问你Lua和Neovim的问题，请用简单易懂的语言为我回答，并尽量用lua api实现我的需求。]],
          "请输入neovim和lua的问题："
        ),
        desc = "Ask about Neovim/Lua",
      },
      {
        "<leader>kr",
        ask_something_fn(
          [[你是一个精通Rust的专家。我会问你有关Rust的问题，请用简单易懂的语言为我回答。]],
          "请输入Rust的问题："
        ),
        desc = "Ask about Rust",
      },
      {
        mode = { "n", "x" },
        "<leader>ke",
        function()
          local mode = vim.fn.mode()
          if mode == "n" then
            local total_lines = vim.api.nvim_buf_line_count(0)
            local max_lines = 600
            if total_lines > max_lines then
              local answer =
                vim.fn.input(string.format("当前文件的行数超过 %d 行, 是否继续？(y/n): ", max_lines))
              -- stylua: ignore
              if answer:lower() ~= "y" then return end
            end
          end
          local prompt = string.format("/COPILOT_EXPLAIN 解释这段 %s 代码", vim.bo.filetype)
          require("CopilotChat").ask(prompt, {
            prompt = prompt,
            selection = function(source)
              local select = require("CopilotChat.select")
              return select.visual(source) or select.buffer(source)
            end,
          })
        end,
        desc = "Explain Code",
      },
      { mode = "x", "<leader>kc", "<cmd>CopilotChatDocs<cr>", desc = "Generate Documentations Comments for Selection" },
      { mode = "x", "<leader>kt", "<cmd>CopilotChatTests<cr>", desc = "Generate Tests for Selection" },
      { mode = "x", "<leader>kp", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize Selected Code" },
      {
        "<leader>kl",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "List Avaliable AI Prompts",
      },
      {
        "<leader>kd",
        function()
          local actions = require("CopilotChat.actions")
          local help = actions.help_actions()
          if not help then
            LazyVim.warn("No diagnostics found on the current line")
            return
          end
          require("CopilotChat.integrations.telescope").pick(help)
        end,
        desc = "Diagnostic Action (CopilotChat)",
        mode = { "n", "v" },
      },
    }
  end,
  opts = {
    debug = false,
    -- https://news.ycombinator.com/item?id=40474716
    system_prompt = string.format(
      [[You are an AI programming assistant.
You use the GPT-4 version of OpenAI's GPT models.
When asked for your name, you must respond with "GitHub Copilot".
Follow the user's requirements carefully & to the letter.
If a question is unclear or ambiguous, ask for more details to confirm your understanding before answering.
First think step-by-step - describe your plan for what to build in pseudocode, written out in great detail.
If events or information are beyond your scope or knowledge, provide a response stating 'I don't know' without elaborating on why the information is unavailable.
Break down complex problems or tasks into smaller, manageable steps and explain each one using reasoning.
Then output the code in a single code block. This code block should not contain line numbers.
Keep your answers short and impersonal.
Minimize any other prose.
Use Markdown formatting in your answers.
Make sure to include the programming language name at the start of the Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The user is working on a %s machine. Please respond with system specific commands if applicable.
The active document is the source code the user is looking at right now.
You can only give one reply for each conversation turn.
You must reply in Chinese language unless the answer is documentations, comments, code or git commit message.
]],
      vim.loop.os_uname().sysname
    ),
    model = "gpt-4",
    question_header = " User ",
    answer_header = "  Copilot ",
    selection = function(source)
      local select = require("CopilotChat.select")
      return select.visual(source) or select.buffer(source)
    end,
    auto_follow_cursor = false,
    auto_insert_mode = true,
    window = {
      layout = "vertical",
      relative = "cursor",
      width = 0.4,
      height = 0.6,
      row = 1,
      col = -10,
    },
    mappings = {
      reset = {
        normal = "<C-r>",
        insert = "<C-r>",
      },
      submit_prompt = {
        normal = "<CR>",
        insert = "<CR>",
      },
      close = {
        normal = "q",
      },
    },
  },
  config = function(_, opts)
    local chat = require("CopilotChat")
    require("CopilotChat.integrations.cmp").setup()

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function(opts)
        local columns = vim.o.columns
        local win_width = vim.api.nvim_win_get_width(0)
        local is_horizontal = win_width == columns
        if is_horizontal then
          vim.opt_local.number = true
          vim.opt_local.signcolumn = "auto"
        else
          vim.opt_local.number = false
          vim.opt_local.signcolumn = "no"
        end
        local map = Util.map
        local bufnr = opts.buf
        map("i", "<S-CR>", "<CR>", nil, { buffer = bufnr })
      end,
    })
    require("which-key").register({
      ["<leader>k"] = { name = "+Copilot Chat" },
    })
    chat.setup(opts)
  end,
}
