local M = {}
local rt = require("rust-tools")
local post_setup = function(bufnr)
  ------ rust.vim
  vim.g.rust = vim.env.HOME .. "/.cargo/bin/rustc"
  vim.g.rust_fold = 1
  -- vim.g.rustfmt_command = 'cargo clippy'
  vim.g.rustfmt_options = ''
  vim.g.rustfmt_autosave = 0
  vim.g.rustfmt_autosave_if_config_present = 0 -- auto save with format
  vim.g.rustfmt_fail_silently = 0 -- report error
  -- vim.g.rust_clip_command = 'pbcopy'

  local wk = require("which-key")
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  wk.register({
    ["<leader>cR"] = { function()
      vim.cmd [[normal! "qy]] -- remember visual mark
      local url = vim.api.nvim_exec([['<,'>RustPlay]], true)
      vim.cmd("!open " .. vim.fn.substitute(url, ".*Done: ", "", ""))
    end, "[R] run visual code in playground", mode = { "v" } }
  }, bufopts)
  wk.register({
    ["<leader>cR"] = { function()
      local url = vim.api.nvim_exec([[RustPlay]], true)
      vim.cmd("!open " .. vim.fn.substitute(url, ".*Done: ", "", ""))
    end, "[R] run entire code in playground" }
  }, bufopts)

  ------ rust-tools.nvim
  vim.keymap.set("v", "gh", rt.hover_range.hover_range, bufopts)
  wk.register({
    ["J"] = { rt.join_lines.join_lines, "[R] join lines" },
    ["gh"] = { function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        rt.hover_actions.hover_actions()
      end
    end, "[R] hover or peek fold" },
    ["gC"] = { rt.external_docs.open_external_docs, "[R] open external doc" },
    ["<leader>c"] = {
      k = { rt.runnables.runnables, "[R] check code if runnable", mode = { "n", "v" } },
      m = { rt.open_cargo_toml.open_cargo_toml, "[R] open cargo.toml" },
      p = { rt.parent_module.parent_module, "[R] go parent module" },
    },
  }, bufopts)
end

local rust_analyzer = {
  -- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
  -- https://rust-analyzer.github.io/manual.html
  settings = {
    ["rust-analyzer"] = {
      completion = {
        postfix = {
          enable = true,
        },
        callable = {
          snippets = "add_parentheses", -- Do not complete with arguments. Consistent with ray-x/lsp_signature.nvim
        }
      }
    }
  }
}

M.create_config = function(config)
  return vim.tbl_extend("force", config, rust_analyzer)
end

M.post_setup = function(configs)
  local config = configs["rust_analyzer"]
  local on_attach = config["on_attach"]
  config["on_attach"] = function(client, bufnr)
    on_attach(client, bufnr)
    post_setup(bufnr)
  end
  rt.setup({
    server = config,
    tools = {
      inlay_hints = {
        highlight = "NonText",
      },
      hover_actions = {
        auto_focus = true,
      }
    },
  })
end

return M
