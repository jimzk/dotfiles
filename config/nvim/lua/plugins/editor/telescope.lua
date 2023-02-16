-- fuzzy finder
local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  event = "VeryLazy",
  keys = {
    { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
    { "<leader>/", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },

    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    -- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    -- { "<leader>st", "<cmd>Telescope builtin<cr>", desc = "Telescope" },
    {
      "<leader>ss",
      Util.telescope("lsp_document_symbols", {
        symbols = {
          "Class",
          "Function",
          "Method",
          "Constructor",
          "Interface",
          "Module",
          "Struct",
          "Trait",
          "Field",
          "Property",
        },
      }),
      desc = "goto Symbol",
    },
  },
}

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#dont-preview-binaries
local get_preview_maker = function()
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
      end,
    }):sync()
  end
  return new_maker
end

M.opts = function()
  local actions = require("telescope.actions")
  local opts = {}
  opts.defaults = {
    sorting_strategy = "ascending", -- cursor starts from top result
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      flex = {
        -- use vertical layout when window column < filp_columns
        flip_columns = 160,
      },
      vertical = {
        -- flip location of results/prompt and preview windows
        mirror = true,
        preview_height = 0.4,
      },
      horizontal = {},
    },
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = {
      truncate = true, -- truncate long file name
    },
    results_title = false, -- hide results title
    dynamic_preview_title = true, -- Use dynamic preview title if avaliable
    file_ignore_patterns = { "node_modules", "/dist" },
    wrap_results = true,
    buffer_previewer_maker = get_preview_maker(),
    mappings = {
      i = {
        ["<Esc>"] = actions.close, -- disable normal mode
        ["<C-\\>"] = require("telescope.actions.layout").toggle_preview,
        ["<C-M-p>"] = actions.results_scrolling_up,
        ["<C-M-n>"] = actions.results_scrolling_down,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-b>"] = actions.preview_scrolling_up,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-S-T>"] = function(...)
          return require("trouble.providers.telescope").open_with_trouble(...)
        end,
        -- Disable defaults
        ["<C-x>"] = false,
        ["<PageUp>"] = false,
        ["<Pagedown>"] = false,
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  }

  local show_hidden_and_ignored = function()
    require("telescope.builtin").find_files({
      no_ignore = true,
      hidden = true,
      prompt_title = "Find Files With Hidden and Ignored",
    })
  end
  -- change working directory to items location
  local cd_to_file_dir = function(prompt_bufnr)
    local selection = require("telescope.actions.state").get_selected_entry()
    local dir = vim.fn.fnamemodify(selection.path, ":p:h")
    actions.close(prompt_bufnr)
    -- Depending on what you want put `cd`, `lcd`, `tcd`
    vim.cmd(string.format("lcd %s", dir))
    vim.notify(string.format("cd to %s", dir:gsub(vim.fn.getenv("HOME"), "~")))
  end

  opts.pickers = {
    find_files = {
      find_command = { "rg", "--files", "--no-binary", "--glob", "!{**/.git/*,**/node_modules/*,target/*}" },
      mappings = {
        i = {
          ["<C-h>"] = show_hidden_and_ignored,
          ["<C-=>"] = cd_to_file_dir,
        },
      },
    },
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-BS>"] = actions.delete_buffer,
        },
      },
    },
    git_branches = {
      mappings = {
        i = {
          ["<C-BS>"] = actions.git_delete_branch,
        },
      },
    },
    live_grep = {},
  }
  return opts
end

-- Some tips
-- - `default_text` could prefill promptj
--    https://www.reddit.com/r/neovim/comments/st1kxs/some_telescope_tips/

M.config = function(_, opts)
  local ts = require("telescope")
  ts.setup(opts)
  vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
  -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
  ts.load_extension("fzf")
end

return M
