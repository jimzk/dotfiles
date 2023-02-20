vim.g.fzf_command_prefix = "Fzf"
vim.api.nvim_create_autocmd('FileType', {
  pattern = { "fzf" },
  callback = function()
    local opts = { noremap = true, buffer = true }
    set('t', '<Esc>', [[<cmd>q<cr>]], opts)
  end
})

-- TODO: override default quickfix/locallist method
-- see actions.file_edit_or_qf,

-- https://github.com/ibhagwan/fzf-lua#default-options
local actions = require("fzf-lua.actions")
local fzf = require("fzf-lua")
local utils = require("fzf-lua.utils")
fzf.setup {
  winopts = {
    height  = 0.7,
    width   = 0.9,
    row     = 0.6,
    col     = 0.5,
    -- border  = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    -- border  = { 'x', 'y', 'z', 'a', 'b', 'c', 'd', 'e' },
    -- border  = { '│', 'y', '│', 'a', '│', 'c', '│', 'e' },
    -- border  = 'none',
    preview = {
      border    = "noborder",
      layout    = 'down',
      -- Only used with the builtin previewer:
      title     = false,
      -- border conflict with nvim-scrollbar
      scrollbar = false,
      winopts   = {
        cursorline = false,
      }
    }
  },
  keymap = {
    builtin = {
      -- neovim `:tmap` mappings for the fzf win
      ["<F1>"]  = "toggle-help",
      ["<F2>"]  = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"]  = "toggle-preview-wrap",
      ["<F4>"]  = "toggle-preview",
      -- Rotate preview clockwise/counter-clockwise
      ["<F5>"]  = "toggle-preview-ccw",
      ["<F6>"]  = "toggle-preview-cw",
      ["<C-j>"] = "preview-page-down",
      ["<C-k>"] = "preview-page-up",
    }
  },
  fzf_opts = {
    ["--exact"] = "",
  },
}

-- Global actions
fzf.setup {
  actions = {
    files = {
      -- customize function
      ["ctrl-y"]  = function(selected)
        local item = selected[1]
        vim.notify(item)
      end,
      ["default"] = actions.file_edit_or_qf,
      ["ctrl-s"]  = actions.file_split,
      ["ctrl-v"]  = actions.file_vsplit,
      ["ctrl-t"]  = actions.file_tabedit,
      ["alt-q"]   = actions.file_sel_to_qf,
      ["alt-l"]   = actions.file_sel_to_ll,
    },
    buffers = {
      ["default"] = actions.buf_edit_or_qf,
      ["ctrl-s"]  = actions.buf_split,
      ["ctrl-v"]  = actions.buf_vsplit,
      ["ctrl-t"]  = actions.buf_tabedit,
    }
  },
}

