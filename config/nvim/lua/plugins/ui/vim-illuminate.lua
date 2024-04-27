-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L374
return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  -- Remove keymaps ]] and [[ from lazyVim
  -- https://github.com/LazyVim/LazyVim/blob/fe72424e77cb9c953084bbcaaa0eb7fe8056dc70/lua/lazyvim/plugins/editor.lua#L410-L413
  keys = function()
    return {}
  end,

  opts = {
    -- modes_allowlist = { "n" },
    min_count_to_highlight = 1,
    filetypes_denylist = {
      "dirbuf",
      "dirvish",
      "fugitive",
      "Trouble",
      "dropbar_menu",
      "markdown",
      "",
    },
  },
  config = function(_, opts)
    local il = require("illuminate")
    il.configure(opts)

    local map_ref = function(key_next, key_prev, buffer)
      -- stylua: ignore
      local next_ref_repeat, prev_ref_repeat = Util.make_repeatable_move_pair(
        function() il.goto_next_reference(false) end,
        function() il.goto_prev_reference(false) end
      )
      vim.keymap.set("n", key_next, next_ref_repeat, { desc = "Next Reference (<M-n>)", buffer = buffer })
      vim.keymap.set("n", key_prev, prev_ref_repeat, { desc = "Prev Reference (<M-p>)", buffer = buffer })
    end
    map_ref("]v", "[v")

    vim.g.illuminate_enabled = true

    local map = Util.map
    map("n", "<leader>oi", function()
      Util.toggle(vim.g.illuminate_enabled, function()
        il.toggle()
        vim.g.illuminate_enabled = not vim.g.illuminate_enabled
      end, "Illuminate")
    end, "Toggle Illuminate")

    -- vim.cmd([[hi! IlluminatedWordText gui=underline guibg=none]])
    -- vim.cmd([[hi! IlluminatedWordRead gui=underline guibg=none]])
    -- vim.cmd([[hi! IlluminatedWordWrite gui=underline guibg=none]])
  end,
}
