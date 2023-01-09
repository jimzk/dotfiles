local M = {}

-- No use it anymore but I want to keep it
M.setup_sneak = function()
  vim.g["sneak#use_ic_scs"] = 1 -- Case sensitive
  vim.g["sneak#absolute_dir"] = 1 -- Absolution search direction
  vim.g["sneak#s_next"] = 0 -- Disable default f/F move to next after search

  local opts = { noremap = true, silent = true, expr = true, replace_keycodes = false }
  set({ "n", "x" }, "f", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_f']], opts)
  set({ "n", "x" }, "F", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_F']], opts)
  set("o", "f", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_t']], opts)
  set("o", "F", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_T']], opts)
  -- set({ "n", "x" }, "t", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_t']], opts)
  -- set({ "n", "x" }, "T", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_T']], opts)
  -- set({ "n", "x" }, "s", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_s']], opts)
  -- set({ "n", "x" }, "S", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_S']], opts)


  -- Start hlslens for * n N
  -- https://github.com/kevinhwang91/nvim-hlslens#minimal-configuration
  -- If n/N call function then it throw long annoying error track.
  -- _G.nN = function(forward)
  --   local c = forward
  --       and (vim.v.searchforward == 0 and 'N' or 'n')
  --       or (vim.v.searchforward == 0 and 'n' or 'N')
  --   -- Keep jumplist unchanged
  --   local cmd = string.format([[execute('keepjumps normal! ' . v:count1 . '%s')]], c)
  --   vim.cmd(cmd)
  --   require("hlslens").start()
  -- end
  set("", "n",
    [[sneak#is_sneaking() ? '<Plug>Sneak_;' : v:searchforward ? 'n' : 'N''<cmd>lua require("hlslens").start()<cr>']],
    opts)
  set("", "N",
    [[sneak#is_sneaking() ? '<Plug>Sneak_;' : v:searchforward ? 'N' : 'n''<cmd>lua require("hlslens").start()<cr>']],
    opts)

  set({ "v", "n" }, "<Esc>", [[sneak#is_sneaking() ? '<Esc>:<C-u>call sneak#cancel()<cr>' : '<Esc>']], opts)
  -- set("n", "<Esc>", function()
  --   if vim.fn["sneak#is_sneaking"]() == 1 then
  --     vim.fn["sneak#cancel"]()
  --   elseif vim.v.hlsearch == 1 then
  --     vim.cmd [[noh]]
  --   end
  -- end)
end


M.setup_leap = function()
  -- local leap = require('leap')
  set({ "n", "x" }, "f", "<Plug>(leap-forward-to)")
  set({ "n", "x" }, "F", "<Plug>(leap-backward-to)")
  set({ "o" }, "f", "<Plug>(leap-forward-till)")
  set({ "o" }, "F", "<Plug>(leap-backward-till)")

  set("", "<Esc>", "<Esc>")
end

return M
