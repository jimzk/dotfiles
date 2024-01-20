return {
  -- better text-objects
  "echasnovski/mini.ai",
  -- if lazy load then which-key won't show keys. Don't know why.
  lazy = false,
  opts = function()
    local gen_spec = require("mini.ai").gen_spec
    return {
      mappings = {
        around = "a",
        inside = "i",
        around_next = "",
        inside_next = "",
        around_last = "",
        inside_last = "",
        -- Keep it consistent with normal ] and [ move
        goto_left = "",
        goto_right = "",
      },
      n_lines = 50,
      search_method = "cover",
      custom_textobjects = {
        -- ib/ab is overwritten by matchup
        b = { { "%b()", "%b{}" }, "^.().*().$" },
        B = { { "%b{}" }, "^.().*().$" },
        k = { { "%b<>" }, "^.().*().$" },
        r = { { "%b[]" }, "^.().*().$" },
        -- O = { { "%b[]" }, "^.().*().$" },
        ["?"] = false, -- Disable prompt ask motion
        A = gen_spec.function_call({ name_pattern = "[%w_:%.]" }),
      },
    }
  end,
  config = function(_, opts)
    local ai = require("mini.ai")
    ai.setup(opts)
    local keymaps = {
      B = "{}",
      k = "<>",
      r = "[]",
      A = "all function prarameters",
    }
    for key, desc in pairs(keymaps) do
      map({ "x", "o" }, "i" .. key, nil, desc)
      map({ "x", "o" }, "a" .. key, nil, desc)
    end
    -- map({ "x", "o" }, "i<Space>", "iW", "between spaces")
    -- map({ "x", "o" }, "a<Space>", "aW", "between spaces")
    -- ]a and [a move to start at parameter. Defaults stay at end.
    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    local next_para_repeat, prev_para_repeat = ts_repeat_move.make_repeatable_move_pair(
      function() ai.move_cursor("right", "i", "a", { search_method = "next" }) end,
      function() ai.move_cursor("left", "i", "a", { search_method = "prev" }) end)
    map({ "n", "x", "o" }, "]a", next_para_repeat, "next parameter (mini.ai)")
    map({ "n", "x", "o" }, "[a", prev_para_repeat, "prev parameter (mini.ai)")
  end,
}
