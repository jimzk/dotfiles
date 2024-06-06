-- Better location/quickfix list
-- Override: https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/editor.lua#L440
local M = {
  "folke/trouble.nvim",
}

-- FIX:
-- - https://github.com/folke/trouble.nvim/blob/045feded8fd76231df1fda9265b706a2654ae841/lua/trouble/sources/lsp.lua#L310
--   includeDeclaration == false
M.keys = function()
  local _next_qf_or_trouble = function()
    if require("trouble").is_open() then
      require("trouble").next({ skip_groups = true, jump = true })
    else
      vim.cmd([[normal! m`]])
      MiniBracketed["quickfix"]("forward")
    end
  end
  local _prev_qf_or_trouble = function()
    if require("trouble").is_open() then
      require("trouble").prev({ skip_groups = true, jump = true })
    else
      vim.cmd([[normal! m`]])
      MiniBracketed["quickfix"]("backward")
    end
  end

  local next_qf_or_trouble, prev_qf_or_trouble =
    Util.make_repeatable_move_pair(_next_qf_or_trouble, _prev_qf_or_trouble)

  return {
    { "[q", prev_qf_or_trouble, desc = "Prev Trouble / Quickfix Item" },
    { "]q", next_qf_or_trouble, desc = "Next Trouble / Quickfix Item" },

    { "<leader>qq", "<cmd>Trouble qflist focus=true refresh=true<cr>", desc = "Quickfix List (Trouble)" },
    -- { "<leader>qq", "<cmd>copen<cr>", desc = "Quickfix List" },
    { "<leader>ql", "<cmd>Trouble loclist focus=true refresh=true<cr>", desc = "Location List (Trouble)" },
    -- { "<leader>ql", "<cmd>lopen<cr>", desc = "Location List" },

    {
      "<leader>db",
      function()
        -- https://github.com/folke/trouble.nvim/blob/main/docs/examples.md#diagnostics-cascade
        local opts = {
          mode = "diagnostics", -- inherit from diagnostics mode
          refresh = false,
          filter = function(items)
            local bufnr = vim.api.nvim_get_current_buf()
            local severity = vim.diagnostic.severity.HINT
            for _, item in ipairs(items) do
              severity = math.min(severity, item.severity)
            end
            return vim.tbl_filter(function(item)
              return (item.severity == severity) and (item.buf == bufnr)
            end, items)
          end,
        }
        require("trouble").open(opts)
      end,
      desc = "Buffer Diagnostics (Trouble)",
    },
    { "<leader>dB", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer Diagnostics (Telescope)" },

    { "<leader>dw", "<cmd>Trouble diagnostics refresh=true<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>dW", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics (Telescope)" },
    -- { "<leader>dW", vim.diagnostic.setqflist, desc = "Workspace Diagnostics (Quickfix)" },

    -- { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
    -- {
    --   "<leader>cS",
    --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    --   desc = "LSP references/definitions/... (Trouble)",
    -- },

    {
      "<leader>i[",
      "<cmd>Trouble lsp_incoming_calls toggle<cr>",
      desc = "Incoming Calls (Trouble)",
    },
    {
      "<leader>i]",
      "<cmd>Trouble lsp_outgoing_calls toggle<cr>",
      desc = "Outgoing Calls (Trouble)",
    },

    {
      "<C-M-LeftMouse>",
      function()
        -- https://github.com/folke/trouble.nvim/blob/main/docs/examples.md#diagnostics-cascade
        local opts = {
          mode = "lsp_references", -- inherit from diagnostics mode
          auto_refresh = false,
          -- auto_preview = true,
          -- :h nvim_open_win()
          -- option: https://github.com/folke/trouble.nvim/blob/83cfe1b3fd5ebb807119500534d2c8334375a305/lua/trouble/view/window.lua#L128
          win = {
            type = "float",
            relative = "cursor",
            border = "single",
            title = "References",
            title_pos = "center",
            position = { 0, 0.02 },
            size = { width = 0.3, height = 0.3 },
          },
          preview = {
            type = "float",
            relative = "cursor",
            border = "single",
            position = { 0.1, 0 },
            size = { width = 0.3, height = 0.3 },
            zindex = 100,
          },
          keys = {
            ["<C-LeftMouse>"] = { action = function() end },
            ["<C-RightMouse>"] = { action = function() end },
            ["<2-leftmouse>"] = {
              action = function(view)
                view:jump()
                view:close()
              end,
              desc = "Jump and Close",
            },
          },
        }
        require("trouble").open(opts)
      end,
      desc = "List References (Trouble)",
    },
  }
end

M.opts = {
  -- auto_refresh = false,
  auto_preview = false,
  -- follow = false,
  focus = true,
}

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  callback = function()
    vim.cmd([[Trouble qflist open]])
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd([[cclose]])
        -- vim.cmd([[Trouble qflist open]])
      end)
    end
  end,
})

-- M.config = function(_, opts)
--   local trouble = require("trouble")
--   trouble.setup(opts)
--   vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "Trouble" },
--     callback = function()
--       local map_opts = { noremap = true, buffer = true, silent = true }
--       local map = Util.map
--       -- stylua: ignore start
--       map("n", "K", function() trouble.prev({ jump = true }) end, "Prev Item", map_opts)
--       map("n", "J", function() trouble.next({ jump = true }) end, "Next Item", map_opts)
--       -- stylua: ignore end
--     end,
--   })
-- end

return M
