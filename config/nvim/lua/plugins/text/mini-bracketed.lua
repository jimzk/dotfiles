return {
  -- add more [ and ] navigations
  "echasnovski/mini.bracketed",
  event = "VeryLazy",
  opts = {
    buffer     = { suffix = "", options = {} },
    comment    = { suffix = "", options = {} },
    conflict   = { suffix = "", options = {} },
    diagnostic = { suffix = "", options = {} },
    file       = { suffix = "", options = {} },
    indent     = { suffix = "", options = {} },
    jump       = { suffix = "", options = {} },
    location   = { suffix = "", options = {} },
    oldfile    = { suffix = "", options = {} },
    quickfix   = { suffix = "", options = {} },
    treesitter = { suffix = "", options = {} },
    undo       = { suffix = "", options = {} },
    window     = { suffix = "", options = {} },
    yank       = { suffix = "", options = {} },
  },
  config = function(_, opts)
    require("mini.bracketed").setup(opts)
    local move = function(target, direction, opts)
      return function()
        vim.cmd [[normal! m`]]
        MiniBracketed[target](direction, opts)
      end
    end
    -- Quickfix
    map("n", "]q", move("quickfix", "forward"), "next quickfix item")
    map("n", "[q", move("quickfix", "backward"), "prev quickfix item")
    map("n", "]Q", move("quickfix", "last"), "last quickfix item")
    map("n", "[Q", move("quickfix", "first"), "first quickfix item")
    -- Jump in current buffer
    -- NOTE: No Visual mode mappings due to implementation problems ()
    map("n", "[w", move("jump", "backward"), "prev jump in current buffer")
    map("o", "[w", move("jump", "backward", { wrap = true }), "prev jump in current buffer")
    map("n", "]w", move("jump", "forward"), "next jump in current buffer")
    map("o", "]w", move("jump", "forward", { wrap = true }), "next jump in current buffer")
    -- Comment (exclusive comment in operation mode)
    map({ "n", "x" }, "[m", move("comment", "backward"), "prev comment")
    map("o", "[m", move("comment", "backward", { wrap = false }), "prev comment")
    map({ "n", "x" }, "]m", move("comment", "forward"), "next comment")
    map("o", "]m", move("comment", "forward", { wrap = false }), "prev comment")
    -- Conflict
    map({ "n", "x" }, "[x", move("conflict", "backward"), "prev conflict")
    map("o", "[x", move("conflict", "backward", { wrap = true }), "prev conflict")
    map({ "n", "x" }, "]x", move("conflict", "forward"), "next conflict")
    map("o", "]x", move("conflict", "forward", { wrap = true }), "next conflict")
    -- Indent in current context.
    -- Cursor location won't affect indent scopr. That is the difference with mini-indentation.
    -- map({ "n", "x", "o" }, "]I", move("indent", "forward"), "next indent end")
    -- map({ "n", "x", "o" }, "[I", move("indent", "backward"), "next indent start")
  end
}
