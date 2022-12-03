local ignored = {}
local ignore_char = function(c)
  vim.keymap.set("n", "s" .. c, "<esc>")
  ignored[c] = "which_key_ignore"
end
for i = 0, 26 do
  ignore_char(string.char(65 + i)) -- ignore A-Z
  ignore_char(string.char(97 + i)) -- ignore a-z
end

local wk = require("which-key")
local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions

local process_yank = function()
  local pasted = vim.fn.getreg('+') -- I share system register (+) with vim
  pasted = vim.fn.substitute(pasted, "^ *", "", "")
  pasted = vim.fn.substitute(pasted, "\n$", "", "")
  return pasted
end
wk.register({
  ["<leader>p"] = { function()
    local m = process_yank()
    vim.cmd("normal! a" .. m)
  end, "smart paste p" },
  ["<leader>P"] = { function()
    local m = process_yank()
    vim.cmd("normal! i" .. m)
  end, "smart paste P" },
}, { mode = { "v", "n" } })
wk.register(vim.tbl_extend("force", ignored, {
  name = "edit",
  ["<cr>"] = {"a<cr><esc>k$", "insert blank line after cursor"},
  ["<C-cr>"] = {":<c-u>put =repeat(nr2char(10), v:count1)<cr>", "insert new blank lines"},
  -- splitjoin
  ["]"] = "[C] split line by syntax",
  ["["] = "[C] join line by syntax",
  p = { function()
    local m = process_yank()
    vim.cmd("normal! o" .. m)
  end, "smart paste in line down" },
  P = { function()
    local m = process_yank()
    vim.cmd("normal! O" .. m)
  end, "smart paste in line up" },
  g = { "<C-^>", "✭ go alternative buffer#" },
  G = { "<C-w>^", "split alternative buffer# " },
  d = { function()
    builtin.buffers(require("telescope.themes").get_ivy {
      prompt_title = "Buffers List",
      results_title = "|open: ^v(split) ^s(plit) ^t(ab)",
      layout_config = {
        preview_width = 0.75,
      },
      sort_lastused = true,
    })
  end, "go buffers" },
  f = { function()
    builtin.current_buffer_fuzzy_find {
      skip_empty_lines = true,
    }
  end, "✭ fuzzy search in curret buffer" }
}), { prefix = "s" })

wk.register({
  -- grep
  l = { function()
    builtin.live_grep({
      prompt_title = "Grep In Current Buffer",
      search_dirs = { vim.fn.expand('%'), },
    })
  end, "grep in current buffer" },
  L = { function() builtin.live_grep({
      prompt_title = "Grep In Buffers",
      grep_open_files = true,
    })
  end, "grep in buffers" },
  -- TODO: how to include or exclude file?
  ["<C-l>"] = { function()
    extensions.live_grep_args.live_grep_args({
      prompt_title = "Grep In Working Directory",
    })
  end, "grep in working directory" },
  ["<A-l>"] = { function()
    vim.ui.input(
      { prompt = "Enter regex pattern to grep working directory: " },
      function(input)
        builtin.grep_string({
          prompt_title = "Grep " .. input .. " In Working Directory",
          use_regex = true,
        })
      end)
  end, "regex grep in working directory" },

  -- jumplist
  j = { function()
    builtin.jumplist({
      prompt_title = "Jumplist",
      -- trim_text = true,
      -- name_width = 100,
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.4,
        width = 140,
      }
    })
  end, "go jumplist" },
}, { prefix = "s" })

local get_selected = function()
  vim.cmd('normal! "vy')
  return vim.fn.getreg('v')
end
wk.register({
  l = { function()
    local selected = get_selected()
    builtin.grep_string({
      word_match = selected,
      prompt_title = string.format([[Grep "%s" In Current Buffer]], selected),
      search_dirs = { vim.fn.expand('%'), },
    })
  end, "grep visual word in current buffer" },
  L = { function()
    local selected = get_selected()
    builtin.grep_string({
      word_match = selected,
      prompt_title = string.format([[Grep "%s" In Buffers]], selected),
      grep_open_files = true,
    })
  end, "grep visual word in buffers" },
}, { prefix = "s", mode = "v" })
