return {
  "rust-lang/rust.vim",
  dependencies = {
    "mattn/webapi-vim",
  },
  ft = "rust",
  init = function()
    vim.g.rust = vim.env.HOME .. "/.cargo/bin/rustc"
    vim.g.rust_fold = 1
    -- vim.g.rustfmt_command = 'cargo clippy'
    vim.g.rustfmt_options = ""
    vim.g.rustfmt_autosave = 0
    vim.g.rustfmt_autosave_if_config_present = 0 -- auto save with format
    vim.g.rustfmt_fail_silently = 0 -- report error
    -- vim.g.rust_clip_command = 'pbcopy'

    Util.on_attach(function(client, bufnr)
      if client.name ~= "rust_analyzer" then return end
      local opts = { noremap = true, silent = true, buffer = bufnr }
      map("v", "<leader>c<c-cr>", function()
        vim.cmd([[normal! "qy]]) -- remember visual mark
        local url = vim.api.nvim_exec([['<,'>RustPlay]], true)
        vim.cmd("!open " .. vim.fn.substitute(url, ".*Done: ", "", ""))
      end, "[RS] run *.rs in playground", opts)
      map("n", "<leader>c<c-cr>", function()
        local url = vim.api.nvim_exec([[RustPlay]], true)
        vim.cmd("!open " .. vim.fn.substitute(url, ".*Done: ", "", ""))
      end, "[RS] run *.rs in playground", opts)
    end)
  end,
}
