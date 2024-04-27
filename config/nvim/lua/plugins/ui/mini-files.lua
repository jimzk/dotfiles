-- TODO: integrate with git status
-- https://www.reddit.com/r/neovim/comments/1cfd5w1/minifiles_git_status_integration/
return {
  "echasnovski/mini.files",
  keys = {
    {
      "<C-p>",
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
    {
      "<C-M-P>",
      function()
        local ft = vim.bo.filetype
        local win_id = 0
        if ft == "minifiles" or vim.bo.buflisted then
          win_id = require("window-picker").pick_window()
          if not win_id then
            vim.notify("Can't find any window", vim.log.levels.ERROR, { title = "mini.files" })
            return
          end
        end
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        path = vim.api.nvim_buf_get_name(buf_id)
        MiniFiles.open(path)
      end,
      "Open Mini Files And Locate Buffer",
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
        map("n", "<Esc>", MiniFiles.close, nil, opts)
        -- map("n", "l", function()
        --   if MiniFiles.get_fs_entry().fs_type == "directory" then
        --     MiniFiles.go_in()
        --   end
        -- end, nil, opts)
        map("n", "<cr>", function()
          MiniFiles.go_in()
          local fs_type = MiniFiles.get_fs_entry().fs_type
          if fs_type == "file" then
            MiniFiles.close()
          end
        end, "Open File", ops)
      end,
    })
  end,
}
