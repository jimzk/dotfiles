local cmd_abbrev = {
  ["vm"] = "verb map",
  ["vmv"] = "verb vmap",
  ["vmn"] = "verb nmap",
  ["vmo"] = "verb omap",
  ["vmi"] = "verb imap",
  ["hil"] = "hi! link",
  ["tne"] = "tabnew",
}
for lhs, rhs in pairs(cmd_abbrev) do
  vim.cmd("cnorea " .. lhs .. " " .. rhs)
end
