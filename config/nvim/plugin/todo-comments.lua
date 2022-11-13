require("todo-comments").setup {}

require('which-key').register({
    ["<leader>ct"] = {"<cmd>TodoTelescope<cr>", "search TODOs"},
    -- ["]t"] = {""},,
    ["[t"] = {function() require("todo-comments").jump_prev() end, "previous TODO"},
    ["]t"] = {function() require("todo-comments").jump_next() end, "next TODO"}
})
