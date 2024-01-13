-- rust-analyzer configuration (the value set in lsp.opts.servers["rust_analyzer"])
-- :lua print(vim.inspect(vim.lsp.get_active_clients()[1].config.settings)) for configuration inspection.
-- LazyVim configuration: https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/extras/lang/rust.lua#L90
local M = {}

M.settings = {
  -- https://github.com/rust-lang/rust-analyzer/blob/master/crates/rust-analyzer/src/config.rs#L2249-L2574
  ["rust-analyzer"] = {
    -- NOTE: experimental options: buildScripts.overrideCommand, check.allTargets, check.invocationStrategy
    cargo = {
      features = "all",
    },
    -- NOTE: this option affect performance significantly
    checkOnSave = true,
    check = {
      features = "all",
      command = "clippy",
      extraArgs = {
        "--no-deps",
      },
      -- Passing -p <package> to cargo check instead of --workspace
      workspace = false,
    },
    procMacro = {
      enable = true,
      ignored = {
        ["async-trait"] = { "async_trait" },
        ["napi-derive"] = { "napi" },
        ["async-recursion"] = { "async_recursion" },
      },
    },
    diagnostics = {
      disabled = {
        -- https://www.reddit.com/r/rust/comments/vj2ghz/comment/idhpunt/
        "unresolved-proc-macro",
      },
    },
    inlayHints = {
      -- maxLength = 100,
      bindingModeHints = {
        enable = true,
      },
    },
    hover = {
      actions = {
        references = {
          enable = true,
        },
      },
    },
    workspace = {
      symbol = {
        search = {
          -- https://github.com/rust-lang/rust-analyzer/blob/master/crates/rust-analyzer/src/config.rs#L2339
          kind = "all_symbols",
        },
      },
    },
    completion = {
      postfix = {
        -- Enable postfix like `dbg`, `if`, `not`, etc.
        -- * https://rust-analyzer.github.io/manual.html#magic-completions
        -- * https://rust-analyzer.github.io/manual.html#format-string-completion
        enable = true,
      },
      --   callable = {
      --     -- Whether to add parenthesis and argument snippets when completing function.
      --     -- Possible value: fill_arguments (default), add_parentheses, none
      --     snippets = "fill_arguments",
      --   },
      -- https://github.com/rust-lang/rust-analyzer/pull/16092
      -- Usage: call code action under `todo!()` or _ in function of struct
      termSearch = {
        enable = true,
      },
    },
  },
}

M.on_attach = function(client, bufnr)
  local function map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
  end
  map("n", "J", "<CMD>RustLsp joinLines<CR>", "[RS] Join Lines")
  map("n", "K", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    -- :h ufo.txt
    if winid then
      local buf = vim.api.nvim_win_get_buf(winid)
      local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
      for _, k in ipairs(keys) do
        vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = buf })
      end
    else
      vim.cmd("RustLsp hover actions")
    end
  end, "[RS] Hover / Peek Fold")
  map("x", "K", "<CMD>RustLsp hover range<CR>", "[RS] Hover Range")
  map("n", "<leader>cm", "<CMD>RustLsp openCargo<CR>", "[RS] Open Cargo.toml")
  map("n", "<leader>cK", "<CMD>RustLsp runnables<CR>", "[RS] Run/Test Code")
  map("n", "<leader>ck", "<CMD>RustLsp runnables last<CR>", "[RS] Run/Test Last Code")
  map("n", "<leader>cp", "<CMD>RustLsp parentModule<CR>", "[RS] Go Parent Module")
  map("n", "<leader>ca", "<CMD>RustLsp expandMacro<CR>", "[RS] Expand Macro")
  map("n", "<leader>cD", "<CMD>RustLsp debuggables<CR>", "[RS] Run Debuggables")
  map("n", "<leader>c<cr>", "<CMD>silent up<CR><CMD>RustLsp flyCheck run<CR>", "[RS] Check Code")
  map("n", "<leader>c<F1>", "<CMD>RustLsp openDocs<CR>", "[RS] Open Doc under Cursor")

  -- local next_item, prev_item = require("util").make_repeatable_move_pair(function()
  --   vim.cmd.RustLsp({ "moveItem", "down" })
  -- end, function()
  --   vim.cmd.RustLsp({ "moveItem", "up" })
  -- end)
  -- map("n", "<leader>c]", next_item, "[RS] Move Item Down")
  -- map("n", "<leader>c[", prev_item, "[RS] Move Item Up")

  map("n", "<leader>c.", function()
    vim.cmd([[silent !open "https://rust-analyzer.github.io/manual.html\#magic-completions"]])
    vim.cmd([[silent !open "https://rust-analyzer.github.io/manual.html\#format-string-completion"]])
  end, "[RS] Open Doc for Postfix Completion")

  map("n", "<leader>de", "0<CMD>RustLsp explainError<CR>", "[RS] Explain Error") -- FIX: can't show error when cursor in under the error position. So I add 0 as a workaround
  map("n", "<leader>dr", "0<CMD>RustLsp renderDiagnostic<CR>", "[RS] Render Diagnostics")

  map("n", "<leader>cs", function()
    local rust_lsp = vim.lsp.get_clients({ name = "rust-analyzer" })[1]

    local settings = rust_lsp.config.settings
    -- stylua: ignore
    require("util").toggle(
      settings["rust-analyzer"].checkOnSave,
      function()
        settings["rust-analyzer"].checkOnSave = not settings["rust-analyzer"].checkOnSave
        rust_lsp.notify("workspace/didChangeConfiguration", { settings = settings })
      end,
      "checkOnSave",
      "Rust Analyzer"
    )
  end, "[RS] Toggle checkOnSave")
end

return M
