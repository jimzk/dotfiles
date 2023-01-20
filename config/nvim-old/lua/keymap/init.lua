local folder = 'keymap'
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/' .. folder, [[v:val =~ '\.lua$']])) do
  if file ~= "init.lua" then
    require(folder .. "." .. file:gsub('%.lua$', ''))
  end
end
