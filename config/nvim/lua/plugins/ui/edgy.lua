local M = {
  -- ISSUE: messup posession.nvim session restore.
  "folke/edgy.nvim",
  event = "VeryLazy",
  enabled = false,
}

M.keys = function()
  return {
    {
      "<leader>e",
      function()
        require("edgy").toggle()
      end,
      desc = "Toggle Edgy",
    },
    -- {
    --   "<leader>E",
    --   function()
    --     require("edgy").select()
    --   end,
    --   desc = "Edgy Select Window",
    -- },
  }
end

M.opts = function()
  local opts = {
    animate = {
      enabled = false,
    },
    options = {
      left = { size = 40 },
      right = { size = 50 },
      bottom = { size = 25 },
    },
    wo = {
      wrap = true,
      winbar = true,
    },
    right = {
      -- {
      --   title = "Neo-Tree Git",
      --   ft = "neo-tree",
      --   filter = function(buf)
      --     return vim.b[buf].neo_tree_source == "git_status"
      --   end,
      --   -- pinned = true,
      --   open = "Neotree position=right git_status",
      --   size = { height = 0.4 },
      -- },
      "Trouble",
      {
        ft = "trouble",
        filter = function(buf, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
    },
    -- bottom = {
    --   -- ISSUE: qf is broken with nvim-bqf
    --   { ft = "qf", title = "QuickFix" },
    --   {
    --     ft = "help",
    --     size = { height = 20 },
    --     -- don't open help files in edgy that we're editing
    --     filter = function(buf)
    --       return vim.bo[buf].buftype == "help"
    --     end,
    --     wo = {
    --       number = true,
    --       relative = true,
    --       signcolumn = "yes",
    --     },
    --   },
    --   { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
    --   { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
    -- },
    left = {
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        pinned = true,
        open = "Neotree toggle",
        size = { height = 0.5 },
      },
      -- {
      --   title = "Outline",
      --   ft = "Outline",
      --   pinned = true,
      --   open = "Outline",
      -- },
      -- {
      --   title = "Aerial",
      --   ft = "aerial",
      --   pinned = true,
      --   open = "AerialOpen",
      -- },
    },
    keys = {
      -- increase width
      ["<c-s-l>"] = function(win)
        win:resize("width", 2)
      end,
      -- decrease width
      ["<c-s-h>"] = function(win)
        win:resize("width", -2)
      end,
      -- increase height
      ["<c-s-k>"] = function(win)
        win:resize("height", 2)
      end,
      -- decrease height
      ["<c-s-j>"] = function(win)
        win:resize("height", -2)
      end,
      ["J"] = function(win)
        win:next({ visible = true, focus = true })
      end,
      -- previous open window
      ["K"] = function(win)
        win:prev({ visible = true, focus = true })
      end,
    },
  }
  return opts
end

return M
