local M = {}

M.conform = function(opts)
  local component = {
    -- List Formatter / Linter
    function()
      local formatters = {}
      local excluded_formatters = { "injected", "codespell", "trim_whitespace" }
      for _, formatter in pairs(require("conform").list_formatters()) do
        if formatter.available then
          local name = formatter.name
          if not vim.tbl_contains(excluded_formatters, name) then
            formatters[name] = true
          end
        end
      end
      formatters = vim.tbl_keys(formatters)
      return table.concat(formatters, " ")
    end,
    icon = { "󰁨", align = "left" }, -- alternative: 
    padding = { left = 1, right = 0 },
    separator = "",
  }
  return vim.tbl_extend("force", component, opts or {})
end

-- Copilot lualine component
-- Copied from https://github.com/LazyVim/LazyVim/blob/d0120ccdd11af8c421e23655c487c3cd68dc0199/lua/lazyvim/plugins/extras/coding/copilot.lua#L21
M.copilot = function(opts)
  local colors = {
    [""] = LazyVim.ui.fg("Special"),
    ["Normal"] = LazyVim.ui.fg("Special"),
    ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
    ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
  }
  local component = {
    function()
      local icon = require("lazyvim.config").icons.kinds.Copilot
      local status = require("copilot.api").status.data
      return icon .. (status.message or "")
    end,
    cond = function()
      if not package.loaded["copilot"] then
        return
      end
      local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
      if not ok then
        return false
      end
      return ok and #clients > 0
    end,
    color = function()
      if not package.loaded["copilot"] then
        return
      end
      local status = require("copilot.api").status.data
      return colors[status.status] or colors[""]
    end,
  }
  return vim.tbl_extend("force", component, opts or {})
end

