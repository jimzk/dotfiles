local M = {
  -- Automatically close unmodified buffers if numbers of buffers exceed the threshold
  "axkirillov/hbac.nvim",
  event = "BufRead",
  enabled = false, -- I don't need it as I use Harpoon for tabline
}

M.keys = {
  { "<leader>fb", "<cmd>Telescope hbac buffers<cr>", desc = "Find Buffers" },
}

M.opts = function()
  -- local actions = require("telescope.actions")
  local hbac_actions = require("hbac.telescope.actions")
  return {
    threshold = 12,
    telescope = {
      mappings = {
        i = {
          -- Seems a bug???
          i = false,
          n = false,
          -- Disable defaults
          ["<M-c>"] = false,
          ["<M-x>"] = false,
          ["<M-a>"] = false,
          ["<M-u>"] = false,
          ["<M-y>"] = false,

          ["<C-d>"] = hbac_actions.delete_buffer,
          ["<C-S-d>"] = hbac_actions.close_unpinned,
          ["<M-p>"] = hbac_actions.toggle_pin,
          -- ["<M-a>"] = actions.pin_all,
          -- ["<M-S-p>"] = actions.unpin_all,

          ["<C-g>"] = function()
            _G.smart_open()
          end,
        },
      },
    },
  }
end

return M
