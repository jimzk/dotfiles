local c = {
  ["vm"] = "verb map",
  ["vmv"] = "verb vmap",
  ["vmn"] = "verb nmap",
  ["vmo"] = "verb omap",
  ["hil"] = "hi! link",
}

for lhs, rhs in pairs(c) do
  vim.cmd("cnoreab " .. lhs .. " " .. rhs)
end
