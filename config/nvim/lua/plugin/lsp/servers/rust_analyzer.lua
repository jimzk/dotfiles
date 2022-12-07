local M = {}
local rt = require("rust-tools")
local post_setup = function(bufnr)
  ------ rust.vim
  vim.g.rust = vim.env.HOME .. "/.cargo/bin/rustc"
  vim.g.rust_fold = 1
  vim.g.rustfmt_autosave = 1
  vim.g.rustfmt_command = 'cargo clippy'
  vim.g.rustfmt_options = ''
  vim.g.rustfmt_autosave_if_config_present = 1 -- auto save with format
  vim.g.rustfmt_fail_silently = 0 -- report error
  -- vim.g.rust_clip_command = 'pbcopy'

  local wk = require("which-key")
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  wk.register({
    ["<leader>cl"] = { function()
      -- TODO: async run
      vim.cmd [[normal! "qy]] -- remember visual mark
      local url = vim.api.nvim_exec([['<,'>RustPlay]], true)
      vim.cmd("!open " .. vim.fn.substitute(url, ".*Done: ", "", ""))
    end, "run code", { mode = "v" } }
  }, bufopts)
  wk.register({
    ["<leader>cl"] = { function()
      local url = vim.api.nvim_exec([[RustPlay]], true)
      vim.cmd("!open " .. vim.fn.substitute(url, ".*Done: ", "", ""))
    end, "run code" }
  }, bufopts)

  ------ rust-tools.nvim
  vim.keymap.set("v", "gh", rt.hover_range.hover_range, bufopts)
  wk.register({
    ["J"] = { function()
      rt.join_lines.join_lines()
    end, "[R] join lines" },
  }, bufopts)
end

local rust_analyzer = {
  -- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
  settings = {
    ["rust-analyzer"] = {
      completion = {
        postfix = {
          enable = true,
        },
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
    },
  })
end

return M
