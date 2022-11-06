local builtin = require'telescope.builtin'
local themes = require'telescope.themes'
local actions = require'telescope.actions'
local actions_layout = require'telescope.actions.layout'

require("telescope").setup{
  -- https://github.com/nvim-telescope/telescope.nvim/issues/1351
  defaults = {
    sorting_strategy = "ascending",  -- cursor starts from top result
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      anchor = "S",
      flex = {
        -- use vertical layout when buffer column < filp_columns
        flip_columns = 160,
      },
      vertical = {
        mirror = true,
        height = 0.9,
        -- width = {0.9, max = 160},  -- set width 0.9 when min < buffer column < max
        width = 140,
        preview_height = 0.5,
      },
      horizontal = {
        height = 0.6,
        width = 0.85,
        preview_cutoff = 60,  -- hide preview when columns < preview_cutoff
        preview_width = 0.6,
      },
    },
    wrap_results = true,
    results_title = false,  -- hide results title
    dynamic_preview_title = true,  -- show file name dynamically in preview title
    path_display = {
      truncate = true,  -- truncate long file name
    },
    file_ignore_patterns = {"node_modules", "/dist"},
    mappings = {
      i = {
        ["<C-Space>"] = require("telescope.actions").toggle_selection,
        ["<C-j>"] = require("telescope.actions").results_scrolling_up,
        ["<C-k>"] = require("telescope.actions").results_scrolling_down,
        ["<C-l>"] = require("telescope.actions").cycle_previewers_next,
        ["<C-h>"] = require("telescope.actions").cycle_previewers_prev,
        ["<right>"] = require("telescope.actions").cycle_previewers_next,
        ["<left>"] = require("telescope.actions").cycle_previewers_prev,
        ["<down>"] = require("telescope.actions").move_selection_next,
        ["<up>"] = require("telescope.actions").move_selection_previous,
        ["<esc>"] = require("telescope.actions").close,-- disable normal mode
        ["<M-space>"] = require("telescope.actions.layout").toggle_preview,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--no-binary", "--hidden", "--glob", "!{**/.git/*,**/node_modules/*}" },
      mappings = {
        i = {
          -- TODO: show notification
          ["<C-o>"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            require("telescope.actions").close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format("lcd %s", dir))
          end,
        },
      },
    },
  },
}

-- Dont preview binaries
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#dont-preview-binaries
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end
require("telescope").setup {
  defaults = {
    buffer_previewer_maker = new_maker,
  }
}


-- Wrap preview
-- https://github.com/nvim-telescope/telescope.nvim#previewers
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal wrap")

-- Setup extensions
require('telescope').setup {
  extensions = {
    -- nvim-telescope/telescope-fzf-native.nvim
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                                      -- the default case_mode is "smart_case"
    }
  },
}

require("telescope").load_extension('fzf')

local wk = require("which-key")
wk.register({
  name = "search file",
  -- find files
  f = {function() return builtin.find_files({
      prompt_title = "Find File In Working Directory",
      results_title = "open ^v(vsplit) ^x(split) ^t(new tab), help ^/",
      follow = true,
      hidden = true,
    }) end, "files in working directory"},
  F = {function() return builtin.find_files({
      prompt_title = "Find File In My Space",
      results_title = "open ^v(vsplit) ^x(split) ^t(new tab), help ^/",
      search_dirs = {'~/workspace', '~/Desktop', "~/.config", "~/go", "~/Downloads"},
      follow = true,
      hidden = true,
    })end, "files in my space"},
  r = {function() return builtin.oldfiles({
      results_title = "open ^v(vsplit) ^x(split) ^t(new tab), help ^/",
      prompt_title = "Find Recently Opened File",
    }
  ) end, "recently opened files"},
  b = {function() return builtin.buffers(themes.get_ivy{
      prompt_title = "Find Buffer",
      results_title = "open ^v(vsplit) ^x(split) ^t(new tab), help ^/",
      layout_config = {
        preview_width = 0.75,
      },
      sort_lastused = true,
    }) end, "buffers"},
  -- find git files
  g = {function() return builtin.git_files({
      results_title = "open ^v(vsplit) ^x(split) ^t(new tab), help ^/",
      prompt_title = "Find Git File",
    }) end, "git files"},
  c = {function() return builtin.git_status({
      results_title = "(un)stage ⇥, open ⏎ ^v(vsplit) ^x(split) ^t(new tab)",
      prompt_title = "Find Git Changed File",
    }) end, "changed git files"},
  -- grep line
  l = {function() return builtin.live_grep({
      prompt_title = "Grep Line In Current Buffer",
      search_dirs = {vim.fn.expand('%'),},

      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.4,
        width = 140,
      },
      wrap_results = false,
    }) end, "grep line in current buffer"},
  L = {function() return builtin.live_grep({
      prompt_title = "Grep Line In Buffers",
      grep_open_files = true,

      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.4,
        width = 140,
      },
      wrap_results = false,
    }) end, "grep line in buffers"},
  [";"] = {function() return builtin.live_grep({
      prompt_title = "Grep Line In Working Directory",

      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.4,
        width = 140,
      },
      wrap_results = false,
    }) end, "grep line in working directory"},
    -- jump
    j = {function() return   builtin.jumplist({
        prompt_title = "Location Jumplist",
        -- trim_text = true,
        -- name_width = 100,
        layout_strategy = "vertical",
        layout_config = {
          preview_height = 0.4,
          width = 140,
        },
      }) end, "location jumplist"},
    t = {"<cmd>Telescope current_buffer_tags<cr>", "tags in current buffer"},
    T = {"<cmd>Telescope tags<cr>", "tags in project"},

}, {prefix = "<leader>f"})

wk.register({
  l = {function() return builtin.git_bcommits({
      layout_strategy = "vertical",
      layout_config = {
        width = 140,
      },
      prompt_title = "Git Commits on Current Buffer",
      results_title = "checkout ⏎, diff ^v(vsplit) ^x(split) ^t(new tab)",
      -- TODO: reorder previewers
      -- preview cmd: git -c delta.paging=never diff <git_ref> <path>
      -- ref: telescope.nvim/lua/telescope/builtin/__git.lua, search git.bcommits
      -- previewer = {
      --   require'telescope.previewers'.git_commit_diff_to_parent.new(),
      --   require'telescope.previewers'.git_commit_diff_to_head.new(),
      --   require'telescope.previewers'.git_commit_diff_as_was.new(),
      --   require'telescope.previewers'.git_commit_message.new(),
      -- },
    }) end, "commits on current buffer"},
  L = {function() return builtin.git_bcommits({
      layout_strategy = "vertical",
      layout_config = {
        width = 140,
      },
      prompt_title = "Git Commits on Current Buffer",
      results_title = "checkout ⏎, diff ^v(vsplit) ^x(split) ^t(new tab)",
    }) end, "commits"},
  t = {function() return builtin.git_stash({
      layout_strategy = "vertical",
      layout_config = {
        width = 140,
      },
      prompt_title = "Git Stash",
      results_title = "apply ⏎",
    }) end, "stashes"},
  r = {function() return builtin.git_branches({
      layout_strategy = "vertical",
      layout_config = {
        width = 0.9,
        preview_height = 0.35,
      },
      wrap_results = false,
      prompt_title = "Git Branch",
      results_title = "checkout ⏎, new ^a, rebase ^t, delete ^d, merge ^y, track ^t",
    }) end, "branches"},
}, {prefix = "<leader>g"})

wk.register({
  name = "coding",
  s = {function() return builtin.treesitter({
      prompt_title = "Function Names, Variables and Symbols",
      results_title = "autocompletion menu ^l",
    }) end, "symbol in current buffer"},
  q = {function() return builtin.quickfix({
      prompt_title = "Quick Fix",
    }) end, "list items in quickfix"},
  ["/"] = {function() return builtin.search_history({
      prompt_title = "Search History",
    }) end, "list search history"},
  m = {function() return builtin.filetypes({
      prompt_title = "Change Filetype",
    }) end, "change current buffer's filetype"},
}, {prefix = "<leader>c"})

--- configuration example
--- https://github.com/nvim-telescope/telescope.nvim/issues/2095#issuecomment-1193385941
---
--- Configuration tips:
---
--- [documentation]
--- :h telescope.defaults.layout_strategy
---
--- [keymapp]
--- local builtin = require'telescope.builtin'
--- vim.keymap.set('n', "ff", function() return builtin.find_files({
---   promp_title = "Find File In Working Directory",
--- }) end)
--- vim.keymap.set('n', "ff", "<cmd>Telescope find_files<cr>")  -- same effect with above
