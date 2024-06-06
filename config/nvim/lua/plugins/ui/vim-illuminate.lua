return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  dependencies = {
    "neovim/nvim-lspconfig",
    opts = { document_highlight = { enabled = false } },
  },

  opts = {
    modes_allowlist = { "n" },
    min_count_to_highlight = 2,
    providers_regex_syntax_denylist = { "vim" },
    should_enable = function(bufnr)
      return vim.bo[bufnr].buflisted
    end,
  },
  config = function(_, opts)
    local il = require("illuminate")
    il.configure(opts)

    -- Remove predefined keymaps
    vim.keymap.del("n", "<M-p>")
    vim.keymap.del("n", "<M-n>")

    local map_ref = function(key_next, key_prev, buffer)
      local find_matching_pair = function()
        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        local char = line:sub(col + 1, col + 1)
        local mode = vim.fn.mode("no")
        if vim.tbl_contains({ "{", "(", "[", "<", "}", ")", "]", "}" }, char) then
          -- Execute <Plug>(matchup-%)
          if mode == "n" or mode == "v" then
            vim.fn["matchup#motion#find_matching_pair"](0, 1)
          elseif mode == "no" then
            vim.fn["matchup#motion#op"]("%")
          end
          return true
        else
          return false
        end
      end

      -- stylua: ignore start
      local next_ref_repeat, prev_ref_repeat = Util.make_repeatable_move_pair(
        function()
          if not find_matching_pair() then il.goto_next_reference(true) end
        end,
        function()
          if not find_matching_pair() then il.goto_prev_reference(true) end
        end)
      -- stylua: ignore end
      local mode = { "n", "o", "x" }
      vim.keymap.set(mode, key_next, next_ref_repeat, { desc = "Next Reference / Bracket", buffer = buffer })
      vim.keymap.set(mode, key_prev, prev_ref_repeat, { desc = "Prev Reference / Bracket", buffer = buffer })
    end
    map_ref("<C-n>", "<C-p>")

    vim.g.illuminate_enabled = true

    local map = Util.map
    map("n", "<leader>oi", function()
      Util.toggle(vim.g.illuminate_enabled, function()
        il.toggle()
        vim.g.illuminate_enabled = not vim.g.illuminate_enabled
      end, "Illuminate")
    end, "Toggle Illuminate")

    -- vim.cmd([[
    --   hi! IlluminatedWordText guibg=#626787
    --   hi! IlluminatedWordRead guibg=#626787
    --   hi! IlluminatedWordWrite guibg=#626787
    -- ]])
    vim.cmd([[
      hi! IlluminatedWordText gui=underline
      hi! IlluminatedWordRead gui=underline
      hi! IlluminatedWordWrite gui=underline
    ]])
  end,
}
