local telescope = require("telescope")
local previewers = require('telescope.previewers')
telescope.setup {
  pickers = {
    git_bcommits = {
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.65,
        width = 145
      },
      prompt_title = "Git Commits on Current Buffer",
      results_title = "|checkout: ⏎ |diff: ^v(split) ^s(plit) ^t(ab)",
      previewer = {
        previewers.new_termopen_previewer {
          title = "Current File Change in commit",
          get_command = function(entry, _)
            return { 'git', 'diff', '-p', '--color', entry.value .. '~', entry.value,
              "--", vim.g.bcommits_file_path, "|", "delta", "--diff-so-fancy" }
          end
        },
      }
    },
    git_commits = {
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.6,
        width = 145
      },
      prompt_title = "Git Commits on Repo",
      results_title = "|checkout: ⏎ |diff: ^v(split) ^s(plit) ^t(ab) |reset: ^rm(ixed), ^rs(oft), ^rh(ard)",
      previewer = {
        previewers.new_termopen_previewer {
          title = "All Change in commit",
          get_command = function(entry, _)
            return { 'git', 'show', '--stat', '-p', '--color', entry.value }
          end
        }
      }
    },
    git_stash = {
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.78,
      },
      prompt_title = "Git Stash",
      results_title = "apply ⏎",
      previewer = {
        previewers.new_termopen_previewer {
          title = "Stashed Change",
          get_command = function(entry, _)
            return { 'git', 'stash', 'show', '--stat', '-p', '--color', entry.value }
          end
        },
      },
    },
    git_status = {
      previewer = {
        previewers.new_termopen_previewer {
          title = "Not-added Changes: Wokring Directory vs. Staged",
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
    },
    git_branches = {
      layout_strategy = "vertical",
      layout_config = {
        width = 0.9,
        preview_height = 0.4,
      },
      wrap_results = false,
      prompt_title = "Git Branch",
      results_title = "|checkout: ⏎ |create: ^a |rebase: ^r |delete: ^d |merge: ^y |track: ^t",
    }
  },
}
