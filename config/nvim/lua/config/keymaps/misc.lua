map("v", ",<space>", function()
  vim.cmd [[normal! "vy]]
  local lua_code = vim.fn.getreg("+")
      :gsub("%-%-([^\n]+)", "")-- remove comment. [^\n] means any char except \n
      :gsub("[\n\r]", " ")
      :gsub("[%s]+", " ")
  vim.cmd("lua " .. lua_code)
end, "execute selected lua code")

map("n", ",<space>", function()
  local lua_code = vim.fn.getreg("+")
      :gsub("%-%-([^\n]+)", "")-- remove comment. [^\n] means any char except \n
      :gsub("[\n\r]", " ")
      :gsub("[%s]+", " ")
  vim.cmd("lua " .. lua_code)
end, "execute lua code from clipboard")

local keys = {"D", "d", "C", "c"}
for _, key in ipairs(keys) do
  map({"n", "v"}, ","..key, '"_' .. key, "black hole ".. key)
end
