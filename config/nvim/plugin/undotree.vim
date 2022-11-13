"  https://github.com/mbbill/undotree
let g:undotree_SplitWidth = 45  " windows width
let g:undotree_DiffpanelHeight = 20  " diff window height
let g:undotree_SetFocusWhenToggle = 1  " focus undotree window after opened

lua << EOF
require('which-key').register({
    ["<leader>nu"] = {"<cmd>UndotreeToggle<cr>", "show undo history"}
})
EOF
