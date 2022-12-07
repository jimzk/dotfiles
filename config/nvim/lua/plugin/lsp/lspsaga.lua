require("lspsaga").init_lsp_saga {
  max_preview_lines = 30,
  code_action_lightbulb = {
    sign = false, -- not show lightbulb sign in most left column
  },
  finder_action_keys = {
    open = { 'o', '<CR>' },
    vsplit = 'v',
    split = 's',
    tabe = 't',
    quit = { 'q', '<ESC>' },
  },
  definition_action_keys = {
    edit = 'o',
    vsplit = 'v',
    split = 's',
    tabe = 't',
    quit = 'q',
  },
  show_outline = {
    win_position = 'right',
    win_with = '',
    win_width = 45,
    auto_enter = true,
    auto_preview = true,
    virt_text = '┃',
    jump_key = 'o',
    auto_refresh = true,
  },
}
