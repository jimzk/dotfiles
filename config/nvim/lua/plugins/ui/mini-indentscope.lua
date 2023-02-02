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
      -- Disable slow animation
      animation = function(_, _)
        return 0
      end,
    },
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = Util.unlisted_filetypes,
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
    local indentscopt = require("mini.indentscope")
    indentscopt.setup(opts)
    local move = indentscopt.move_cursor
    map({ "n", "x", "o" }, "]i", function() move("bottom", false) end, "indent scope start")
    map({ "n", "x", "o" }, "[i", function() move("top", false) end, "indent scope end")
    -- Darker highlight of IndentBlanklineChar
    vim.cmd [[hi! MiniIndentscopeSymbol guifg=#979cb3]]
  end,
}
