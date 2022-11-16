vim.opt.list = true
vim.opt.listchars:append "space:⋅"
require("indent_blankline").setup {
    enabled = true,
    space_char_blankline = " ",
    show_trailing_blankline_indent = false,
    show_current_context = true,
    show_current_context_start = true,
    use_treesitter = true,
    use_treesitter_scope = true,
}