local create_keymap_header = function(keymaps)
  local header = [["::]]
  for _, keymap in ipairs(keymaps) do
    -- style from https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/core.lua#L609
    header = header .. " " ..
        ([[<%s> to %s]]):format(
          utils.ansi_codes.yellow(keymap[1]),
          utils.ansi_codes.red(keymap[2]))
  end
  return header .. [["]]
end

local get_query = function(opts)
  local query = opts.__resume_data.last_query
  query = query and query:gsub(" ", "\\ ") or " "
  return query
end

-- Providers setup
-- TODO: register help? https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/config.lua#L1024
fzf.files_or_git_files = function(...)
  local in_git_repo = vim.fn.system("git rev-parse") == ""
  if in_git_repo then
    fzf.git_files(...)
  else
    fzf.files(...)
  end
end

local default_file_view = {
  previewer = false,
  winopts   = {
    width = 100,
  },
  fzf_opts  = {
    ["--exact"] = "",
  },
}

-- Cycle among oldfiles, git files and files
set("n", "<leader>ff", function() fzf.oldfiles { cwd_only = true } end, { desc = "find file in buffers" })
local cycle_key = "tab"
fzf.setup {
  git = {
    files = vim.tbl_deep_extend("force", vim.deepcopy(default_file_view), {
      git_icons = false,
      actions = {
        [cycle_key] = function(_, opts)
          fzf.files {
            prompt = "AllFiles❯ ",
            cwd = '~',
            -- no hidden file, exclude some directories
            fd_opts = "--color=never --type f --follow -E .git -E Library -E Pictures -E 'go'",
            fzf_opts = {
              ["--query"] = get_query(opts)
            }
          }
        end,
      }
    })
  },
  files = vim.tbl_deep_extend("force", vim.deepcopy(default_file_view), {
    actions = {
      [cycle_key] = function(_, opts)
        fzf.oldfiles {
          cwd_only = true,
          fzf_opts = {
            ["--query"] = get_query(opts)
          }
        }
      end,
    }
  }),
  oldfiles = vim.tbl_deep_extend("force", vim.deepcopy(default_file_view), {
    prompt   = "Oldfiles❯ ",
    fzf_opts = {
      ["--header"] = create_keymap_header({
        { cycle_key, "GitFiles" }
      }),
    },
    actions  = {
      -- Switch between current cwd and global
      ["ctrl-o"] = function(_, opts)
        fzf.oldfiles {
          cwd_only = not opts.cwd_only,
          prompt = opts.prompt == "Oldfiles❯ " and "Oldfiles(All)❯ " or "Oldfiles❯ "
        }
      end,
      [cycle_key] = function(_, opts)
        fzf.files_or_git_files {
          fzf_opts = {
            ["--query"] = get_query(opts)
          }
        }
      end
    }
  }),
  buffers = vim.tbl_deep_extend("force", vim.deepcopy(default_file_view), {
    -- fzf_opts = { ["--header"] = [["custom header"]]  },
    actions = {
      ["ctrl-d"] = { actions.buf_del, actions.resume }, -- not quite
      [cycle_key] = function(_, opts)
        fzf.files_or_git_files {
          fzf_opts = {
            ["--query"] = get_query(opts)
          }
        }
      end,
    },
  }),
}

fzf.setup {
  git = {
    -- TODO: open item by :Browse
    -- ADD header for actions
    status = {
      fzf_opts = {
        ['--tac'] = '',
      },
      preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
      actions = {
        ["ctrl-a"] = { actions.git_stage, actions.resume },
      },
    },
    commits = {
      preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
      -- TODO: copy commit shash
      -- ADD header for actions
      actions = {
        -- ["default"] = actions.git_checkout,
        ["tab"] = function(_, _)
          vim.cmd [[DiffviewFileHistory %]]
        end
      },
    },
    bcommits = {
      preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
      actions = {
        -- TODO: copy commit shash
        -- TODO: open for diff
        -- ["default"] = actions.git_buf_edit,
        -- ["ctrl-s"]  = actions.git_buf_split,
        -- ["ctrl-v"]  = actions.git_buf_vsplit,
        -- ["ctrl-t"]  = actions.git_buf_tabedit,
        ["tab"] = function(_, opts)
          vim.cmd [[DiffviewFileHistory %]]
        end
      },
    },
  },
  grep = {
    -- !Example to use glob: foo -- *.txt (only include txt)
    -- https://github.com/ibhagwan/fzf-lua/wiki#how-can-i-restrict-my-grep-search-to-just-certain-files
    rg_glob = true,
    actions = {
      -- ["btab"] = { actions.grep_lgrep }, -- toogle between grep and live_grep
      ["ctrl-f"] = function(_, opts)
        -- relative path
        local path = vim.api.nvim_buf_get_name(0):gsub(vim.fn.getcwd(0) .. '/', '')
        local pattern = (' -g ' .. path)
            :gsub("%-", "%%-")
            :gsub("%.", "%%.")
        if opts.rg_opts:find(pattern) then
          opts.rg_opts = opts.rg_opts:gsub(pattern, '')
          opts.prompt = "Rg❯ "
        else
          opts.prompt = "Rg(Buffer)❯ "
          opts.rg_opts = opts.rg_opts:gsub('$', pattern)
        end
        -- fzf.live_grep(opts)  -- This doesn't work. I guess it's due to opts.cmd is fixed
        fzf.live_grep {
          resume = true,
          resume_search_default = opts.__resume_data.last_query,
          rg_opts = opts.rg_opts,
          prompt = opts.prompt,
        }
        -- live_grep_resume can't restore prompt and rg_opts
        _G._live_grep_opts = {
          rg_opts = opts.rg_opts,
          prompt = opts.prompt
        }
      end,
      -- ["ctrl-f"] = function() end,
    },
  },
  highlights = {
    actions = {
      ["enter"] = function(selected, _)
        selected = selected[1]
        vim.fn.setreg("+", selected)
        vim.notify("Copy highlight " .. selected, vim.log.levels.INFO, { title = "FZF" })
      end,
    }
  }
}

_G._live_grep_opts = {}
-- set("n", "tt", function() fzf.live_grep_resume(_G._live_grep_opts) end, { desc = "search" })
-- set("v", "tt", fzf.grep_visual, { desc = "search visual selection" })
set("n", "<C-f>", function() fzf.live_grep_resume(_G._live_grep_opts) end, { desc = "search" })
set("v", "<C-f>", fzf.grep_visual, { desc = "search visual selection" })

local wk = require("which-key")
wk.register({
  name = "Git",
  ["<cr>"] = { "<cmd>GBrowse<cr>", "open file in github" },
  t = { fzf.buffers, "list buffers" },
  g = { fzf.git_status, "git status" },
  l = { fzf.git_bcommits, "file commits" },
  L = { fzf.git_commits, "repo commits" },
  s = { fzf.git_stash, "file commits" },
  r = { fzf.git_branches, "file commits" },
  b = { "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", "line blame" },
  B = { "<cmd>Git blame<cr>", "file blame" },
  ["<space>"] = { "<cmd>Git<cr>", "git status and operations" },
  -- d = { "<cmd>Gvdiffsplit<cr>", "current file diff" },
  d = { function()
    vim.cmd [[DiffviewOpen]]
    vim.cmd [[sleep 60m]] -- wait cursur to be located
    vim.cmd [[DiffviewToggleFiles]]
    vim.cmd [[wincmd l]]
  end, "current file diff" },
  D = { "<cmd>DiffviewOpen<cr><cmd>wincmd l<cr><cmd>wincmd l<cr>", "all files diff" },
  p = { fzf.jumps, "go jumps list" },
}, { prefix = "t" })

set("n", "<F1>", fzf.help_tags, { desc = "help" })