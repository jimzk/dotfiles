require("telescope").setup {
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
        -- height = 0.9,
        -- width = {0.9, max = 160},  -- set width 0.9 when min < buffer column < max
        preview_height = 0.5,
      },
      horizontal = {
        -- height = 0.6,
        -- width = 0.85,
        preview_cutoff = 60,  -- hide preview when columns < preview_cutoff
        preview_width = 0.6,
      },
    },
    results_title = false,  -- hide results title
    dynamic_preview_title = true,  -- show file name dynamically in preview title
    path_display = {
      truncate = true,  -- truncate long file name
    },
    file_ignore_patterns = {"node_modules", "/dist"},
    mappings = {
      -- C-/ toggles keymap cheatsheet
      i = {
        -- NOTE: "toggle_selection" will be parsed to require("telescope.actions").toggle_selection
        ["<C-j>"] = "results_scrolling_up",
        ["<C-k>"] = "results_scrolling_down",
        ["<C-l>"] = "cycle_previewers_next",
        ["<down>"] = "move_selection_next",
        ["<up>"] = "move_selection_previous",
        ["<esc>"] = "close",  -- disable normal mode
        ["<C-\\>"] = require("telescope.actions.layout").toggle_preview,
        ["<C-s>"] = "select_horizontal",
        ["<C-x>"] = false,
        ["<M-u>"] = "preview_scrolling_up",
        ["<M-d>"] = "preview_scrolling_down",
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--no-binary", "--hidden", "--glob", "!{**/.git/*,**/node_modules/*}" },
      mappings = {
        i = {
          -- change working directory
          ["<C-=>"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            require("telescope.actions").close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format("lcd %s", dir))
            -- TODO: show to avoid error msg when module can't be found?
            require("notify").notify(string.format("cd to %s", dir))
          end,
        },
      },
    },
    buffers = {
      mappings = {
        i = {
          ["<C-BS>"] = "delete_buffer",
        }
      }
    }
  },
}

-- Wrap
require("telescope").setup{
  defaults = {wrap_results = true}
}
-- https://github.com/nvim-telescope/telescope.nvim#previewers
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal wrap")

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