-- From: https://github.com/romgrk/barbar.nvim/blob/71ac376acd000743146b1e08e62151b4d887bbac/lua/barbar/buffer.lua#L131
local function get_unique_name(first, second)
  local separator = package.config:sub(1, 1)
  local table_concat = table.concat
  local split = vim.split
  local max = math.max
  local min = math.min
  local function slice_from_end(tbl, index_from_end)
    return vim.list_slice(tbl, #tbl - index_from_end + 1)
  end

  local first_parts = split(first, separator)
  local second_parts = split(second, separator)

  local length = 1
  local first_result = table_concat(slice_from_end(first_parts, length), separator)
  local second_result = table_concat(slice_from_end(second_parts, length), separator)

  while first_result == second_result and length < max(#first_parts, #second_parts) do
    length = length + 1
    first_result = table_concat(slice_from_end(first_parts, min(#first_parts, length)), separator)
    second_result = table_concat(slice_from_end(second_parts, min(#second_parts, length)), separator)
  end

  return first_result, second_result
end

M.harpoon2 = {
  -- https://github.com/ThePrimeagen/harpoon/issues/352
  function()
    local harpoon = require("harpoon")
    local files = {}
    local processed = {}
    for index = 1, harpoon:list():length() do
      local harpoon_file_path = harpoon:list():get(index).value
      local name = harpoon_file_path == "" and "[No Name]" or vim.fn.fnamemodify(harpoon_file_path, ":t")
      files[index] = { path = harpoon_file_path, name = name }
      -- Get unique name
      local index2 = processed[name]
      if index2 then
        files[index].name, files[index2].name = get_unique_name(files[index].path, files[index2].path)
      else
        processed[name] = index
      end
    end

    local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
    local list = {}
    for index, file in pairs(files) do
      if current_file_path == file.path then
        list[index] = string.format("%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ", index, file.name)
      else
        list[index] = string.format("%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ", index, file.name)
      end
    end
    return table.concat(list)
  end,
}

-- local active_bg = "#a76969"
local active_bg = "#6369a7"
vim.cmd(string.format("highlight! HarpoonActive guibg=NONE guifg=#c6d0f6 guibg=%s", active_bg))
vim.cmd(string.format("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7 guibg=%s", active_bg))
vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#c6d0f6")
vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
-- vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")

-- ref:
-- * https://github.com/cbochs/grapple.nvim/blob/main/lua/lualine/components/grapple.lua
-- * https://github.com/ThePrimeagen/harpoon/issues/352
local highlights = {
  icon = "󰛢",
  active = "%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ",
  inactive = "%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ",
}

local get_tabs = function(paths, current_path)
  local outputs = {}
  local processed = {}
  for i, path in ipairs(paths) do
    local name = vim.fn.fnamemodify(path, ":t")
    outputs[i] = { path = path, name = name }

    local index1 = i
    local index2 = processed[name]
    if index2 then
      outputs[index1].name, outputs[index2].name = get_unique_name(outputs[index1].path, outputs[index2].path)
    else
      processed[name] = index1
    end
  end

  local list = {}
  for i, output in pairs(outputs) do
    local tag_fmt = highlights.inactive
    if current_path == output.path then
      tag_fmt = highlights.active
    end
    table.insert(list, string.format(tag_fmt, i, output.name))
  end

  return table.concat(list)
end

M.grapple = function(opts)
  local component = {
    function()
      local grapple = require("grapple")
      local tags, _ = grapple.tags()
      local paths = {}
      for _, tag in pairs(tags) do
        table.insert(paths, tag.path)
      end
      local current = grapple.find({ buffer = 0 })
      return get_tabs(paths, current and current.path or "")
    end,
  }
  return vim.tbl_extend("force", component, opts or {})
end

M.arrow = function(opts)
  local component = {
    function()
      local filenames = vim.g.arrow_filenames
      local cwd = vim.fn.getcwd()
      local paths = {}
      for _, filename in pairs(filenames) do
        table.insert(paths, cwd .. "/" .. filename)
      end
      local current_path = vim.api.nvim_buf_get_name(0)
      local buflisted = vim.bo[0].buflisted
      return get_tabs(paths, buflisted and current_path or "")
    end,
  }
  return vim.tbl_extend("force", component, opts or {})
end

M.indent_width = function(opts)
  local component = { -- Indent width
    function()
      return vim.o.shiftwidth
    end,
    icon = { "", align = "left" },
    separator = "",
    padding = { left = 1, right = 0 },
  }
  return vim.tbl_extend("force", component, opts or {})
end

M.lsp_clients = function(opts)
  local excluded_clients = { "copilot" }
  local component = {
    -- List active lsp
    function()
      local clients = {}
      local bufnr = vim.api.nvim_get_current_buf()
      local attached_clients = vim.lsp.get_clients({ bufnr = bufnr })
      for _, client in ipairs(attached_clients) do
        if not vim.tbl_contains(excluded_clients, client.name) then
          clients[client.name] = true
        end
      end
      clients = vim.tbl_keys(clients)
      return table.concat(clients, " ")
    end,
    icon = { "󰒍", align = "left" }, -- alternative: 
    separator = "",
    padding = { left = 1, right = 0 },
  }

  return vim.tbl_extend("force", component, opts or {})
end

-- :h 'statusline' to check vim statusline symbols
-- another example: "Ln %l/%L, Col %c"
M.progress = function(opts)
  local component = {
    function()
      -- return [[%l(%p%%) %LL]]
      -- return [[%l:%c (%p%%)]]
      -- return [[%3l:%c (%LL)]]
      return [[%l:%c (%LL)]]
    end,
    separator = "",
  }
  return vim.tbl_extend("force", component, opts or {})
end

M.visual_lines = function(opts)
  local component = {
    -- Show visual line count (https://www.reddit.com/r/neovim/comments/1130kh5/comment/j8navg6)
    function()
      local is_visual_mode = vim.fn.mode():find("[Vv]")
      if not is_visual_mode then
        return "0L"
      end
      local starts = vim.fn.line("v")
      local ends = vim.fn.line(".")
      local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
      return tostring(lines) .. "L"
    end,
    icon = { "", align = "left" },
    separator = "",
    padding = { left = 1, right = 0 },
  }
  return vim.tbl_extend("force", component, opts or {})
end

return M
