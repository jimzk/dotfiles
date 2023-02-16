-- better text-objects
return {
  "echasnovski/mini.ai",
  -- if lazy load then which-key won't show keys. Don't know why.
  lazy = false,
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
      n_lines = 50,
      search_method = "cover_or_next",
      custom_textobjects = {
        b = { { "%b()", "%b{}" }, "^.().*().$" },
        ["?"] = false, -- Disable prompt ask motion
      },
    }
  end,
  config = function(_, opts)
    local ai = require("mini.ai")
    ai.setup(opts)
    map({ "x", "o" }, "ib", nil, "{} or ()")
    map({ "x", "o" }, "ab", nil, "{} or ()")
    map({ "x", "o" }, "i<Space>", "iW")
    map({ "x", "o" }, "a<Space>", "aW")

    -- ]a and [a move to start at parameter. Defaults stay at end.
    map({ "n", "x", "o" }, "]a", function()
      ai.move_cursor("left", "i", "a", { search_method = "next" })
    end, "next parameter (mini.ai)")
    map({ "n", "x", "o" }, "[a", function()
      ai.move_cursor("left", "i", "a", { search_method = "prev" })
    end, "prev parameter (mini.ai)")
  end,
}
