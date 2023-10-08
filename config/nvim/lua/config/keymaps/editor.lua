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
  -- r = toggle("relativenumber"),
  r = { function()
    Util.toggle("modifiable")
    Util.toggle("readonly")
  end, "toggle modifiable", },
  w = toggle("wrap"),
  c = toggle("ignorecase"),
  h = toggle("hlsearch"),
  i = toggle("incsearch"),
  C = toggle("conceallevel", false, { 0, conceallevel }),
  p = toggle("paste"), -- Paste without losing indent
  m = { "<cmd>MarksToggleSigns<cr>", "toggle marks sign" },
  d = { Util.toggle_diagnostics, "toggle diagnostics" },
  ["<tab>"] = { function()
    vim.ui.input(
      { prompt = "Enter indent width: " },
      function(input)
        if not input then return end
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
  [":"] = { "<cmd>Telescope commands<cr>", "list commands" },
  m = { "<cmd>Telescope man_pages<cr>", "list man pages" },
  h = { "<cmd>FzfLua highlights<cr>", "list highlights" },
  v = { "<cmd>Telescope vim_options<cr>", "list vim options" },
  ["<F1>"] = { "<cmd>Telescope help_tags<cr>", "list help tags" },
  -- highlights under cursor
  H = { vim.show_pos, "show highlight under cursor" },
  z = { "<cmd>Lazy<cr>", "Lazy" },
  t = { function()
    local node = vim.treesitter.get_node():type()
    copy(node)
    vim.notify("Treesitter node [" .. node .. "] is copied")
  end, "copy treesitter ndoe under cursor" }
}
set_mapppings(mappings, { prefix = "<leader>n" })

----------------File-----------------------
mappings = {
  -- name = "+file operation",
  o = { function()
    local path = vim.fn.expand("%:p")
    vim.cmd("silent !code " .. path)
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
        default = "./" .. vim.fn.expand("%:."),
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
  n = { "<cmd>enew<cr>", "new file" },
  N = { function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[tabnew %]]
    vim.api.nvim_win_set_cursor(0, pos)
  end, "new tab", },
  n = { "<cmd>enew<cr>", "new file" },
  i = { "<cmd>Telescope filetypes<cr>", "set filetype" },
  l = { "<cmd>lopen<cr>", "open location List" },
  q = { "<cmd>copen<cr>", "open quickfix List" },
}
set_mapppings(mappings, { prefix = "<leader>h" })

map("n", "<leader>go", function()
  vim.cmd [[silent! GBrowse!]]
  local url = vim.fn.getreg("+")
  local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
  url = url .. [[#L]] .. tonumber(line)
  vim.fn.setreg("+", url)
end, "[G] copy file's GitHub URL")
map("n", "<leader>gO", function()
  local clipboard = vim.fn.getreg("+")
  vim.cmd [[silent! GBrowse!]]
  local url = vim.fn.getreg("+")
  local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
  url = url .. [[\#L]] .. tonumber(line)
  vim.cmd([[silent! !open "]] .. url .. [["]])
  vim.fn.setreg("+", clipboard)
end, "[G] open file's GitHub URL")
map("x", "<leader>go", [["vy<cmd>'<,'>GBrowse!<cr>]], "[G] copy file's ranged GitHub URL")
map("x", "<leader>gO", [["vy<cmd>'<,'>GBrowse<cr>]], "[G] open file's ranged GitHub URL")

mappings = {
  -- name = "+Git",
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
  b = { "<cmd>Git blame<cr>", "file blame (fugitive)" },
  G = { "<cmd>Git<cr><cmd>wincmd L<cr><cmd>6<cr>", "git operations (fugitive)" },
  -- d = { "<cmd>Gvdiffsplit<cr>", "current file diff" },
  d = { "<cmd>Gitsigns diffthis<cr>", "current file diff (gitsigns)" },
  -- d = { function()
  --   vim.cmd [[DiffviewOpen]]
  --   vim.cmd [[sleep 60m]] -- wait cursur to be located
  --   vim.cmd [[DiffviewToggleFiles]]
  --   vim.cmd [[wincmd l]]
  -- end, "current file diff" },
  -- https://www.reddit.com/r/neovim/comments/11ls23z/comment/jbe7uzl
  D = { function()
    local views = require("diffview.lib").views
    if #views == 0 then
      vim.cmd [[DiffviewOpen]]
      vim.cmd [[wincmd l]]
      vim.cmd [[wincmd l]]
    else
      vim.cmd("DiffviewClose")
    end
  end, "all files diff (diffview)" },
  -- review PR locally
  p = { function()
    vim.ui.input(
      { prompt = "Enter PR number for review: " },
      function(input)
        if not input then return end
        if not tonumber(input, 10) then
          vim.notify("Input is not a number", vim.log.levels.ERROR)
          return
        end
        vim.cmd("silent !gh pr checkout " .. input .. " && git reset HEAD~")
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
}
set_mapppings(mappings, { prefix = "<leader>j" })

map("n", "<leader>h\\", function()
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
  end, "find files (buf dir)" },
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
  b = {
    Util.telescope("buffers", { show_all_buffers = true, sort_lastused = true }),
    "buffers",
  },

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
  j = { "<cmd>Telescope jumplist show_line=false<cr>", "jumplist" },
}
set_mapppings(mappings, { prefix = "<leader>f" })
map("n", "<leader>i", "<cmd>FzfLua git_status<cr>", "git status file (fzf)")
map("n", "<leader><tab>", "<cmd>Telescope resume<cr>", "resume telescope")

mappings = {
  -- name = "+coding",
  I = { "<cmd>CmpStatus<cr>", "cmp status" },
  n = { "<cmd>Neogen<cr>", "add class / function comment (neogen)" },
}
set_mapppings(mappings, { prefix = "<leader>c" })

mappings = {
  -- Overwrite or create session
  s = { function()
    vim.ui.select({ "Overwrite", "Save New" }, {
      prompt = "Session",
    }, function(choice)
      if choice == "Overwrite" then
        local path = vim.fn.stdpath("data") .. "/possession"
        local sessions = {}
        for _, file in ipairs(vim.split(vim.fn.glob(path .. "/*.json"), "\n")) do
          table.insert(sessions, vim.fn.fnamemodify(file, ":t:r"))
        end
        vim.ui.select(sessions, {
          prompt = "Overwite Session"
        }, function(session)
          if not session then return end
          vim.cmd("PossessionSave! " .. session)
        end)
      end
      if choice == "Save New" then
        vim.ui.input({
          prompt = "New session name: ",
        }, function(name)
          if not name then return end
          vim.cmd("PossessionSave! " .. name)
        end)
      end
    end)
  end, "save new session", },
  d = { "<cmd>PossessionDelete<cr>", "delete current session" },
  q = { "<cmd>PossessionClose<cr>", "close current session" },
  p = { function()
    require("telescope").extensions.possession.list(
      require("telescope.themes").get_dropdown {
        layout_config = { mirror = true }
      })
  end, "load session" },
  g = { function()
    -- https://github.com/nvim-telescope/telescope-project.nvim
    require("telescope").extensions.project.project({
      prompt_title = "Find Git Projects",
      display_type = "minimal", -- or full
    })
  end, "git projects" },
}
set_mapppings(mappings, { prefix = "<leader>p" })

mappings = {
  ["<leader>"] = {
    ["="] = { "=", "indent (=)", mode = { "n", "x", "o" } },
    ["H"] = { "H", "H", mode = { "n", "x", "o" } },
    ["L"] = { "L", "L", mode = { "n", "x", "o" } },
    ["M"] = { "M", "M", mode = { "n", "x", "o" } },
  },
  -- ["<C-u>"] = { "<C-u>zz" },
  -- ["<C-d>"] = { "<C-d>zz" },
}
set_mapppings(mappings, { prefix = "" })
