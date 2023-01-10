local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions
local wk = require("which-key")
wk.register({
  name = "fuzzy search",
  -- find file
  ["<C-f>"] = { function()
    builtin.find_files({
      prompt_title = "Find File In Working Directory",
      results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
      follow = true,
      hidden = true,
    })
  end, "files in working directory" },
  F = { function()
    builtin.find_files({
      prompt_title = "Find File In My Space",
      results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
      search_dirs = { '~/workspace', '~/Desktop', "~/.config", "~/go", "~/Downloads" },
      follow = true,
      hidden = true,
    })
  end, "files in my space" },
  o = { function()
    extensions.frecency.frecency({ -- repalce oldfiles with frecency
      results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
      prompt_title = "Find Recently Opened File in CWD",
      workspace = "CWD",
    })
  end, "recent files" },
  O = { function()
    extensions.frecency.frecency({ -- repalce oldfiles with frecency
      results_title = "|open: ^v(split) ^s(plit) ^t(ab) |tags: :work: :dot:",
      prompt_title = "Find Recently Opened File",
    })
  end, "recent files (all)" },
  b = { function()
    builtin.buffers(require("telescope.themes").get_ivy {
      prompt_title = "Buffers List",
      results_title = "|open: ^v(split) ^s(plit) ^t(ab) |delete ^<BS>",
      sort_lastused = true,
    })
  end, "go buffers" },
  -- find git file
  G = { function() builtin.git_files({
      results_title = "|open ^v(split) ^s(plit) ^t(ab)",
      prompt_title = "Find Git File",
      show_untracked = true,
    })
  end, "git files" },
  g = { function() builtin.git_status({
      results_title = "|(un)stage: ⇥ |open: ^v(split) ^s(plit) ^t(ab)",
      prompt_title = "Find Git Changed File",
      git_icons = {
        added = "A",
        changed = "M",
        copied = ">",
        deleted = "D",
        renamed = "➡",
        unmerged = "‡",
        untracked = "?",
      }
    })
  end, "changed git files" },
  t = { "<cmd>Telescope current_buffer_tags<cr>", "tags in current buffer" },
  T = { "<cmd>Telescope tags<cr>", "tags in repository" },
}, { prefix = "<leader>f" })
