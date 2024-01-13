-- rust-analyzer configuration (the value set in lsp.opts.servers["rust_analyzer"])
-- :lua print(vim.inspect(vim.lsp.get_active_clients()[1].config.settings)) for configuration inspection.
-- LazyVim configuration: https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/extras/lang/rust.lua#L90
local M = {}

M.settings = {
  ["rust-analyzer"] = {
    -- NOTE: experimental options: buildScripts.overrideCommand, check.allTargets, check.invocationStrategy
    cargo = {
      features = "all",
      -- noDefaultFeatures = true,
      -- buildScripts = {
      --   --   overrideCommand = "cargo check --quiet --message-format=json --all-targets",
      --   overrideCommand = "cargo check --quiet --message-format=json",
      -- },
    },
    -- NOTE: this option affect performance significantly
    checkOnSave = true,
    check = {
      features = "all",
      -- allTargets = false,
      -- invocationStrategy = "once",
      command = "clippy",
      extraArgs = {
        "--no-deps",
      },
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
    -- completion = {
    --   postfix = {
    --     -- Enable postfix like `dbg`, `if`, `not`, etc.
    --     -- * https://rust-analyzer.github.io/manual.html#magic-completions
    --     -- * https://rust-analyzer.github.io/manual.html#format-string-completion
    --     enable = true,
    --   },
    --   callable = {
    --     -- Whether to add parenthesis and argument snippets when completing function.
    --     -- Possible value: fill_arguments (default), add_parentheses, none
    --     snippets = "fill_arguments",
    --   },
    -- },
  },
}

M.on_attach = function(client, bufnr)
  local function map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
  end
  local rt = require("rust-tools")

  map("n", "J", rt.join_lines.join_lines, "[RS] Join Lines")
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
      rt.hover_actions.hover_actions()
    end
  end, "[RS] Hover / Peek Fold")
  map("x", "K", rt.hover_range.hover_range, "[RS] Hover Types")
  map("n", "<leader>cm", rt.open_cargo_toml.open_cargo_toml, "[RS] Open Cargo.toml")
  map("n", "<leader>cK", rt.runnables.runnables, "[RS] Run/Test Code")
  map("n", "<leader>cp", rt.parent_module.parent_module, "[RS] Go Parent Module")
  map("n", "<leader>ca", rt.expand_macro.expand_macro, "[RS] Expand Macro")
  map("n", "<leader>cD", rt.debuggables.debuggables, "[RS] Run Debuggables")
  map("n", "<leader>c<cr>", "<CMD>w<CR>", "[RS] Check Code")
  map("n", "<F1>", rt.external_docs.open_external_docs, "[RS] Open Doc under Cursor")

  map("n", "<leader>oi", function()
    local enabled = not vim.g.rust_analyzer_inlay_hints_disabled
    require("util").toggle(enabled, {
      function()
        rt.inlay_hints.enable()
        vim.g.rust_analyzer_inlay_hints_disabled = false
      end,
      function()
        rt.inlay_hints.disable()
        vim.g.rust_analyzer_inlay_hints_disabled = true
      end,
    }, "Inlay Hints", "Rust Analyzer")
  end, "Toggle Inlay Hints")

  local next_item, prev_item = require("util").make_repeatable_move_pair(function()
    rt.move_item.move_item(false)
  end, function()
    rt.move_item.move_item(true)
  end)
  map("n", "<M-j>", next_item, "[RS] Move Item Down")
  map("n", "<M-k>", prev_item, "[RS] Move Item Up")

  map("n", "<leader>c.", function()
    vim.cmd([[silent !open "https://rust-analyzer.github.io/manual.html\#magic-completions"]])
    vim.cmd([[silent !open "https://rust-analyzer.github.io/manual.html\#format-string-completion"]])
  end, "[RS] Open Doc for Postfix Completion")

  map("n", "<leader>cs", function()
    local rust_lsp = vim.lsp.get_active_clients({ name = "rust_analyzer" })[1]
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
