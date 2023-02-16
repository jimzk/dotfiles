-- toggle options
local toggle = function(option, silent, values)
  return { function()
    Util.toggle(option, silent, values)
  end, "toggle " .. option }
end

local set_mapppings = function(mappings, opts)
  local prefix = opts.prefix
  opts.prefix = nil
  for key, mapping in pairs(mappings) do
    local mode = mapping.mode or "n"
    local lhs = prefix .. key
    local rhs = mapping[1]
    local desc = mapping[2]
    map(mode, lhs, rhs, desc, opts)
  end
end

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
local mappings = {
  -- name = "+options",
  n = toggle("number"),
  r = toggle("relativenumber"),
  w = toggle("wrap"),
  s = toggle("ignorecase"),
  h = toggle("hlsearch"),
  i = toggle("incsearch"),
  c = toggle("conceallevel", false, { 0, conceallevel }),
  m = { "<cmd>MarksToggleSigns<cr>", "toggle marks sign" },
  f = { require("plugins.lsp.format").toggle, "toggle format on save" },
  d = { Util.toggle_diagnostics, "toggle diagnostics" },
  ["<tab>"] = { function()
    vim.ui.input(
      { prompt = "Enter indent width: " },
      function(input)
        if not input then
          return
        end
        vim.bo.tabstop = tonumber(input)
        vim.bo.shiftwidth = tonumber(input)
        vim.notify("Set indent width to " .. input)
      end
    )
  end, "set indent width", },
  o = { "<cmd>Telescope vim_options<cr>", "all vim options" },
  b = { function()
    vim.cmd [[Gitsigns toggle_current_line_blame]]
    vim.notify("Toggle inline Git blame", vim.log.levels.INFO, { title = "Option" })
  end, "toggle line blame" },
  g = { function()
    if not vim.g.gitsigns_deleted_word_diff_enabled then
      vim.notify([[Enable highlight on Git deletion and diffs]],
        vim.log.levels.INFO, { title = "Option" })
      vim.g.gitsigns_deleted_word_diff_enabled = true
    else
      vim.notify([[Disable highlight on Git deletion and diffs]],
        vim.log.levels.WARN, { title = "Option" })
      vim.g.gitsigns_deleted_word_dilff_enabled = false
    end
    vim.cmd [[Gitsigns toggle_deleted]]
    vim.cmd [[Gitsigns toggle_word_diff]]
  end, "toggle git change inline" }
}

set_mapppings(mappings, { prefix = "<leader>o" })

---------------------------------------
mappings = {
  -- name = "+editor",
  c = { "<cmd>Telescope colorscheme enable_preview=true<cr>", "list colorschemes" },
  a = { "<cmd>Telescope autocommands<cr>", "list autocommands" },
  k = { "<cmd>Telescope keymaps<cr>", "list keymaps" },
  h = { "<cmd>FzfLua highlights<cr>", "list highlights" },
  -- highlights under cursor
  H = { vim.show_pos, "show highlight under cursor" },
  z = { "<cmd>Lazy<cr>", "Lazy" },
  t = { function() vim.notify(vim.treesitter.get_node_at_cursor()) end, "inspect treesitter ndoe in current cursor" }
}
set_mapppings(mappings, { prefix = "<leader>n" })

----------------File-----------------------
mappings = {
  -- name = "+file operation",
  o = { function()
    local path = vim.fn.expand("%:p")
    vim.cmd("silent !open " .. path)
  end, "open file by VSCode" },
  O = { function()
    local path = vim.fn.getcwd()
    vim.cmd("silent !code " .. path)
  end, "open cwd by VSCode" },
  c = { function()
    local path = vim.fn.expand("%:p:h")
    vim.cmd("silent cd " .. path)
    vim.notify("cd to " .. path:gsub(vim.fn.getenv("HOME"), "~"))
  end, "cd to file directory" },
  C = { function()
    vim.cmd("Gcd")
    vim.notify("cd to Git repo root " .. vim.fn.getcwd():gsub(vim.fn.getenv("HOME"), "~"))
  end, "cd to repo root" },
  y = { function()
    local file_path = vim.fn.expand("%:p")
    vim.fn.setreg("+", file_path)
    vim.notify("File path copied", vim.log.levels.INFO)
  end, "copy file path" },
  r = { function()
    vim.ui.input(
      {
        prompt = "[G] Enter new file name: ",
        default = vim.fn.expand("%:t"),
      },
      function(input)
        if not input then return end
        vim.cmd("GRename " .. input)
      end)
  end, "[G] rename file" },
  m = { function()
    vim.ui.input(
      {
        prompt = "[G] Move file to: ",
        default = vim.fn.expand("%:."),
      },
      function(input)
        if not input then return end
        vim.cmd("GMove " .. input)
      end)
  end, "[G] move file" },
  d = { function()
    vim.cmd("GDelete")
  end, "[G] delete file" },
  D = { function()
    vim.cmd("GDelete!")
  end, "[G] delete file forcely" },
}
set_mapppings(mappings, { prefix = "<leader>h" })

