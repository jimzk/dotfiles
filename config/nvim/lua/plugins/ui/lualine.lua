-- statusline
local M = {
  "nvim-lualine/lualine.nvim",
  event = "BufReadPost",
}

M.opts = function()
  local icons = require("config").icons

  local function fg(name)
    return function()
      ---@type {foreground?:number}?
      local hl = vim.api.nvim_get_hl_by_name(name, true)
      return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
    end
  end

  return {
    options = {
      theme = "auto",
      globalstatus = true,
      always_divide_middle = true,
      disabled_filetypes = {
        statusline = { "dashboard", "lazy", "alpha" },
        winbar = {},
      },
    },
    tabline = {
      lualine_b = {
        {
          "tabs",
          max_length = vim.o.columns,
          mode = 2,
          fmt = function(name, context)
            -- Show + if buffer is modified in tab
            local buflist = vim.fn.tabpagebuflist(context.tabnr)
            local winnr = vim.fn.tabpagewinnr(context.tabnr)
            local bufnr = buflist[winnr]
            local is_mod = vim.fn.getbufvar(bufnr, "&mod")
            if is_mod then name = name .. (is_mod == 1 and " [+] " or "") end
            local is_readonly = vim.fn.getbufvar(bufnr, "&readonly")
            if is_readonly then name = name .. (is_readonly == 1 and " [-]" or "") end
            return name
          end,
        },
      },
      lualine_x = {
        { -- show session name
          function() return require("possession.session").session_name end,
          icon = { "", align = "left" },
          cond = function() return require("possession.session").session_name ~= nil end,
          padding = { left = 0, right = 1 },
          separator = "|",
        },
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
          separator = " ",
          padding = { left = 1, right = 0 },
          color = { bg = "none" } -- transparent background
        },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
          color = { bg = "none" } -- transparent background
        },
      },
      lualine_x = {
        -- {
        --   function()
        --     return require("noice").api.status.command.get()
        --   end,
        --   cond = function()
        --     return package.loaded["noice"] and require("noice").api.status.command.has()
        --   end,
        --   color = fg("Statement"),
        --   separator = "",
        --   padding = { left = 0, right = 1 },
        -- },
        -- {
        --   function()
        --     return require("noice").api.status.mode.get()
        --   end,
        --   cond = function()
        --     return package.loaded["noice"] and require("noice").api.status.mode.has()
        --   end,
        --   color = fg("Constant"),
        --   separator = "",
        -- },

        {  -- Show visual line count (https://www.reddit.com/r/neovim/comments/1130kh5/comment/j8navg6)
          function()
            local is_visual_mode = vim.fn.mode():find("[Vv]")
            if not is_visual_mode then return "" end
            local starts = vim.fn.line("v")
            local ends = vim.fn.line(".")
            local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
            return tostring(lines) .. "L"
          end,
          separator = "",
          icon = {"", align = "left"},
          padding = { left = 0, right = 0 },
        },
        { -- List active lsp
          function()
            local clients = {}
            for _, client in ipairs(vim.lsp.get_active_clients()) do
              if client.name ~= "null-ls" and client.name ~= "copilot" then
                clients[client.name] = true
              end
            end
            clients = vim.tbl_keys(clients)
            return table.concat(clients, " ")
          end,
          icon = { "", align = "left" },
          padding = { left = 1, right = 1 },
        },
      },
      lualine_y = {
        -- :h 'statusline' to check vim statusline symbols
        -- another example: "Ln %l/%L, Col %c"
        {
          function() return [[%l:%c (%LL)]] end,
          separator = "",
        },
        {
          function() return vim.o.shiftwidth end,
          icon = { "", align = "left" },
          separator = "",
          padding = { left = 0, right = 1 },
        },
        {
          "filetype",
          icon_only = false,
          separator = "",
          padding = { left = 0, right = 1 },
        },
      },
      lualine_z = {
        function() return " " .. os.date("%R") end,
      },
    },
    extensions = { "nvim-tree", "toggleterm", "nvim-dap-ui", "fzf", "neo-tree" },
  }
end

M.config = function(_, opts)
  require("lualine").setup(opts)
  -- consistent highlight with editor background
  vim.cmd [[hi lualine_c_normal guibg=none]]
  vim.defer_fn(function()
    -- This one should be defer executed
    vim.cmd [[hi lualine_transitional_lualine_b_normal_to_lualine_c_normal guibg=none]]
    -- I guess lualine lazyly loads highlight.
    -- For example, it set `lualine_transitional_lualine_b_visual_to_lualine_c_normal` only when I use visual mode.
    -- So setting it here will be overrided then.
  end, 1000)
end

return M
