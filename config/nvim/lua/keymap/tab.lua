-- Replace tabouts.nvim
-- Inspiration: https://www.reddit.com/r/neovim/comments/rztkaq/how_do_you_jump_out_pairs_or_quotes_in_insert/
local function tabout_pair(closers)
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local after = line:sub(col + 1, -1)
  local closer_col = #after + 1
  local closer_i = nil
  for i, closer in ipairs(closers) do
    local pattern = "^%s*%" .. closer
    local _, end_index = after:find(pattern)
    if end_index and (end_index < closer_col) then
      closer_col = end_index
      closer_i = i
      break
    end
  end
  if closer_i then
    vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
    return true
  end
  return false
end

local function tabout_pair_cross_line(closers)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line_count = vim.api.nvim_buf_line_count(0)
  if row == line_count then
    return
  end
  local line = vim.api.nvim_get_current_line():sub(col + 1, -1)
  if line ~= '' then
    return
  end
  while row + 1 <= line_count and string.match(line, "^%s*$") do
    line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1] -- get line #row+1
    row = row + 1
  end
  local after = line:sub(1, -1)
  local closer_col = #after + 1
  local closer_i = nil
  for i, closer in ipairs(closers) do
    local pattern = "^%s*%" .. closer
    local _, end_index = after:find(pattern)
    if end_index and (end_index < closer_col) then
      closer_col = end_index
      closer_i = i
      break
    end
  end
  if closer_i then
    vim.api.nvim_win_set_cursor(0, { row, closer_col })
    return true
  end
  return false
end

local function tabout()
  local closers = { ")", "]", "}", ">", "'", '"', "`", "," }
  -- (foo |  )  -> (foo   )|
  if tabout_pair(closers) then
    return
  end
  -- {              {
  --   foo |  ->      foo
  -- }              }|
  if tabout_pair_cross_line(closers) then
    return
  end
  -- fallback
  vim.api.nvim_input(string.rep(' ', vim.bo.shiftwidth))
end

vim.keymap.set('i', '<tab>', function() tabout() end, { noremap = true, silent = true })
