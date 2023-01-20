local M = {}

M.root_patterns = { ".git", "lua" }

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- this will return a function that calls telescope.
-- cwd will defautlt to util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts or {}
    -- opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})

    if builtin == "find_files" then
      local dir = opts.cwd or vim.fn.getcwd()
      dir = vim.fs.normalize(dir):gsub(vim.fn.getenv("HOME"), "~")
      opts.results_title = "Path: " .. dir
    end

    -- if builtin == "files" then
    --   if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
    --     opts.show_untracked = true
    --     builtin = "git_files"
    --   else
    --     builtin = "find_files"
    --   end
    -- end
    require("telescope.builtin")[builtin](opts)
  end
end

-- FIXME: create a togglable termiminal
-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean}
function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    size = { width = 0.9, height = 0.9 },
  }, opts or {})
  require("lazy.util").float_term(cmd, opts)
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  local lazy_util = require("lazy.core.util")
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return lazy_util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      lazy_util.info("Enabled " .. option, { title = "Option" })
    else
      lazy_util.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local enabled = true
function M.toggle_diagnostics()
  enabled = not enabled
  local lazy_util = require("lazy.core.util")
  if enabled then
    vim.diagnostic.enable()
    lazy_util.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    lazy_util.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

function M.deprecate(old, new)
  local lazy_util = require("lazy.core.util")
  lazy_util.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new), { title = "LazyVim" })
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

function M.get_selected()
  local cmd = vim.fn.mode() == "n" and [["vyiw']] or [["vy']]
  vim.cmd("normal! " .. cmd)
  return vim.fn.getreg("v")
end

function M.shorten_require(root_path)
  return function(path)
    local path = root_path .. "." .. path
    return require(path)
  end
end

function M.read_specs(path, names)
  local packages = {}
  for _, name in pairs(names) do
    table.insert(packages, require(path .. "." .. name))
  end
  return packages
end

function M.tbl_combine(left, right)
  for _, value in ipairs(right) do
    table.insert(left, value)
  end
  return left
end

function M.load_specs(dir, specs)
  local path = vim.fn.stdpath("config") .. "/lua/plugins/" .. dir
  local paths = vim.split(vim.fn.glob(path .. "/*"), "\n")
  specs = specs or {}
  for _, file in pairs(paths) do
    local basename = vim.fs.basename(file):gsub("%.lua", "")
    -- Ignore init.lua and _* file
    if basename ~= "init" and basename:sub(1, 1) ~= "_" then
      local package = "plugins." .. dir .. "." .. basename
      table.insert(specs, require(package))
    end
  end
  return specs
end

M.unlisted_filetypes = {
  "",
  "help",
  "man",
  "alpha",
  "dashboard",
  "neo-tree",
  "neo-tree-popup",
  "Trouble",
  "lazy",
  "mason",
  "fzf",
  "qf",
  "TelescopePrompt",
  "notify",
  "fugitive",
  "fugitiveblame",
  "DressingInput",
  "DressingSelect",
  "DiffviewFiles",
  "spectre_panel",
  "fzf",
  "lspinfo",
  "startuptime",
  "tsplayground",
  "PlenaryTestPopup",
  "toggleterm",
  "harpoon",
  "mind",
  "undotree",
  "noice",
  "NeogitPopup",
}

_G.Util = M

_G.map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  if rhs == nil then
    opts.mode = mode
    vim.defer_fn(function()
      require("which-key").register({ [lhs] = { desc or "which_key_ignore" } }, opts)
    end, 1000)
    return
  end
  if desc == nil then
    desc = "which_key_ignore"
  elseif desc == "" then
    desc = nil
  end
  opts.desc = desc
  opts.silent = true
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- For debug
_G.copy = function(...)
  local msg = "empty params"
  local params = {}
  if next({ ... }) then
    -- get the count of the params
    for i = 1, select("#", ...) do
      -- select the param
      local param = select(i, ...)
      table.insert(params, vim.inspect(param))
    end
  else
  end
  if #params > 0 then
    msg = table.concat(params, "\n")
  end
  vim.fn.setreg("+", msg)
end
