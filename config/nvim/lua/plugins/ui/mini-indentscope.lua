-- active indent guide and indent text objects
return {
  "echasnovski/mini.indentscope",
  event = "BufReadPost",
  opts = {
    -- symbol = "▏",
    symbol = "│",
    options = { try_as_border = true },
    draw = {
      delay = 1,
      -- Disable animation. It is slow.
      animation = function(_, _)
        return 0
      end,
    },
    mappings = {
      object_scope = "",
      object_scope_with_border = "",
      goto_top = "",
      goto_bottom = "",
    },
  },
  config = function(_, opts)
    local indentscopt = require("mini.indentscope")
    indentscopt.setup(opts)
    local move = function(...)
      vim.cmd [[normal! m`]]
      indentscopt.move_cursor(...)
    end
    -- map({ "x", "o" }, "ii", nil, "indent (mini-indentscope)")
    -- map({ "x", "o" }, "ai", nil, "indent (mini-indentscope)")
    -- ]i and [i have different bahaivour in operation mode. Seems like a bug.
    map({ "n", "x", "o" }, "]i", function() move("bottom", true) end, "mini indent end")
    map({ "n", "x", "o" }, "[i", function() move("top", true) end, "mini indent start")
    -- map({ "n", "x" }, "[i", function() move("top", true) end, "indent start (mini-indentscope)")
    -- map("o", "[i", function() move("top", false) end, "indent line scope end")
    -- Darker highlight of IndentBlanklineChar
    vim.cmd [[hi! MiniIndentscopeSymbol guifg=#979cb3]]
    vim.api.nvim_create_autocmd("FileType", {
      pattern = Util.unlisted_filetypes,
      callback = function(opts)
        vim.b[opts.buf].miniindentscope_disable = true
      end,
    })
  end,
}
