local actions = require("telescope.actions")
local state = require("telescope.actions.state")
local lazy_util = require("lazyvim.util")
local previewers = require("telescope.previewers")

local M = {}

local live_grep_args = function(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local title = action_state.get_current_picker(prompt_bufnr).prompt_title
  require("telescope").extensions.live_grep_args.live_grep_args({
    default_text = title:match("%((.+)%)"),
  })
end
M.grep_string = {
  mappings = {
    i = {
      ["<C-f>"] = live_grep_args,
    },
  },
}

-- Remember query
M.live_grep = {
  mappings = {
    i = {
      ["<Esc>"] = "live_grep_close",
      ["<C-c>"] = "live_grep_close",
    },
  },
}

M.current_buffer_fuzzy_find = {
  mappings = {
    i = {
      ["<Esc>"] = "live_grep_close",
      ["<C-c>"] = "live_grep_close",
    },
  },
}

local toggle_hidden_and_ignored = function(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local line = action_state.get_current_line()
  lazy_util.telescope("find_files", {
    no_ignore = true,
    hidden = true,
    follow = true,
    default_text = line,
    prompt_title = "Find Files (Show Hidden and Ignored)",
  })()
end
-- change working directory to items location
local cd_to_file_dir = function(prompt_bufnr)
  local selection = state.get_selected_entry()
  local dir = vim.fn.fnamemodify(selection.path, ":p:h")
  actions.close(prompt_bufnr)
  -- Depending on what you want put `cd`, `lcd`, `tcd`
  vim.cmd(string.format("lcd %s", dir))
  vim.notify(string.format("cd to %s", dir:gsub(vim.fn.getenv("HOME"), "~")))
end

M.find_files = {
  -- find_command = { "rg", "--files", "--no-binary", "--glob", "!{**/.git/*,**/node_modules/*,target/*,**/.DS_Store}" },
  mappings = {
    i = {
      ["<M-h>"] = toggle_hidden_and_ignored,
      ["<M-=>"] = cd_to_file_dir,
    },
  },
}

M.buffers = {
  sort_lastused = true,
  mappings = {
    i = {
      ["<C-D>"] = actions.delete_buffer,
    },
  },
}

local yank_highlight = function(prompt_bufnr)
  local selection = state.get_selected_entry()
  local value = selection.value
  copy(value)
  vim.notify("Highlight " .. value .. " copied", vim.log.levels.INFO, { title = "Highlights" })
  actions.close(prompt_bufnr)
end

M.highlights = {
  mappings = {
    i = {
      ["<C-y>"] = yank_highlight,
    },
  },
}

-- https://github.com/ryanburda/config/blob/main/dotfiles/nvim/lua/plugins/configs/telescope.lua#L112
actions.git_diffview = function(prompt_bufnr)
  local entry = state.get_selected_entry()
  actions.close(prompt_bufnr)
  -- open diffview
  local revision = entry.name or entry.value -- name for git_branches and value for git_commits
  vim.cmd("DiffviewOpen " .. revision)
end

actions.git_copy_revision = function(prompt_bufnr)
  local entry = state.get_selected_entry()
  actions.close(prompt_bufnr)
  local revision = entry.name or entry.value -- name for git_branches and value for git_commits
  copy(revision)
  vim.notify("Git revision " .. revision .. " is copied", vim.log.levels.INFO, { title = "Telescope" })
end

M.git_branches = {
  mappings = {
    i = {
      ["<CR>"] = actions.git_diffview,
      ["<C-y>"] = actions.git_copy_revision,
    },
  },
}

M.git_commits = {
  mappings = {
    i = {
      ["<CR>"] = actions.git_diffview,
      ["<C-y>"] = actions.git_copy_revision,
    },
  },
  previewer = {
    previewers.new_termopen_previewer({
      title = "Commit Changes",
      get_command = function(entry, _)
        return { "git", "show", "--stat", "-p", "--color", entry.value }
      end,
    }),
  },
}

M.git_bcommits = {
  mappings = {
    i = {
      ["<CR>"] = actions.git_diffview,
      ["<C-y>"] = actions.git_copy_revision,
    },
  },
  previewer = {
    previewers.new_termopen_previewer({
      title = "Commit Changes",
      get_command = function(entry, _)
        return { "git", "show", "-p", entry.value, "--", vim.g.bcommits_file_path }
      end,
    }),
  },
}

M.git_stash = {
  previewer = {
    previewers.new_termopen_previewer({
      title = "Stashed Changes",
      get_command = function(entry, _)
        return { "git", "stash", "show", "--stat", "-p", "--color", entry.value }
      end,
    }),
  },
}

M.git_status = {
  previewer = {
    previewers.new_termopen_previewer({
      title = "No-added Changes: Wokring Directory vs. Staged",
      get_command = function(entry, _)
        if entry.status == "??" then
          return { "bat", "--style=plain", entry.path }
        end
        -- return { "git", "diff", entry.path }
        return { "git", "diff", "HEAD", entry.path }
      end,
    }),
    previewers.new_termopen_previewer({
      title = "Added Changes: Staged vs. HEAD",
      get_command = function(entry, _)
        return { "git", "diff", "--cached", entry.path }
      end,
    }),
    previewers.new_termopen_previewer({
      title = "All Changes: Working Directory vs. HEAD",
      get_command = function(entry, _)
        if entry.status == "??" then
          return { "bat", "--style=plain", entry.path }
        end
        return { "git", "diff", "HEAD", entry.path }
      end,
    }),
    -- default previewers
    -- previewers.git_commit_diff_to_parent.new(),
    -- previewers.git_commit_diff_to_head.new(),
    -- previewers.git_commit_diff_as_was.new(),
    -- previewers.git_commit_message.new(),
  },
}

local defaults = {
  layout_strategy = "vertical",
  layout_config = {
    height = 0.90,
    preview_height = 0.6,
    width = 145,
  },
}

local pickers = {
  "git_branches",
  "git_commits",
  "git_bcommits",
  "git_stash",
  "git_status",
}
for _, picker in ipairs(pickers) do
  M[picker] = vim.tbl_extend("force", M[picker] or {}, defaults)
end

return M
