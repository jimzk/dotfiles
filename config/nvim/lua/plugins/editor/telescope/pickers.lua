local actions = require("telescope.actions")
local state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

local M = {}

actions.show_hidden_and_ignored = function()
  require("telescope.builtin").find_files({
    no_ignore = true,
    hidden = true,
    prompt_title = "Find Files With Hidden and Ignored",
  })
end
-- change working directory to items location
actions.cd_to_file_dir = function(prompt_bufnr)
  local selection = state.get_selected_entry()
  local dir = vim.fn.fnamemodify(selection.path, ":p:h")
  actions.close(prompt_bufnr)
  -- Depending on what you want put `cd`, `lcd`, `tcd`
  vim.cmd(string.format("lcd %s", dir))
  vim.notify(string.format("cd to %s", dir:gsub(vim.fn.getenv("HOME"), "~")))
end

M.find_files = {
  find_command = { "rg", "--files", "--no-binary", "--glob", "!{**/.git/*,**/node_modules/*,target/*}" },
  mappings = {
    i = {
      ["<C-h>"] = actions.show_hidden_and_ignored,
      ["<C-=>"] = actions.cd_to_file_dir,
    },
  },
}

M.buffers = {
  sort_lastused = true,
  mappings = {
    i = {
      ["<C-BS>"] = actions.delete_buffer,
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
      ["<C-BS>"] = actions.git_delete_branch,
      ["<C-D>"] = false,
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
    }
  },
  previewer = {
    previewers.new_termopen_previewer {
      title = "Commit Changes",
      get_command = function(entry, _)
        return { "git", "show", "--stat", "-p", "--color", entry.value }
      end
    }
  }
}

M.git_bcommits = {
  mappings = {
    i = {
      ["<CR>"] = actions.git_diffview,
      ["<C-y>"] = actions.git_copy_revision,
    }
  },
  previewer = {
    previewers.new_termopen_previewer {
      title = "Commit Changes",
      get_command = function(entry, _)
        return { "git", "show", "-p", entry.value, "--", vim.g.bcommits_file_path }
      end
    }
  }
}

M.git_stash = {
  previewer = {
    previewers.new_termopen_previewer {
      title = "Stashed Changes",
      get_command = function(entry, _)
        return { "git", "stash", "show", "--stat", "-p", "--color", entry.value }
      end
    },
  },
}

M.git_status = {
  previewer = {
    previewers.new_termopen_previewer {
      title = "No-added Changes: Wokring Directory vs. Staged",
      get_command = function(entry, _)
        if entry.status == "??" then
          return { "bat", "--style=plain", entry.path }
        end
        return { "git", "diff", entry.path }
      end
    },
    previewers.new_termopen_previewer {
      title = "Added Changes: Staged vs. HEAD",
      get_command = function(entry, _)
        return { "git", "diff", "--cached", entry.path }
      end
    },
    previewers.new_termopen_previewer {
      title = "All Changes: Working Directory vs. HEAD",
      get_command = function(entry, _)
        if entry.status == "??" then
          return { "bat", "--style=plain", entry.path }
        end
        return { "git", "diff", "HEAD", entry.path }
      end
    },
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
    width = 145
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
  M[picker] = vim.tbl_extend("force", M[picker], defaults)
end

return M
