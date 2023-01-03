local wk = require("which-key")
local M = {}
-- LSP keymapping
-- tweak by lspsaga (https://github.com/glepnir/lspsaga.nvim#configuration)
-- under lspconfig (https://github.com/neovim/nvim-lspconfig#suggested-configuration)
M.setup = function(bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  wk.register({
    ['[X'] = { function() vim.diagnostic.goto_prev { float = true } end, "[C] previous diagnostic (native)" },
    [']X'] = { function() vim.diagnostic.goto_next { float = true } end, "[C] next diagnostic (native)" },
    -- FIX: too small height
    -- https://github.com/glepnir/lspsaga.nvim/issues/594
    ['[x'] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "[C] previous diagnostic" },
    [']x'] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "[C] next diagnostic" },
    ["[<C-x>"] = { function()
      require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, "[C] previous error" },
    ["]<C-x>"] = { function()
      require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, "[C] next error" },
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
        vim.cmd("normal m'")
        vim.cmd("Trouble document_diagnostics")
        vim.keymap.set("n", "gX", ":TroubleClose<cr>", { buffer = true, silent = true })
      end, "[C] list all diagnostics in buffer" },
      -- X = {"<cmd>normal m'<cr><cmd>Trouble workspace_diagnostics<cr>", "[C] show all diagnostics in workspace"},
      ["<C-x>"] = { function()
        vim.cmd("normal m'")
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
      H = { "<cmd>Lspsaga lsp_finder<cr>", "[C] detailed hover (lspsaga)" },
      ["<C-h>"] = { "<cmd>Lspsaga hover_doc<CR>", "[C] hover (lspsaga)" },  -- Not much useful
      o = { function()
        vim.cmd("LSoutlineToggle")
      end, "[C] symbol outline" },
      -- k = {function() vim.lsp.buf.implementation() end, "[C] go implementation"},
      k = { "<cmd>normal m'<cr><cmd>Trouble lsp_implementations<cr>", "[C] go implementation" },
      s = { function() vim.lsp.buf.signature_help() end, "[C] signature help (<C-s>)" },
      -- b = {function() vim.lsp.buf.type_definition() end, "[C] go type definition"},
      b = { "<cmd>normal m'<cr><cmd>Trouble lsp_type_definitions<cr>", "[C] go type definition" },
      -- r = {function() vim.lsp.buf.references() end, "[C] reference list"},
      r = { "<cmd>normal m'<cr><cmd>Trouble lsp_references<cr>", "[C] go reference" },
    },

    ['<space>c'] = {
      w = {
        name = "lsp workspace",
        a = { function() vim.lsp.buf.add_workspace_folder() end, "add workspace folder" },
        r = { function() vim.lsp.buf.remove_workspace_folder() end, "remove workspace folder" },
        l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "list workspace folder" },
      },
      -- r = {function() vim.lsp.buf.rename() end, "rename"},
      r = { "<cmd>Lspsaga rename<CR>", "rename" },
      -- a = {function() vim.lsp.buf.code_action() end, "code action"},
      a = { "<cmd>Lspsaga code_action<CR>", "code action" },
      f = { function()
        vim.lsp.buf.format { async = false }
        vim.cmd [[w]] -- Save after format
      end, "format file (by lsp)", mode = { "n", "v" } },
    },
  }, bufopts)
  vim.keymap.set({ "i", "v" }, "<C-space>", vim.lsp.buf.signature_help,
    vim.tbl_extend("force", bufopts, { desc = "[C] peek signature" }))
end

return M
