-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/ui.lua#L247
return {
  "echasnovski/mini.indentscope",
  opts = {
    mappings = {
      object_scope = "ii",
      object_scope_with_border = "ai",
      goto_top = "[i",
      goto_bottom = "]i",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "alpha",
        "aerial",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "oil",
        "oil_preview",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "dropbar_menu",
        "rnvimr",
      },
      callback = function(opts)
        vim.b[opts.buf].miniindentscope_disable = true
        -- vim.b.miniindentscope_disable = true
      end,
    })
  end,
  config = function(_, opts)
    local indentscopt = require("mini.indentscope")
    indentscopt.setup(opts)

    local move = function(...)
      vim.cmd([[normal! m`]])
      indentscopt.move_cursor(...)
    end
    local map = require("util").map
    map({ "x", "o" }, "ii", nil, "Indent Scope")
    map({ "x", "o" }, "ai", nil, "Indent Scope")
    -- stylua: ignore start
    local next_indent_inner, prev_indent_inner = require("util").make_repeatable_move_pair(
      function() move("bottom", false) end,
      function() move("top", false) end)
    local next_indent_outer, prev_indent_outer = require("util").make_repeatable_move_pair(
      function() move("bottom", true) end,
      function() move("top", true) end)
    -- stylua: ignore end
    map({ "n", "x", "o" }, "]I", next_indent_inner, "Indent End")
    map({ "n", "x", "o" }, "[I", prev_indent_inner, "Indent Start")
    map({ "n", "x", "o" }, "]i", next_indent_outer, "Indent End (Outer)")
    map({ "n", "x", "o" }, "[i", prev_indent_outer, "Indent Start (Outer)")

    -- Darker highlight of IndentBlanklineChar
    vim.cmd([[hi! MiniIndentscopeSymbol guifg=#b5bddd]])
  end,
}
