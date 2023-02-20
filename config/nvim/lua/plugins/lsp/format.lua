local M = {}

M.autoformat = false

function M.toggle()
  local lazy_util = require("lazy.core.util")
  M.autoformat = not M.autoformat
  if M.autoformat then
    lazy_util.info("Enabled format on save", { title = "Format" })
  else
    lazy_util.warn("Disabled format on save", { title = "Format" })
  end
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0
  vim.cmd [[up]]
  vim.lsp.buf.format({
    bufnr = buf,
    formatting_options = nil,
    timeout_ms = nil,
    -- async = true,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      else
        return client.name ~= "null-ls"
      end
    end,
  })
end

function M.on_attach(client, buf)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd({ "BufWritePre", "BufLeave", "FocusLost" }, {
      group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
      buffer = buf,
      callback = function()
        if M.autoformat then M.format() end
      end,
    })
  end
end

return M
