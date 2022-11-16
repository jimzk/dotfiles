local ignored = {}
local ignore_char = function(c)
  vim.keymap.set("n", "s" .. c, "<esc>")
  ignored[c] = "which_key_ignore"
end
for i = 0, 26 do
  ignore_char(string.char(65 + i))  -- ignore A-Z
  ignore_char(string.char(97 + i))  -- ignore a-z
end

require("which-key").register(vim.tbl_extend("force", ignored, {
  name = "buffer & tab",

  -- splitjoin
  ["-"] = "[C] split line by language",
  ["="] = "[C] join line by language",
  -- configured in minimal.vim
  ["]"] = "add empty line bewlow",
  ["["] = "add empty line above",
  -- buffer
  -- q = "quit",
  -- w = "write",
  q = { "<cmd>q<cr>", "quit" },
  ["<C-q>"] = { "<cmd>:qall<cr>", "quit all" },
  w = { "<cmd>w<cr>", "write" },
  d = {"<cmd>t.<cr>", "duplicate current line"},
  j = { "<C-^>", "go alternative buffer# - <C-^>" },
  J = { "<C-w>^", "split alternative buffer# " },
  t = { "<cmd>BufferLinePick<cr>", "pick a tab" },
  ["<C-t>"] = { "<cmd>tabnew<cr>", "new tab" },
  i = { "<cmd>tabprev<cr>", "go previous tab - gT" },
  o = { "<cmd>tabnext<cr>", "go next tab - gt" },
  I = { "<cmd>tabm -1<cr>", "move tab left" },
  O = { "<cmd>tabm +1<cr>", "move tab right" },
  -- Compared with :bdelete, :bwipeout remove buffer from jumplist.
  -- :Bdelete and :Bwipeout are suppotred by vim.bbye
  x = { "<cmd>Bwipeout<cr>", "delete buffer with jumplist" },
  X = { "<cmd>Bwipeout!<cr>", "delete buffer with jumplist forcely" },
  ["<C-x>"] = { "<cmd>%bd<cr>", "delete all buffers" },
  l = { "<cmd>ls<cr>", "list buffers - ls" },
  L = { "<cmd>tabs<cr>", "list tabs - :tabs" },
  b = { function() require("telescope.builtin").buffers(require("telescope.themes").get_ivy {
      prompt_title = "Find Buffer",
      results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
      layout_config = {
        preview_width = 0.75,
      },
      sort_lastused = true,
    })
  end, "buffers" },
}), { prefix = "s" })
