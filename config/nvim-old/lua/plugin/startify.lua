vim.g.startify_disable_at_vimenter = 1
vim.g.startify_session_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/")
vim.g.startify_update_oldfiles = 1
vim.g.startify_bookmarks = {}
vim.g.startify_session_persistence = 1
vim.g.startify_session_autoload = 0
vim.g.startify_session_delete_buffers = 0
vim.g.startify_enable_special = 0 -- not show <empty buffer> and <quit>
vim.g.startify_session_sort = 1 -- Sort session by modification  time
vim.g.startify_session_before_save = {
  "NvimTreeClose",
  "TroubleClose",
  "DiffviewClose",
}
vim.g.startify_change_to_dir = 0

vim.cmd [[
let g:startify_lists = [
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ ]
]]

vim.cmd [[
let g:startify_commands = [
  \ {'p': ['Find project', 'call feedkeys("\<space>pg")']},
  \ {'\': ['Sync plugins', 'call feedkeys("\<space>o\\")']},
  \ ]
]]

vim.g.ascii = {
  '    [e] new buffer, [i] new buffer and insert mode',
  '    [b] select, [s] split, [v] split vertically',
  '    [B] [S] [V] for batchmode'
}
vim.g.startify_custom_header = "g:ascii"
