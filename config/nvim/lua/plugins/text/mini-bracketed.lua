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
    local map_move = function(mode, key, next_fn, prev_fn, desc, wrap)
      local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
      if wrap then
        next_fn, prev_fn = ts_repeat_move.make_repeatable_move_pair(next_fn, prev_fn)
      else
        local _next_fn = next_fn
        next_fn = function()
          _next_fn()
          ts_repeat_move.clear_last_move()
        end
        local _prev_fn = prev_fn
        prev_fn = function()
          _prev_fn()
          ts_repeat_move.clear_last_move()
        end
      end
      if type(desc) == "string" then
        desc = {
          "next " .. desc,
          "prev " .. desc,
        }
      end
      map(mode, "]" .. key, next_fn, desc[1])
      map(mode, "[" .. key, prev_fn, desc[2])
    end
    -- Quickfix
    map("n", "]q", move("quickfix", "forward"), "next quickfix item")
    map("n", "[q", move("quickfix", "backward"), "prev quickfix item")
    map("n", "]Q", move("quickfix", "last"), "last quickfix item")
    map("n", "[Q", move("quickfix", "first"), "first quickfix item")
    -- Jump in current buffer
    -- NOTE: No Visual mode mappings due to implementation problems ()
    map_move("n", "w",
      move("jump", "forward"),
      move("jump", "backward"),
      "jump in current buffer", false
    )
    map_move("o", "w",
      move("jump", "forward", { wrap = true }),
      move("jump", "backward", { wrap = true }),
      "jump in current buffer", false
    )
    -- Comment (exclusive comment in operation mode)
    map_move({ "n", "x" }, "c",
      move("comment", "forward"),
      move("comment", "backward"),
      "comment", true
    )
    map_move("o", "c",
      move("comment", "forward", { wrap = false }),
      move("comment", "backward", { wrap = false }),
      "comment", false
    )

    -- Conflict
    map_move({ "n", "x" }, "x",
      move("conflict", "forward"),
      move("conflict", "backward"),
      "conflict", true
    )
    map_move("o", "x",
      move("conflict", "forward", { wrap = true }),
      move("conflict", "backward", { wrap = true }),
      "conflict", false
    )

    -- Indent in current context. Complement of mini-indentscope
    map_move({ "n", "x", "o" }, "I",
      move("indent", "last"),
      move("indent", "first"),
      { "outermost indent end", "outermost indent start" },
      false
    )
  end
}
