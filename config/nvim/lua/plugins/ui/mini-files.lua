-- TODO: integrate with git status
-- https://www.reddit.com/r/neovim/comments/1cfd5w1/minifiles_git_status_integration/
return {
  "echasnovski/mini.files",
  keys = {
    {
      "<C-r>p",
      function()
        local ft = vim.bo.filetype
        if ft == "minifiles" then
          MiniFiles.close()
        else
          local path = MiniFiles.get_latest_path()
          if not path and vim.bo.buflisted then
            path = vim.fn.expand("%:p") -- file path
          end
          MiniFiles.open(path)
        end
      end,
      desc = "Open Mini Files",
    },
  },
  opts = {
    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
    mappings = {
      close = "q",
      go_in = "l",
      go_in_plus = "L",
      go_out = "h",
      go_out_plus = "H",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },

    -- General options
    options = {
      -- Whether to delete permanently or move into module-specific trash
      permanent_delete = false,
      -- Whether to use for editing directories
      use_as_default_explorer = true,
    },
    windows = {
      max_number = math.huge,
      preview = false,
      width_focus = 30,
      width_nofocus = 25,
      width_preview = 100,
    },
  },
  config = function(_, opts)
    require("mini.files").setup()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "minifiles" },
      callback = function(opts)
        local opts = { buffer = opts.buf }
        local map = Util.map
        -- map("n", "<Esc>", MiniFiles.close, nil, opts)

        map("n", "<cr>", function()
          local entry = MiniFiles.get_fs_entry()
          MiniFiles.go_in()
          if entry.fs_type == "file" then
            MiniFiles.close()
          end
        end, "Open File", opts)

        map("n", "<C-f>", function()
          local win_id = require("window-picker").pick_window()
          if win_id then
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            local path = vim.api.nvim_buf_get_name(buf_id)
            MiniFiles.open(path)
          end
        end, "Locate Buffer", opts)

        local map_split = function(lhs, direction)
          local rhs = function()
            local new_target_window
            vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
              vim.cmd(direction .. " split")
              new_target_window = vim.api.nvim_get_current_win()
            end)
            MiniFiles.set_target_window(new_target_window)
            MiniFiles.go_in()
            MiniFiles.close()
          end
          -- local desc = "Split " .. direction
          map("n", lhs, rhs, nil, opts)
        end
        map_split("<C-s>", "belowright horizontal")
        map_split("<C-v>", "belowright vertical")
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        LazyVim.lsp.on_rename(event.data.from, event.data.to)
      end,
    })
  end,
}