map("x", "<leader>go", [["vy<cmd>'<,'>GBrowse!<cr>]], "[G] copy GitHub URL for range")
map("x", "<leader>gO", [["vy<cmd>'<,'>GBrowse<cr>]], "[G] open GitHub URL for range")

mappings = {
  -- name = "+Git",
  o = { "<cmd>GBrowse!<cr>", "copy GitHub URL for file" },
  O = { "<cmd>GBrowse<cr>", "open GitHub URL for file" },
  f = { "<cmd>FzfLua git_status<cr>", "git status file (fzf)" },
  -- l = { "<cmd>FzfLua git_bcommits<cr>", "file commits (fzf)" },
  -- L = { "<cmd>FzfLua git_commits<cr>", "repo commits (fzf)" },
  l = { function()
    vim.g.bcommits_file_path = vim.api.nvim_buf_get_name(0)
    vim.cmd [[Telescope git_bcommits]]
  end, "file commits (telescope)" },
  L = { "<cmd>Telescope git_commits<cr>", "repo commits (telescope)" },

  -- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
  -- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },

  s = { "<cmd>FzfLua git_stash<cr>", "stash (fzf)" },
  -- r = { "<cmd>FzfLua git_branches<cr>", "branch (fzf)" },
  r = { "<cmd>Telescope git_branches<cr>", "branch (telescope)" },
  B = { "<cmd>Git blame<cr>", "file blame (fugitive)" },
  g = { "<cmd>Neogit kind=vsplit<cr>", "git operations (neogit)" },
  G = { "<cmd>Git<cr><cmd>wincmd L<cr><cmd>6<cr>", "git operations (fugitive)" },

  -- d = { "<cmd>Gvdiffsplit<cr>", "current file diff" },
  d = { "<cmd>Gitsigns diffthis<cr>", "current file diff (gitsigns)" },
  -- d = { function()
  --   vim.cmd [[DiffviewOpen]]
  --   vim.cmd [[sleep 60m]] -- wait cursur to be located
  --   vim.cmd [[DiffviewToggleFiles]]
  --   vim.cmd [[wincmd l]]
  -- end, "current file diff" },
  D = { "<cmd>DiffviewOpen<cr><cmd>wincmd l<cr><cmd>wincmd l<cr>", "all files diff (diffview)" },

  -- review PR locally
  p = { function()
    vim.ui.input(
      { prompt = "Enter indent width: " },
      function(input)
        if not input then
          return
        end
        if not tonumber(input, 10) then
          vim.notify("Invalid indent width", vim.log.levels.ERROR)
          return
        end
        vim.cmd("!gh pr checkout " .. input .. " && git reset HEAD~")
        vim.cmd("DiffviewOpen")
      end
    )
  end, "review PR locally" },
  -- lazygit
  z = { function() Util.float_term({ "lazygit" }) end, "Lazygit (cwd)" },
  Z = { function() Util.float_term({ "lazygit" }, { cwd = Util.get_root() }) end,
    "Lazygit (root dir)" },
}
set_mapppings(mappings, { prefix = "<leader>g" })

mappings = {
  -- name = "+edit",
  -- Clear search, diff update and redraw
  -- taken from runtime/lua/_editor.lua
  ["<cr>"] = { "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    "redraw / clear hlsearch / diff update", },
  l = { "<cmd>lopen<cr>", "open location List" },
  q = { "<cmd>copen<cr>", "open quickfix List" },
  t = { function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[tabnew %]]
    vim.api.nvim_win_set_cursor(0, pos)
  end, "new tab", },
  m = { "<cmd>Telescope filetypes<cr>", "set filetype" },
}
set_mapppings(mappings, { prefix = "<leader>j" })

map("n", "<leader>j\\", function()
  local home = vim.fn.getenv("HOME")
  -- local filename = vim.fn.expand("%:p:t")
  -- local repo_root = vim.fn.system("git rev-parse --show-toplevel")
  --     :gsub(home, "~")
  --     :gsub("\n", "")
  -- local filedir = vim.fn.expand("%:p:h")
  --     :gsub(home, "~")
  --     :gsub(repo_root, "")
  local relative_file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local msg = string.format([[
[cwd]
  %s
[file_path]
  %s
[file_type]
  %s
[options]
ignorecase  %s
      wrap  %s]],
    vim.fn.getcwd():gsub(home, "~"),
    "/" .. relative_file_path,
    vim.bo.filetype,
    vim.o.ignorecase and "✅" or "❌",
    vim.o.wrap and "✅" or "❌"
  )
  require("notify")(msg, vim.log.levels.INFO, { title = "File Detail", timeout = 3000 })
end, "show buffer info")

mappings = {
  -- name = "+file",
  f = { Util.telescope("find_files", {
    prompt_title = "Find Files (cwd)",
    hidden = true,
    no_ignore = true,
    follow = true,
  }), "find files (cwd)" },
  -- f = {"<cmd>LeaderfFile<cr>", "find files (leaderf)", mode = {"n", "x"}},
  F = { function()
    local cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    Util.telescope("find_files", {
      cwd = cwd,
      prompt_title = "Find Files (buffer dir)",
      hidden = true,
      no_ignore = true,
      follow = true,
    })()
  end, "find files (cwd)" },
  ["<C-f>"] = { Util.telescope("find_files", {
    prompt_title = "Find Files (workspace)",
    find_command = { "rg", "--files",
      "--glob",
      "!{**/.git/*,**/node_modules/*,target/*,**/*.pdf,**/*.jpg,**.mp3,**/*.mp4,Library/*,Pictures/*,Downloads/*,**/bin/*,}",
      "--glob",
      "!{**/oh-my-zsh/*}",
      -- "!{.Trash/**,.cache/**,.vscode/**,.m2/**,.npm/**}",
    },
    cwd = "~",
    search_dirs = { "~/workspace", "~/.dotfiles", "~/.config" },
  }), "find files (workspace)" },

  -- https://www.reddit.com/r/neovim/comments/10qubtl/comment/j6rwly4
  -- b = { ":buffers<CR>:buffer<Space>", "switch buffer" }
  b = { Util.telescope("buffers", {
    show_all_buffers = true,
    sort_lastused = true
  }), "buffers" },
  -- b = {"<cmd>LeaderfBuffer<cr>", "buffers (leaderf)"},

  o = { function()
    require("telescope").extensions.frecency.frecency({
      prompt_title = "Oldfiles (cwd)",
      workspace = "CWD",
    })
  end, "old files (cwd)" },
  O = { function()
    require("telescope").extensions.frecency.frecency({
      prompt_title = "Oldfiles (global)",
    })
  end, "old files (global)" },
  n = { "<cmd>enew<cr>", "new file" },
  j = { "<cmd>Telescope jumplist show_line=false<cr>", "jumplist" },
}
set_mapppings(mappings, { prefix = "<leader>f" })

map("n", "<leader><Tab>", "<cmd>Telescope resume<cr>", "resume telescope")

mappings = {
  -- name = "+coding",
  I = { "<cmd>CmpStatus<cr>", "cmp status" },
  n = { "<cmd>Neogen<cr>", "add class / function comment (neogen)" },
}
set_mapppings(mappings, { prefix = "<leader>c" })

mappings = {
  s = { function()
    vim.ui.input(
      { prompt = "New session name: " },
      function(name)
        if not name then return end
        vim.cmd("PossessionSave " .. name)
      end)
  end, "save new session", },
  d = { "<cmd>PossessionDelete<cr>", "delete current session" },
  q = { "<cmd>PossessionClose<cr>", "close current session" },
  p = { Util.posession_list, "load session" },
  g = { function()
    -- https://github.com/nvim-telescope/telescope-project.nvim
    require("telescope").extensions.project.project({
      prompt_title = "Find Git Projects",
      display_type = "minimal", -- or full
    })
  end, "git projects" },
}
set_mapppings(mappings, { prefix = "<leader>p" })
