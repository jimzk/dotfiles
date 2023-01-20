-- better text-objects
return {
  "echasnovski/mini.ai",
  lazy = false, -- if lazy load then which-key won't show keys. Don't know why.
  -- dependencies = {
  --   {
  --     "nvim-treesitter/nvim-treesitter-textobjects",
  --     init = function()
  --       -- no need to load the plugin, since we only need its queries
  --       require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
  --     end,
  --   },
  -- },
  opts = function()
    return {
      mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "aN",
        inside_last = "iN",
        -- Keep it consistent with normal ] and [ move
        goto_left = "[",
        goto_right = "]",
      },
      n_lines = 200,
      search_method = "cover_or_next",
      custom_textobjects = {
        -- b -> ), B -> }, k -> >, r -> ]
        b = { { "%b()" }, "^.().*().$" },
        B = { { "%b{}" }, "^.().*().$" },
        k = { { "%b<>" }, "^.().*().$" },
        r = { { "%b[]" }, "^.().*().$" },
        ["?"] = false, -- Disable prompt ask motion

        -- o = ai.gen_spec.treesitter({
        --   a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        --   i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        -- }, {}),
        -- f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        -- c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
      },
    }
  end,
  config = function(_, opts)
    local ai = require("mini.ai")
    ai.setup(opts)
    local label = function(key, desc)
      map({ "x", "o" }, "i" .. key, nil, desc)
      map({ "x", "o" }, "a" .. key, nil, desc)
    end
    label("b", "alias (")
    label("B", "alias {")
    label("k", "alias <")
    label("r", "alias [")

    -- ]a and [a move to start at parameter. Defaults stay at end.
    map({ "n", "x", "o" }, "]a", function()
      ai.move_cursor("left", "i", "a", { search_method = "next" })
    end, "next parameter (mini.ai)")
    map({ "n", "x", "o" }, "[a", function()
      ai.move_cursor("left", "i", "a", { search_method = "prev" })
    end, "prev parameter (mini.ai)")
  end,
}
