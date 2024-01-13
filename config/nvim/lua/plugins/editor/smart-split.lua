local fn = function(method, reset_mod)
  return function()
    -- Disable windows move in floating windows
    -- https://www.reddit.com/r/neovim/comments/17tu64y/comment/k91vg89
    local win = vim.api.nvim_get_current_win()
    local win_is_floating = vim.api.nvim_win_get_config(win).relative ~= ""
    if win_is_floating then
      return
    end
    if reset_mod then
      local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
      vim.api.nvim_feedkeys(esc, "x", false)
    end
    require("smart-splits")[method]()
  end
end

local ignored = "which_key_ignore"

return {
  -- Individual buffers for each tab
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  build = "./kitty/install-kittens.bash",
  keys = {
    { mode = { "n", "x" }, "<C-S-h>", fn("resize_left"), desc = "Window Resize Left (HJKL)" },
    { mode = { "n", "x" }, "<C-S-j>", fn("resize_down"), desc = ignored },
    { mode = { "n", "x" }, "<C-S-k>", fn("resize_up"), desc = ignored },
    { mode = { "n", "x" }, "<C-S-l>", fn("resize_right"), desc = ignored },

    { mode = { "n" }, "<C-h>", fn("move_cursor_left"), desc = "Navigate to Window Left (HJKL)" },
    { mode = { "n" }, "<C-j>", fn("move_cursor_down"), desc = ignored },
    { mode = { "n" }, "<C-k>", fn("move_cursor_up"), desc = ignored },
    { mode = { "n" }, "<C-l>", fn("move_cursor_right"), desc = ignored },
    { mode = { "x" }, "<C-h>", fn("move_cursor_left", true) },
    { mode = { "x" }, "<C-j>", fn("move_cursor_down", true) },
    { mode = { "x" }, "<C-k>", fn("move_cursor_up", true) },
    { mode = { "x" }, "<C-l>", fn("move_cursor_right", true) },

    { mode = { "n", "x" }, "<C-M-h>", "<CMD>wincmd H<CR>", desc = "Move Window to Left (HJKL)" },
    { mode = { "n", "x" }, "<C-M-j>", "<CMD>wincmd J<CR>", desc = ignored },
    { mode = { "n", "x" }, "<C-M-k>", "<CMD>wincmd K<CR>", desc = ignored },
    { mode = { "n", "x" }, "<C-M-l>", "<CMD>wincmd L<CR>", desc = ignored },
  },
  opts = {
    default_amount = 5,
  },
}
