local M = {
  "folke/edgy.nvim",
  event = "VeryLazy",
  enabled = true,
}

M.keys = function(_, opts)
  return {
    {
      "<leader>y",
      function()
        require("edgy").toggle()
      end,
      desc = "Edgy Toggle",
    },
    {
      "<leader>Y",
      function()
        require("edgy").select()
      end,
      desc = "Edgy Select Window",
    },
  }
end

M.opts = function()
  local opts = {
    icons = {
      closed = "",
      open = "",
    },
    animate = {
      enabled = false,
    },
    options = {
      left = {
        size = 35,
        -- wo = { winbar = true },
      },
      right = { size = 0.4 },
      bottom = {
        size = 20,
        -- wo = { winbar = false },
      },
    },
    wo = {
      wrap = false,
      winbar = true,
    },
    bottom = {
      {
        ft = "vim",
        filter = function(buf)
          return vim.bo[buf].buftype == "nofile"
        end,
        title = "c_CTRL-F",
      },
      -- {
      --   ft = "lazyterm",
      --   title = "Terminal",
      -- },
      { title = "QuickFix", ft = "qf" },
      -- {
      --   ft = "help",
      --   -- don't open help files in edgy that we're editing
      --   filter = function(buf)
      --     return vim.bo[buf].buftype == "help"
      --   end,
      --   wo = {
      --     signcolumn = "yes:1",
      --     number = true,
      --   },
      -- },
      { title = "Spectre", ft = "spectre_panel", size = { height = 0.3 } },
      { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
    },
    left = {
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        pinned = true,
        open = "Neotree position=top filesystem",
        size = { height = 0.6 },
        wo = { winbar = false },
      },
      {
        title = "Neo-Tree Buffers",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "buffers"
        end,
        open = "Neotree position=right buffers",
      },
      {
        title = "Neo-Tree Git",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "git_status"
        end,
        open = "Neotree position=bottom git_status",
        size = { height = 0.3 },
      },
      {
        title = "Neo-Tree Other",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source ~= nil
        end,
      },
      {
        title = "Aerial",
        ft = "aerial",
        pinned = true,
        open = "AerialOpen",
      },
      -- { title = "Neotest Summary", ft = "neotest-summary" },
    },
    keys = {
      -- increase width
      ["<c-Right>"] = function(win)
        win:resize("width", 2)
      end,
      -- decrease width
      ["<c-Left>"] = function(win)
        win:resize("width", -2)
      end,
      -- increase height
      ["<c-Up>"] = function(win)
        win:resize("height", 2)
      end,
      -- decrease height
      ["<c-Down>"] = function(win)
        win:resize("height", -2)
      end,
    },
  }

  for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
    opts[pos] = opts[pos] or {}
    table.insert(opts[pos], {
      ft = "trouble",
      filter = function(_buf, win)
        return vim.w[win].trouble
          and vim.w[win].trouble.position == pos
          and vim.w[win].trouble.type == "split"
          and vim.w[win].trouble.relative == "editor"
          and not vim.w[win].trouble_preview
      end,
    })
  end
  return opts
end

return M
