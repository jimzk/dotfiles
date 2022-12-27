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

      h = { vim.lsp.buf.hover, "[C] hover" },
      O = { "<cmd>Lspsaga outline<cr>", "[C] symbol outline" },
      k = { "<cmd>normal m'<cr><cmd>Trouble lsp_implementations<cr>", "[C] go implementation" },
      b = { "<cmd>normal m'<cr><cmd>Trouble lsp_type_definitions<cr>", "[C] go type definition" },
      r = { "<cmd>Lspsaga lsp_finder<cr>", "[C] peek reference (lspsaga)" },
      R = { "<cmd>normal m'<cr><cmd>Trouble lsp_references<cr>", "[C] go reference" },
      ["["] = { function()
        vim.lsp.buf.incoming_calls()
        vim.cmd [[LTOpenToCalltree]]
      end, "[C] incoming call tree" },
      ["]"] = { function()
        vim.lsp.buf.outgoing_calls()
        vim.cmd [[LTOpenToCalltree]]
      end, "[C] outgoing call tree" },
    },

    ['<space>c'] = {
      w = {
        name = "lsp workspace",
        a = { function() vim.lsp.buf.add_workspace_folder() end, "add workspace folder" },
        r = { function() vim.lsp.buf.remove_workspace_folder() end, "remove workspace folder" },
        l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "list workspace folder" },
      },
      r = { "<cmd>Lspsaga rename<CR>", "rename" },
    },
    ["<M-cr>"] = { "<cmd>Lspsaga code_action<cr>", "code action" },
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
