require('spectre').setup {
  live_update = true, -- update search results after writing any files
  highlight = {
    ui = "String",
    search = "DiffText",
    replace = "DiffDelete"
  },
  mapping = {
    ['toggle_line'] = {
      map = "dd",
      cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
      desc = "toggle current item"
    },
    ['enter_file'] = {
      map = "<cr>",
      cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
      desc = "goto current file"
    },
    ['exit'] = {
      map = "q",
      cmd = "<cmd>lua require('spectre').close()<CR>",
      desc = "close",
    },
    ['send_to_qf'] = {
      map = "<leader>q",
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = "send all item to quickfix"
    },
    ['replace_cmd'] = {
      map = "<C-r>",
      cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
      desc = "input replace vim command"
    },
    ['show_option_menu'] = {
      map = "to",
      cmd = "<cmd>lua require('spectre').show_options()<CR>",
      desc = "show options"
    },
    ['run_current_replace'] = {
      map = "r",
      cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
      desc = "replace current line"
    },
    ['run_replace'] = {
      map = "R",
      cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
      desc = "replace all"
    },
    ['change_view_mode'] = {
      map = "<leader>v",
      cmd = "<cmd>lua require('spectre').change_view()<CR>",
      desc = "change result view mode"
    },
    -- ['change_replace_sed'] = {
    --   map = "trs",
    --   cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
    --   desc = " sed to replace"
    -- },
    -- ['change_replace_oxi'] = {
    --   map = "tro",
    --   cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
    --   desc = " oxi to replace"
    -- },
    ['toggle_live_update'] = {
      map = "tu",
      cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
      desc = "update change when vim write file."
    },
    ['toggle_ignore_case'] = {
      map = "ti",
      cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
      desc = "toggle ignore case"
    },
    ['toggle_ignore_hidden'] = {
      map = "th",
      cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
      desc = "toggle search hidden"
    },
    ['resume_last_search'] = {
      map = "<leader>l",
      cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
      desc = "resume last search before close"
    },
    -- you can put your mapping here it only  normal mode
  },
}
