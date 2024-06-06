-- search/replace in multiple files
-- TODO: https://www.reddit.com/r/neovim/comments/1b5ri9g/developing_search_replace_similar_to_vs_code_with
local M = {
  "nvim-pack/nvim-spectre",
}
M.keys = function()
  return {
    {
      "<leader>sr",
      function()
        local spectre = require("spectre")
        local query = require("spectre.actions").get_state().query
        spectre.open({
          path = query.path,
          search_text = query.search_query,
          replace_text = query.replace_query,
        })
      end,
      desc = "Replace (Spectre)",
    },
    {
      "<leader>sr",
      function()
        vim.cmd('noau normal! "vy"')
        local content = vim.fn.getreg("v")
        require("spectre").open({
          search_text = content,
        })
      end,
      desc = "Replace (Spectre)",
      mode = "v",
    },
    {
      "<leader>sb",
      function()
        local spectre = require("spectre")
        local query = require("spectre.actions").get_state().query
        local path = vim.fn.fnameescape(vim.fn.expand("%:p:."))
        spectre.open({
          search_text = query.search_query,
          replace_text = query.replace_query,
          path = path,
        })
      end,
      desc = "Replace in Buffer (Spectre)",
    },
    {
      "<leader>sb",
      function()
        vim.cmd('noau normal! "vy"')
        local content = vim.fn.getreg("v")
        local path = vim.fn.fnameescape(vim.fn.expand("%:p:."))
        require("spectre").open({
          search_text = content,
          path = path,
        })
      end,
      desc = "Replace in Buffer (Spectre)",
      mode = "v",
    },
  }
end

M.opts = {
  live_update = true, -- update search results after writing any files
  highlight = {
    ui = "String",
    search = "DiffText",
    replace = "DiffDelete",
  },
  mapping = {
    ["toggle_line"] = {
      map = "<tab>",
      cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
      desc = "toggle current item",
    },
    ["enter_file"] = {
      map = "<cr>",
      cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
      desc = "goto current file",
    },
    ["exit"] = {
      map = "<C-r>",
      cmd = "<cmd>lua require('spectre').close()<CR>",
      desc = "close",
    },
    ["send_to_qf"] = {
      map = "f",
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = "send all item to quickfix",
    },
    ["replace_cmd"] = {
      map = "g",
      cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
      desc = "input replace vim command",
    },
    ["show_option_menu"] = {
      map = "to",
      cmd = "<cmd>lua require('spectre').show_options()<CR>",
      desc = "show options",
    },
    ["run_current_replace"] = {
      map = "r",
      cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
      desc = "replace current line",
    },
    ["run_replace"] = {
      map = "R",
      cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
      desc = "replace all",
    },
    ["change_view_mode"] = {
      map = "<leader>v",
      cmd = "<cmd>lua require('spectre').change_view()<CR>",
      desc = "change result view mode",
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
    ["toggle_live_update"] = {
      map = "tu",
      cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
      desc = "update change when vim write file.",
    },
    ["toggle_ignore_case"] = {
      map = "ti",
      cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
      desc = "toggle ignore case",
    },
    ["toggle_ignore_hidden"] = {
      map = "th",
      cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
      desc = "toggle search hidden",
    },
    ["resume_last_search"] = {
      map = "z",
      cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
      desc = "resume last search before close",
    },
    -- you can put your mapping here it only  normal mode
  },
}

return M
