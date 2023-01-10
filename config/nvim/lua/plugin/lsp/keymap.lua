local wk = require("which-key")
local M = {}
-- LSP keymapping
-- tweak by lspsaga (https://github.com/glepnir/lspsaga.nvim#configuration)
-- under lspconfig (https://github.com/neovim/nvim-lspconfig#suggested-configuration)
M.setup = function(bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  wk.register({
    ['[x'] = { function() vim.diagnostic.goto_prev { float = true } end, "[C] prev diagnostic" },
    [']x'] = { function() vim.diagnostic.goto_next { float = true } end, "[C] next diagnostic" },
  }, bufopts)

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  wk.register({
    g = {
      -- list opened by trouble
      -- TODO: how to use?
      [";"] = { "<cmd>TroubleToggle quickfix<cr>", "[C] go quickfix list" },
      ["'"] = { "<cmd>TroubleToggle loclist<cr>", "[C] go location list" },

      x = { function() vim.diagnostic.open_float { height = 10, width = 60 } end, "[C] peek diagnostic in current line" },
      -- FIX: Windows from Lspsaga is too short and always wrapped.
      --https://github.com/glepnir/lspsaga.nvim/issues/594
      -- x = { "<cmd>Lspsaga show_line_diagnostics<CR>", "[C] show current diagnostic" },
      X = { function()
        vim.cmd("Trouble document_diagnostics")
        vim.keymap.set("n", "gX", ":TroubleClose<cr>", { buffer = true, silent = true })
      end, "[C] list all diagnostics in buffer" },
      ["<C-x>"] = { function()
        vim.cmd("Trouble workspace_diagnostics")
        vim.keymap.set("n", "g<C-x>", ":TroubleClose<cr>", { buffer = true, silent = true })
      end, "[C] list all diagnostics in workspace" },
      -- ['<space> = {function() vim.diagnostic.setloclist() end, "show diagnostics in location list"},

      -- D = {function() vim.lsp.buf.definition() end, "[C] peek definition"},
      -- D = {function() vim.lsp.buf.declaration() end, "[C] declaration"},
      -- TODO: after gd, enable number
      d = { "<cmd>Lspsaga peek_definition<cr>", "[C] peek definition" },
      D = { "<cmd>normal m'<cr><cmd>Trouble lsp_definitions<cr>", "[C] go definition" },
      h = { function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, "[C] hover or peek fold" },
      O = { "<cmd>Lspsaga outline<cr>", "[C] symbol outline" },
      I = { "<cmd>normal m'<cr><cmd>Trouble lsp_implementations<cr>", "[C] go implementation" },
      b = { "<cmd>normal m'<cr><cmd>Trouble lsp_type_definitions<cr>", "[C] go type definition" },
      r = { "<cmd>Lspsaga lsp_finder<cr>", "[C] peek reference (lspsaga)" },
      R = { "<cmd>normal m'<cr><cmd>Trouble lsp_references<cr>", "[C] go reference" },
      ["["] = { vim.lsp.buf.incoming_calls, "[C] incoming call tree" },
      ["]"] = { vim.lsp.buf.outgoing_calls, "[C] outgoing call tree" },
    },

    ['<space>e'] = {
      w = {
        name = "lsp workspace",
        a = { function() vim.lsp.buf.add_workspace_folder() end, "add workspace folder" },
        r = { function() vim.lsp.buf.remove_workspace_folder() end, "remove workspace folder" },
        l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "list workspace folder" },
      },
      -- r = { "<cmd>Lspsaga rename<CR>", "rename" },
      r = { vim.lsp.buf.rename, "rename" },
    },
    ["<M-S-cr>"] = { "<cmd>Lspsaga code_action<cr>", "code action" },
    ["<M-cr>"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action" },
  }, bufopts)

  vim.keymap.set({ "n", "i", "v" }, "<C-space>", vim.lsp.buf.signature_help,
    vim.tbl_extend("force", bufopts, { desc = "[C] peek signature" }))
  vim.keymap.set("n", "g\\", function()
    if vim.bo.filetype == "calltree" then
      vim.cmd [[q]]
    else
      vim.cmd [[LTOpenToCalltree]]
    end
  end, { desc = "[C] toggle call tree" })
end

return M
