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

local function escape_pairs()
  -- vim.notify("escape pair")
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  -- Jump forward whitespaces
  while line:sub(col + 1, col + 1) == " " do -- if out of range, :sub returns ""
    col = col + 1
  end
  local j = 0
  -- If reach line end, jump to next line
  -- TODO:
  -- 1. jump space
  -- 2. then find next single { ( < > ) } ..., jump
  -- 2.1. if next is non bracket, then jump a word
  -- 3. stop
  -- -- TODO: jump single {
  if col == #line then
    local line_count = vim.api.nvim_buf_line_count(0)
    if row == line_count then
      -- vim.notify("end")
      return -- no next line to jump
    else
      line, col = "", 0
      while row < line_count and line == "" do
        row = row + 1
        line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] -- get next line
      end
      -- vim.notify("jump to next line")
    end
  else
    line = line:sub(col + 1, -1) -- Later part line
    local patterns = {
      -- Case #1 whitespace + closing bracket + ,
      "[%s%)%]%}%>%\"'`]*,*",
      -- Case #2 whitespace + opening bracket
      "[%s%(%[%{%<]*",
      -- Case #3 like w, no whitespaces and brackets...
      "[^%s%(%)%[%]%{%}%<%>\"]*,*",
    }
    for i, pattern in ipairs(patterns) do
      _, j = line:find(pattern)
      if j > 0 then
        -- vim.notify("Cass " .. i)
        break
      end
    end
  end

  while line:sub(j + 1, j + 1) == " " do
    j = j + 1
  end
  -- vim.notify("row: " .. row .. ", col: " .. col)
  -- vim.notify(line)
  vim.api.nvim_win_set_cursor(0, { row, j + col })
end

local function escape_pairs2()
  -- vim.notify("escape pair")
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local sub_line = line:sub(col + 1, -1) -- Later part line
  -- Jump space
  local pattern = "[%s\n]*"
  repeat
    local _, j = sub_line:find(pattern)
    col = col + j

  until true
  -- TODO


  -- Jump forward whitespaces
  while sub_line:sub(col + 1, col + 1) == " " do -- if out of range, :sub returns ""
    col = col + 1
  end
  local j = 0
  -- If reach line end, jump to next line
  if col == #sub_line then
    local line_count = vim.api.nvim_buf_line_count(0)
    if row == line_count then
      -- vim.notify("end")
      return -- no next line to jump
    else
      sub_line, col = "", 0
      while row < line_count and sub_line == "" do
        row = row + 1
        sub_line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] -- get next line
      end
      -- vim.notify("jump to next line")
    end
  else
    sub_line = sub_line:sub(col + 1, -1) -- Later part line
    local patterns = {
      -- Case #1 whitespace + closing bracket + ,
      "[%s%)%]%}%>%\"'`]*,*",
      -- Case #2 whitespace + opening bracket
      "[%s%(%[%{%<]*",
      -- Case #3 like w, no whitespaces and brackets...
      "[^%s%(%)%[%]%{%}%<%>\"]*,*",
    }
    for i, pattern in ipairs(patterns) do
      _, j = sub_line:find(pattern)
      if j > 0 then
        vim.notify("Cass " .. i)
        break
      end
    end
  end

  while sub_line:sub(j + 1, j + 1) == " " do
    j = j + 1
  end
  -- vim.notify("row: " .. row .. ", col: " .. col)
  -- vim.notify(line)
  vim.api.nvim_win_set_cursor(0, { row, j + col })
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

-- vim.keymap.set('i', '<tab>', function() tabout() end, { noremap = true, silent = true })
vim.keymap.set('i', '<tab>', escape_pairs, { noremap = true, silent = true })
-- vim.keymap.set('i', '<tab>', "<S-Right>", { noremap = true, silent = true })
vim.keymap.set('i', '<S-tab>', "<S-Left>", { noremap = true, silent = true })
