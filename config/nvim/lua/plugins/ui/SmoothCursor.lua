local letters = {}
for i = string.byte("a"), string.byte("z") do
  table.insert(letters, string.char(i))
end
for i = string.byte("A"), string.byte("Z") do
  table.insert(letters, string.char(i))
end

return {
  -- Indicate cursor move
  "gen740/SmoothCursor.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {
    type = "matrix",
    matrix = { -- Loaded when 'type' is set to "matrix"
      -- head = false,
      head = {
        cursor = { "▷" },
      },
      body = {
        length = 16, -- Specifies the length of the cursor body
        cursor = letters,
        -- texthl = {
        --   -- "FloatBorder",
        --   "NotifyINFOBorder",
        -- },
      },
      unstop = false, -- Determines if the cursor should stop or not (false means it will stop)
    },
    enabled_filetypes = { "lua", "rust", "json", "toml" },
    -- disabled_filetypes = { "notify", "aerial-nav", "harpoon", "fzf" },
    disable_float_win = true,
  },
  config = function(_, opts)
    require("smoothcursor").setup(opts)
    -- Only highlight cursorline number but not cursorline
    -- vim.opt.cursorline = true
    -- vim.cmd("hi! CursorLine guibg=none")
    -- vim.cmd("hi! link CursorLineNr SmoothCursor")
  end,
}
