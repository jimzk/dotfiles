local wk = require("which-key")
local opt = { mode = "n", prefix = ",", noremap = true, silent = true }
wk.register({
  w = { "camelCase w", mode = { "n", "v", "o" } },
  b = { "camelCase b", mode = { "n", "v", "o" } },
  e = { "camelCase e", mode = { "n", "v", "o" } },
  ["ge"] = { "camelCase ge", mode = { "n", "v", "o" } },
  ["<cr>"] = { function()
    vim.lsp.buf.format { async = false }
    vim.cmd [[w]] -- Save after format
  end, "format file (by lsp)", mode = { "n", "v" } },
}, opt)

-- Hop
wk.register({
  [","] = { "<cmd>HopWordAC<cr>", "[M] hop to next word" },
  ["."] = { "<cmd>HopWordBC<cr>", "[M] hop to prev word" },
  f = { "<cmd>HopChar1AC<cr>", "[M] hop to next char" },
  F = { "<cmd>HopChar1BC<cr>", "[M] hop to prev char" },
  l = { "<cmd>HopLineStart<cr>", "[M] hop to line" },
  ["<C-,>"] = { "<cmd>HopWordMW<cr>", "[M] hop to word cross window" },
  ["<C-f>"] = { "<cmd>HopChar1MW<cr>", "[M] hop to char cross window" },
  ["<C-l>"] = { "<cmd>HopLineStartMW<cr>", "[M] hop to char cross window" },
}, opt)

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

local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions
wk.register({
  f = { function()
    builtin.current_buffer_fuzzy_find {
      skip_empty_lines = true,
    }
  end, "✭ fuzzy search in curret buffer" },
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
  -- grep
  g = { function()
    builtin.live_grep({
      prompt_title = "Grep In Current Buffer",
      search_dirs = { vim.fn.expand('%'), },
    })
  end, "grep in current buffer (support visual)" },
  G = { function() builtin.live_grep({
      prompt_title = "Grep In Buffers",
      grep_open_files = true,
    })
  end, "grep in buffers (support visual)" },
  -- TODO: how to include or exclude file?
  ["<C-g>"] = { function()
    extensions.live_grep_args.live_grep_args({
      prompt_title = "Grep In Working Directory",
    })
  end, "grep in working directory" },
  ["<A-g>"] = { function()
    vim.ui.input(
      { prompt = "Enter regex pattern to grep working directory: " },
      function(input)
        builtin.grep_string({
          prompt_title = "Grep " .. input .. " In Working Directory",
          use_regex = true,
        })
      end)
  end, "regex grep in working directory" },
}, opt)

local get_selected = function()
  vim.cmd('normal! "vy')
  return vim.fn.getreg('v')
end
wk.register({
  g = { function()
    local selected = get_selected()
    builtin.grep_string({
      word_match = selected,
      prompt_title = string.format([[Grep "%s" In Current Buffer]], selected),
      search_dirs = { vim.fn.expand('%'), },
    })
  end, "grep visual word in current buffer", mode = "v" },
  G = { function()
    local selected = get_selected()
    builtin.grep_string({
      word_match = selected,
      prompt_title = string.format([[Grep "%s" In Buffers]], selected),
      grep_open_files = true,
    })
  end, "grep visual word in buffers", mode ="v" },
}, opt)
