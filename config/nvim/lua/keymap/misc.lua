local wk = require("which-key")
local opt = { mode = { "n" }, noremap = true, silent = true }
local to_ignored = {
  "<cr>", "*", "$", "0", "^", "/", "U", "n", "N", "m",
  "f", "F", "t", "T", "j", "k", "<C-e>", "<C-y>"
}
for _, v in pairs(to_ignored) do
  wk.register({
    [v] = "which_key_ignore",
  }, opt)
end

wk.register({
  ["<C-h>"] = { "<C-w>h", "go left win" },
  ["<C-j>"] = { "<C-w>j", "go down win" },
  ["<C-k>"] = { "<C-w>k", "go up win" },
  ["<C-l>"] = { "<C-w>l", "go right win" },
  ["<C-S-h>"] = { "<C-w>H", "move win left" },
  ["<C-S-j>"] = { "<C-w>J", "move win down" },
  ["<C-S-k>"] = { "<C-w>K", "move win up" },
  ["<C-S-l>"] = { "<C-w>L", "move win right" },
  ["<Tab>"] = { "<cmd>wincmd p<cr>", "✭ go last accessed win" },
  ["<C-g>"] = { "<C-^>", "✭ alternative buffer" },
  ["<C-S-g>"] = { "<cmd>vsplit #<cr>", "✭ split alternative buffer" },
  -- ["<C-z>"] = { "<cmd>normal u<cr>", "undo", mode = { "i" } },
  -- window size
  ["<C-M-k>"] = { "<c-w>+", "increase win height" },
  ["<C-M-j>"] = { "<c-w>-", "decrease win height" },
  ["<C-M-h>"] = { "<c-w><", "decrease win width" },
  ["<C-M-l>"] = { "<c-w>>", "increase win width" },
  -- tab
  ["<C-]>"] = { "<cmd>BufferNext<cr>", "next tab" },
  ["<C-[>"] = { "<cmd>BufferPrev<cr>", "prev tab" },
  ["<C-}>"] = { "<cmd>BufferMoveNext<cr>", "move tab right" },
  ["<C-{>"] = { "<cmd>BufferMovePrevious<cr>", "move tab left" },
  ["<C-p>"] = { "<cmd>BufferPin<cr>", "pin tab" },
  ["<C-M-]>"] = { "<cmd>BufferScrollRight<cr>", "tab scroll right" },
  ["<C-M-[>"] = { "<cmd>BufferScrollLeft<cr>", "tab scroll left" },
  -- delete buffer
  ["<BS>"] = { "<cmd>BufferWipeout<cr>", "delete buffer with jumplist" },
  ["<C-BS>"] = { "<cmd>BufferClose<cr>", "delete buffer" },
  ["<S-BS>"] = { "<cmd>BufferCloseAllButCurrentOrPinned<cr>", "delete other buffers" },
  -- quit
  q = { function()
    local file_path = vim.fn.expand("%:p")
    -- Not quite unsaved file
    if vim.fn.filereadable(file_path) == 0 then
      vim.notify("File is not saved", vim.log.levels.ERROR, { title = "Error" })
      return
    end
    if #vim.api.nvim_list_wins() ~= 1 then
      vim.cmd [[silent! w]]
      vim.cmd [[q]]
    else
      vim.ui.select({ "Yes", "No" }, {
        prompt = 'Only ONE window. Confirm to quit?',
      }, function(yn)
        if yn == "Yes" then
          vim.cmd [[q]]
        end
      end)
    end
  end, "which_key_ignore" },
  ["<C-q>"] = { ":qa<cr>", "which_key_ignore" },
  ["<M-q>"] = { "q", "remapped q" },
}, opt)

wk.register({
  ["<C-->"] = { function()
    local height = vim.api.nvim_win_get_height(0)
    if height + 8 >= vim.o.lines then
      vim.cmd [[vertical wincmd =]]
    else
      vim.cmd [[wincmd _]]
    end
  end, "max win width" },
  ["<C-\\>"] = { function()
    local width = vim.api.nvim_win_get_width(0)
    if width + 8 >= vim.o.columns then
      vim.cmd [[horizontal wincmd =]]
    else
      vim.cmd [[wincmd |]]
    end
  end, "max win width" },
  ["<C-=>"] = { function()
    vim.cmd [[wincmd =]]
  end, "equal win size" },
}, opt)

wk.register({
  ["<S-cr>"] = { "<esc>o", "insert newline", mode = "i" }
}, opt)
wk.register({
  ["<S-cr>"] = { '<cmd>call append(line("."),   repeat([""], v:count1))<cr>', "insert newline", mode = "n" }
}, opt)

wk.register({
  -- mg979/vim-visual-multi
  ["<S-up>"] = { "<Plug>(VM-Select-Cursor-Up)", "visual up" },
  ["<S-down>"] = { "<Plug>(VM-Select-Cursor-Down)", "visual down" },
  ["<S-left>"] = "visual left",
  ["<S-right>"] = "visual right",
  ["<C-up>"] = "multi select up",
  ["<C-down>"] = "multi select down",
}, opt)

set("i", "<C-h>", "<Left>")
set("i", "<C-l>", "<Right>")
set("i", "<C-j>", "<Down>")
set("i", "<C-k>", "<Up>")

set("c", "<C-space>", "<cr>", { noremap = true, silent = true })
set('x', '/', '<Esc>/\\%V', { noremap = true }) -- search in visual scope
