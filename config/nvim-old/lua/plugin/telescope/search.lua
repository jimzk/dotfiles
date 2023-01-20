local telescope = require('telescope.builtin')
local telescope_state = require('telescope.state')

local last_search = nil

-- https://github.com/nvim-telescope/telescope.nvim/issues/2024
local function search_with_cache()
  if last_search == nil then
    telescope.live_grep({
      grep_open_files = true,
      -- attach_mappings = function(v1, map)
      --   map("i", "asdf", function(_prompt_bufnr)
      --     print "You typed asdf"
      --   end)
      --   return true
      -- end,
    })
    local cached_pickers = telescope_state.get_global_key "cached_pickers" or {}
    last_search = cached_pickers[1]
  else
    telescope.resume({ picker = last_search })
  end
end

-- vim.keymap.set('n', '<leader>fm', search_with_cache)
