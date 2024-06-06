local M = {
  "romgrk/barbar.nvim",
  event = "BufReadPost",
  enabled = true,
  dependencies = {
    {
      "akinsho/bufferline.nvim",
      enabled = false,
    },
  },
}

M.init = function()
  vim.g.barbar_auto_setup = false
end

M.opts = {
  animation = false,
  exclude_ft = {},
  exclude_name = { "package.json", "lazy-lock.json" },
  hide = { extensions = true },
  highlight_alternate = false,
  highlight_inactive_file_icons = false,
  highlight_visible = true,
  icons = {
    buffer_index = true,
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true },
      [vim.diagnostic.severity.WARN] = { enabled = true },
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = false },
    },
    pinned = { button = "", filename = true },
    alternate = { filetype = { enabled = true } },
    current = {},
    -- inactive = { button = false },
    visible = { modified = { buffer_number = false } },
  },
  minimum_padding = 0,
  maximum_padding = 0,
  maximum_length = 20,
  no_name_title = "[New File]",
  -- semantic_letters = false,
  letters = "dfjklghnmczioweuqp",
  -- sidebar_filetypes = {
  --   ["neo-tree"] = { event = "BufWipeout" },
  -- },
}

M.config = function(_, opts)
  require("bufferline").setup(opts)

  local bdelete = require("barbar.bbye").bdelete
  local buffer = require("barbar.buffer")
  local render = require("barbar.ui.render")
  local state = require("barbar.state")
  local index_of = require("barbar.utils.list").index_of
  local visible = buffer.activities.Visible
  local get_current_buf = vim.api.nvim_get_current_buf

  -- Ref: https://github.com/romgrk/barbar.nvim/blob/master/lua/barbar/api.lua#L111
  local function close_all_but_visible_or_pinned(direction)
    render.update()
    local idx = index_of(state.buffers, get_current_buf())
    if idx == nil then
      idx = 0
    end
    local start, stop, step = 1, #state.buffers, 1
    if direction == "left" then
      start, stop, step = idx - 1, 1, -1
    elseif direction == "right" then
      start, stop, step = idx + 1, #state.buffers, 1
    end
    for i = start, stop, step do
      local bufnr = state.buffers[i]
      if not (buffer.get_activity(bufnr) >= visible or state.is_pinned(bufnr)) then
        bdelete(false, bufnr)
      end
    end
    render.update()
  end

  Util.update_tabline = function()
    require("barbar.ui.render").update()
  end

  local map = Util.map
  -- override default mapping
  vim.defer_fn(function()
    -- Buffers
    map("n", "-", "<CMD>BufferPrevious<CR>", "Previous Buffer")
    map("n", "=", "<CMD>BufferNext<CR>", "Next Buffer")
    -- Move buffers
    map("n", "<M-->", "<CMD>BufferMovePrevious<CR>", "Move Buffer to Previous")
    map("n", "<M-=>", "<CMD>BufferMoveNext<CR>", "Move Buffer to Next")

    -- Remove buffers
    map("n", "<C-b>d", "<BS>", "Delete Buffer (<BS>)", { remap = true })
    map("n", "<S-BS>", close_all_but_visible_or_pinned, "Delete Other Buffers")
    map("n", "<C-b>o", "<S-BS>", "Delete Other Buffers (<S-BS>)", { remap = true })
    map("n", "<C-b>D", "<CMD>BufferPickDelete<CR>", "Delete Buffer by Pick")
    -- stylua: ignore start
    map("n", "<C-b>l", function() close_all_but_visible_or_pinned("right") end, "Delete Buffers Left")
    map("n", "<C-b>h", function() close_all_but_visible_or_pinned("left") end, "Delete Buffers Right")

    -- Order
    -- map("n", "<C-b>sn", "<CMD>BufferOrderByBufferNumber<CR>", "Order by Buffer Number")
    -- map("n", "<C-b>sd", "<CMD>BufferOrderByDirectory<CR>", "Order by Directory")
    -- map("n", "<C-b>sl", "<CMD>BufferOrderByLanguage<CR>", "Order by Language")
    -- map("n", "<C-b>sw", "<CMD>BufferOrderByWindowNumber<CR>", "Order Window Number")

    -- Utilities
    map("n", "<C-b>t", "<CMD>BufferRestore<CR>", "Restore Buffer")
    -- map("n", "`", "<CMD>BufferPick<CR>", "Pick Buffer")
    -- Pin buffer
    map("n", "<C-b>p", "<CMD>BufferPin<CR><CMD>Hbac toggle_pin<CR>", "Pin Buffer")

    -- Go to buffer
    for i = 0, 9 do
      local key = "<C-b>" .. i
      local cmd = i == 0 and "<CMD>BufferLast<CR>" or "<CMD>BufferGoto " .. i .. "<CR>"
      map("n", key, cmd)
    end

    require("which-key").register({
      ["<C-b>"] = {
        name = "tabline",
      },
    })

    vim.cmd([[
      hi BufferDefaultAlternate guifg=#494d65
      hi! link BufferCurrentMod BufferCurrent
      hi BufferCurrentModBtn guibg=#494d65 guifg=#a6d18a
      hi! link BufferVisibleMod BufferVisible
      hi BufferVisibleModBtn guifg=#a6d18a
      " hi BufferDefaultVisible guifg=#a6d18a
      hi BufferCurrentPinBtn guibg=#494d65 guifg=#ed8797
      hi BufferVisiblePinBtn guifg=#ed8797
      hi BufferInactivePinBtn guifg=#ed8797
    ]])
  end, 100)

  -- Auto resize
  -- https://github.com/romgrk/barbar.nvim/issues/355#issuecomment-1396431625
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWipeout", "WinResized" }, {
    pattern = "*",
    callback = function()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_get_option_value("ft", { buf = bufnr }) == "neo-tree" then
          local ok, offset = pcall(vim.api.nvim_win_get_width, win)
          if not ok then
            return
          end
          local title = "Neo-tree"
          -- local session_name = require("possession.session").get_session_name()
          -- if session_name then
          --   title = title .. ": " .. session_name
          -- end
          return require("bufferline.api").set_offset(offset, title)
        end
      end
      return require("bufferline.api").set_offset(0)
    end,
  })
end

return M
