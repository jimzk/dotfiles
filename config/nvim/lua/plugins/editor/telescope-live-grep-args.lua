local M = {
  "nvim-telescope/telescope-live-grep-args.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}
local util = require("util")
local get_prompt = function()
  -- Convert escape char to plain text
  local prompt = vim.fn.mode() == "v" and util.get_selected():gsub("[%'%\"%.%(%)%[%{]", "\\%1")
    or _G.telescope_live_grep_args_prompt
  return prompt
end

local search = function(opts)
  local default_opts = {
    default_text = get_prompt(),
  }
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  require("telescope").extensions.live_grep_args.live_grep_args(opts)
end

-- local search_in_buf = function()
--   local path = vim.fn.fnameescape(vim.fn.expand("%:p:."))
--   require("telescope.builtin").live_grep({
--     prompt_title = "Live Grep in File (" .. path:gsub("^" .. vim.env.HOME, "~") .. ")",
--     search_dirs = { path },
--     default_text = get_prompt(),
--     path_display = { "hidden" },
--   })
-- end

local search_in_buf = function()
  local lazy_util = require("lazyvim.util")
  local path = vim.fn.fnameescape(vim.fn.expand("%:p:."))
  lazy_util.telescope("current_buffer_fuzzy_find", {
    prompt_title = "Fuzzy Search in File (" .. path:gsub("^" .. vim.env.HOME, "~") .. ")",
    default_text = get_prompt(),
    sorting_strategy = "ascending",
  })()
end

M.keys = {
  { mode = { "v", "n" }, "<C-f>", search, desc = "Search" },
  { "<C-M-f>", search, desc = "Search Cursor Word" },
  { mode = { "v", "n" }, "<leader>/", search_in_buf, desc = "Search in File (Telescope)" },
}

M.config = function()
  local telescope = require("telescope")
  local restrict_searching_scope = function(...)
    local lga_actions = require("telescope-live-grep-args.actions")
    lga_actions.quote_prompt({ postfix = " --iglob *." })(...)
  end

  local grep_string = function()
    local action_state = require("telescope.actions.state")
    local prompt = action_state.get_current_line()
    _G.telescope_live_grep_args_prompt = prompt
    prompt = prompt:gsub("\\(.)", "%1") -- Plain escape char to text
    require("telescope.builtin").grep_string({
      search = prompt,
    })
  end

  local actions = require("telescope.actions")
  actions.live_grep_close = function(...)
    local action_state = require("telescope.actions.state")
    local prompt = action_state.get_current_line()
    _G.telescope_live_grep_args_prompt = prompt
    require("telescope.actions").close(...)
  end

  actions.select_live_grep = function(...)
    local action_state = require("telescope.actions.state")
    local prompt = action_state.get_current_line()
    _G.telescope_live_grep_args_prompt = prompt
    actions.select_default(...)
    actions.center(...)
  end

  telescope.setup({
    extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        mappings = { -- extend mappings
          i = {
            -- ["<C-i>"] = lga_actions.quote_prompt({ quote_char = "", postfix = " --iglob *." }),
            ["<M-r>"] = restrict_searching_scope,
            ["<C-f>"] = grep_string,
            ["<Esc>"] = "live_grep_close",
            ["<C-c>"] = "live_grep_close",
            ["<Cr>"] = actions.select_live_grep,
          },
        },
      },
    },
  })
  -- Should load extension after setup
  telescope.load_extension("live_grep_args")

  local _live_grep_args = telescope.extensions.live_grep_args.live_grep_args
  telescope.extensions.live_grep_args.live_grep_args = function(opts)
    local default_opts = {
      prompt_title = "Live Grep in Folder (" .. vim.loop.cwd():gsub("^" .. vim.env.HOME, "~") .. ")",
    }
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})
    _live_grep_args(opts)
  end
end

return M
