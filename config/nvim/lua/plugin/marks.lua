-- https://github.com/chentoast/marks.nvim#setup
require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  mappings = {
    toggle = false,
    -- FIX: need  :q to quite preview window
    -- https://github.com/chentoast/marks.nvim/issues/86
    preview = "m;",
    delete_line = "dm<space>",
    delete_buf = "dm-",
    annotate = false,
    -- bookmark will disppear after quiting vim
    set_bookmark1 = false,
    set_bookmark2 = false,
    set_bookmark3 = false,
    set_bookmark4 = false,
    set_bookmark5 = false,
    set_bookmark6 = false,
    set_bookmark7 = false,
    set_bookmark8 = false,
    set_bookmark9 = false,
    set_bookmark0 = false,
    delete_bookmark1 = false,
    delete_bookmark2 = false,
    delete_bookmark3 = false,
    delete_bookmark4 = false,
    delete_bookmark5 = false,
    delete_bookmark6 = false,
    delete_bookmark7 = false,
    delete_bookmark8 = false,
    delete_bookmark9 = false,
    delete_bookmark0 = false,
  }
}

-- color definied by marks.nvm
vim.cmd("autocmd ColorScheme * highlight link MarkSignNumHL LineNr")
require("marks").toggle_signs()  -- hide mark by default
