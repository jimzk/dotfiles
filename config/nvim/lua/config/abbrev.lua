local c = {
  ["vm"] = "verb map",
  ["vmv"] = "verb vmap",
  ["vmn"] = "verb nmap",
  ["vmo"] = "verb omap",
  ["vmi"] = "verb imap",
  ["hil"] = "hi! link",
  ["tne"] = "tabnew"
}

for lhs, rhs in pairs(c) do
  vim.cmd("cnoreab " .. lhs .. " " .. rhs)
end
