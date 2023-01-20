require("editor.basic")
require("editor.event")
require("editor.search")
require("editor.yank")
require("editor.appearance")
require("editor.qf")

vim.cmd [[
cnoreab vm verb map
cnoreab vmv verb vmap
cnoreab vmn verb nmap
cnoreab vmo verb omap
cnoreab hil hi! link
]]
