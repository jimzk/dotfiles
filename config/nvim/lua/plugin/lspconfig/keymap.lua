
local wk = require("which-key")
local M = {}
-- LSP keymapping
-- tweak by lspsaga (https://github.com/glepnir/lspsaga.nvim#configuration)
-- under lspconfig (https://github.com/neovim/nvim-lspconfig#suggested-configuration)
M.setup = function()
  wk.register({
  ['[x'] = { function() vim.diagnostic.goto_prev { float = false } end, "[C] go previous diagnostic" },
  [']x'] = { function() vim.diagnostic.goto_next { float = false } end, "[C] go next diagnostic" },
  -- FIX: too small height
  -- https://github.com/glepnir/lspsaga.nvim/issues/594
  ['[e'] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "[C] go previous diagnostic" },
  [']e'] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "[C] go next diagnostic" },
  ["[E"] = { function()
      require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, "[C] previous error" },
  ["]E"] = { function()
      require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, "[C] next error" },
  }, { noremap = true, silent = true })

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  wk.register({
    g = {
      -- list opened by trouble
      -- TODO: how to use?
      [";"] = { "<cmd>TroubleToggle quickfix<cr>", "[C] go quickfix list" },
      ["'"] = { "<cmd>TroubleToggle loclist<cr>", "[C] go location list" },

      -- x = { function() vim.diagnostic.open_float { height = 10, width = 60 } end, "[C] peek diagnostic in current line" },
      -- FIX: Windows from Lspsaga is too short and always wrapped.
      -- See: https://github.com/glepnir/lspsaga.nvim/issues/594
      x = {"<cmd>Lspsaga show_line_diagnostics<CR>", "[C] show current diagnostic"},
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

      -- d = {function() vim.lsp.buf.definition() end, "[C] peek definition"},
      -- D = {function() vim.lsp.buf.declaration() end, "[C] declaration"},
      d = { "<cmd>Lspsaga peek_definition<cr>", "[C] peek definition" },
      D = { "<cmd>normal m'<cr><cmd>Trouble lsp_definitions<cr>", "[C] go definition " },

      h = { function() vim.lsp.buf.hover() end, "[C] hover" },
      H = { "<cmd>Lspsaga lsp_finder<cr>", "[C] hover (more)" },
      o = { function()
        vim.cmd("LSoutlineToggle")
      end, "[C] symbol outline" },
      j = { "<cmd>Lspsaga hover_doc<CR>", "[C] peek doc" },
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
        local mode = vim.api.nvim_get_mode()["mode"]
        if mode == "n" then
          vim.lsp.buf.format { async = true }
        else
          -- TODO: range formating.
          -- vim.lsp.buf.range_formatting is deprecated
          vim.notify("Unsupport range formatting")
        end
      end, "format file (by lsp)", mode = { "n", "v" } },
    },
  }, { noremap = true, silent = true, buffer = bufnr })

  vim.keymap.set({"i", "v"}, "<C-s>", function() vim.lsp.buf.signature_help() end)  -- Show signature at insertion (which-key can't set keymap for insert mode)
end

return M
