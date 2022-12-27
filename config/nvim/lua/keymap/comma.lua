local wk = require("which-key")
local opts = { mode = "n", prefix = ",", noremap = true, silent = true }

-- ,d black hole, d_ to first
for _, key in pairs({ "d", "c", "D", "C" }) do
  wk.register({
    ["," .. key] = { '"_' .. key, "black hole " .. key },
  }, { mode = { "n", "v" }, noremap = true })
end
for _, key in pairs({ "d", "c", "v", "y" }) do
  vim.keymap.set("n", key .. "_", key .. "^", { noremap = true })
  wk.register({
    [key .. "_"] = "which_key_ignore",
  }, { noremap = true })
end

wk.register({
  p = { function()
    -- Get content from clipboard
    local pasted = vim.fn.getreg("+")
        :gsub("^%s+", "")-- Remove leading whitespaces
        :gsub("\n$+", "") -- Remove ending line break
    pasted = " " .. pasted -- add leading whitespace
    local lines = {}
    for str in string.gmatch(pasted, "([^\n]+)") do
      table.insert(lines, str)
    end
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local col = vim.fn.col("$")
    vim.api.nvim_buf_set_text(0, row - 1, col - 1, row - 1, col - 1, lines)
  end, "paste after line end" },
  P = { function()
    -- Get content from clipboard
    local pasted = vim.fn.getreg("+")
        :gsub("\n$+", "") -- Remove ending line break
    local lines = {}
    for str in string.gmatch(pasted, "([^\n]+)") do
      table.insert(lines, str)
    end
    table.insert(lines, "")
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, lines)
  end, "paste in line above" }
}, opts)

wk.register({
  ["<space>"] = { function()
    vim.cmd [[normal! "vy]]
    local lua_code = vim.fn.getreg("+")
        :gsub("%-%-([^\n]+)", "")-- remove comment. [^\n] means any char except \n
        :gsub("[\n\r]", " ")
        :gsub("[%s]+", " ")
    vim.cmd("lua " .. lua_code)
  end, "execute selected lua code", mode = { "v" } },
}, opts)

wk.register({
  ["<space>"] = { function()
    local lua_code = vim.fn.getreg("+")
        :gsub("%-%-([^\n]+)", "")-- remove comment. [^\n] means any char except \n
        :gsub("[\n\r]", " ")
        :gsub("[%s]+", " ")
    vim.cmd("lua " .. lua_code)
  end, "execute lua code from clipboard" },
}, opts)
