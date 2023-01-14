-- https://github.com/lewis6991/gitsigns.nvim#usage
require('gitsigns').setup {
  signs                        = {
    add          = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change       = { hl = 'GitSignsChange', text = '|', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '-', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '─', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  -- TODO: how to make git change more appearant?
  -- FIX: enable linhl will dismiss other highlight (like todo-comments)
  signcolumn                   = false, -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    interval = 500,
    follow_files = true
  },
  attach_to_untracked          = true,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 10,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil, -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm                         = {
    enable = false
  },

  -- keybindings
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map({ 'n', "v" }, ')', function()
      if vim.wo.diff then return ')' end
      gs.next_hunk()
      return '<Ignore>'
    end, { expr = true, desc = "next git change" })

    map({ 'n', "v" }, '(', function()
      if vim.wo.diff then return '(' end
      gs.prev_hunk()
      return '<Ignore>'
    end, { expr = true, desc = "prev git change" })
  end
}

vim.cmd [[au ColorScheme * highlight GitSignsAdd gui=reverse cterm=reverse]]
vim.cmd [[au ColorScheme * highlight GitSignsChange gui=reverse cterm=reverse]]
vim.cmd [[au ColorScheme * highlight GitSignsDelete gui=reverse cterm=reverse]]

set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Git change" })
