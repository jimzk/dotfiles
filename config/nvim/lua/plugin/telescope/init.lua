local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
telescope.setup {
  -- https://github.com/nvim-telescope/telescope.nvim/issues/1351
  defaults = {
    sorting_strategy = "ascending", -- cursor starts from top result
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
      -- anchor = "S",
      flex = {
        -- use vertical layout when buffer column < filp_columns
        flip_columns = 160,
      },
      vertical = {
        mirror = true,
        height = 0.65,
        -- width = {0.9, max = 160},  -- set width 0.9 when min < buffer column < max
        preview_height = 0.4,
      },
      horizontal = {
        -- height = 0.6,
        -- width = 0.85,
        preview_cutoff = 60, -- hide preview when columns < preview_cutoff
        preview_width = 0.6,
      },
    },
    cache_picker = {
      num_pickers = 10, -- Cache pickers by builtin.pickers
    },
    scroll_strategy = "cycle",
    winblend = 10, -- transparent
    results_title = false, -- hide results title
    dynamic_preview_title = true, -- show file name dynamically in preview title
    path_display = {
      truncate = true, -- truncate long file name
    },
    file_ignore_patterns = { "node_modules", "/dist" },
    wrap_results = false,
    mappings = {
      -- C-/ toggles keymap cheatsheet
      i = {
        -- TODO: https://github.com/nvim-telescope/telescope.nvim/issues/2237
        -- NOTE: "toggle_selection" will be parsed to require("telescope.actions").toggle_selection
        -- parsing rule: https://github.com/nvim-telescope/telescope.nvim/issues/2237
        ["<C-h>"] = actions.results_scrolling_up,
        ["<C-l>"] = actions.results_scrolling_down,
        ["<esc>"] = actions.close, -- disable normal mode
        ["<C-q>"] = actions.close, -- disable normal mode
        ["<C-\\>"] = require("telescope.actions.layout").toggle_preview,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-x>"] = false,
        ["<C-k>"] = actions.preview_scrolling_up,
        ["<C-j>"] = actions.preview_scrolling_down,
        ["<PageUp>"] = false,
        ["<Pagedown>"] = false,
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        -- Open results in trouble
        -- https://github.com/folke/trouble.nvim#telescope
        ["<C-cr>"] = require("trouble.providers.telescope").open_with_trouble,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--no-binary", "--hidden", "--glob", "!{**/.git/*,**/node_modules/*}" },
      mappings = {
        i = {
          -- change working directory to items location
          ["<C-=>"] = {
            function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              require("telescope.actions").close(prompt_bufnr)
              -- Depending on what you want put `cd`, `lcd`, `tcd`
              vim.cmd(string.format("lcd %s", dir))
              vim.notify(string.format("cd to %s", dir:gsub(vim.fn.getenv("HOME"), "~")))
            end, type = "action"
          }
        },
      },
      wrap_results = true,
    },
    buffers = {
      mappings = {
        i = {
          ["<C-BS>"] = "delete_buffer",
        }
      },
      wrap_results = true,
    },
    git_branches = {
      mappings = {
        i = {
          ["<C-BS>"] = "git_delete_branch",
          ["<C-d>"] = "preview_scrolling_down",
        }
      }
    },
    -- Uncompleted. I give up telescope
    live_grep = {
      mappings = {
        i = {
          -- ["<C-y>"] = {
          --   action = actions.move_selection_next,
          --   opts = { nowait = true, silent = true }
          -- },
          ["<tab>"] = {
            function(prompt_bufnr)
    actions.select_default:replace(function()
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local selections = current_picker:get_multi_selection()
      -- if no multi-selection, leverage current selection
      if vim.tbl_isempty(selections) then
        table.insert(selections, action_state.get_selected_entry())
      end
      local paths = vim.tbl_map(function(e)
        return e.path
      end, selections)
      actions.close(prompt_bufnr)
      builtin.live_grep({
        search_dirs = paths,
      })
    end)
    -- true: attach default mappings; false: don't attach default mappings
    return true
  end,

          }<>
          ["<C-d>"] = {
            function(prompt_bufnr)
              local action_state = require "telescope.actions.state"
              local picker = action_state.get_current_picker(prompt_bufnr) -- picker state
              local entry = action_state.get_selected_entry()
              local line = action_state.get_current_line()


              local insert_glob = function(files, file)
                if not file then return end
                if file:sub(1, 1) == '!' then
                  table.insert(files.exclude, file:sub(2, -1))
                else
                  table.insert(files.include, file)
                end
              end
              local glob_pattern = picker.glob_pattern
              local files = {
                include = {},
                exclude = {},
              }
              if type(glob_pattern) == "table" then
                for _, pattern in ipairs(glob_pattern) do insert_glob(files, pattern) end
              else
                insert_glob(files, glob_pattern)
              end
              local result_title = ""
              if #files.include ~= 0 then
                local msg = ""
                for _, include_file in ipairs(files.include) do
                  if msg ~= "" then msg = msg .. ", " end
                  msg = msg .. include_file
                end
                result_title = result_title .. "include: " .. msg
              end
              if #files.exclude ~= 0 then
                local msg = ""
                for _, exclude_file in ipairs(files.include) do
                  if msg ~= "" then msg = msg .. ", " end
                  msg = msg .. exclude_file
                end
                if result_title ~= "" then
                  result_title = result_title .. " | "
                end
                result_title = result_title .. "exclude: " .. msg
              end
            end,
            type = "action"
          },
          ["<Tab>"] = {
            function(prompt_bufnr)
              local action_state = require "telescope.actions.state"
              local current_picker = action_state.get_current_picker(prompt_bufnr) -- picker state
              local query = action_state.get_current_line()
            end,
            type = "action"
          },
        }
      }
    }
  }
}

-- TODO: picker
-- https://github.com/nvim-telescope/telescope.nvim/issues/1701

-- https://github.com/nvim-telescope/telescope.nvim#previewers
vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal wrap]]

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
      local mime_type = vim.split(j:result()[1], "/", {})[1]
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
telescope.setup {
  defaults = {
    buffer_previewer_maker = new_maker,
  }
}

require("plugin.telescope.fzf")
require("plugin.telescope.frency")
require("plugin.telescope.project")
require("plugin.telescope.pickers")
