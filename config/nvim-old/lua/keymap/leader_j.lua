local wk = require("which-key")
local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions
local opt = { mode = "n", prefix = "<leader>j", noremap = true, silent = true }
wk.register({
  name = "jump in file",
  -- j = { function()
  --   builtin.current_buffer_fuzzy_find {
  --     skip_empty_lines = true,
  --   }
  -- end, "✭ fuzzy search in curret buffer" },
  -- jumplist
  p = { function()
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
  -- search & grep
  J = { function()
    builtin.live_grep({
      prompt_title = "[Regex] Search Current Buffer",
      search_dirs = { vim.fn.expand('%:p'), },
    })
  end, "REGEX search current buffer (support visual)" },
  j = { function()
    builtin.live_grep({
      prompt_title = "[Regex] Search in CWD",
      search_dirs = { vim.fn.getcwd() },
      -- glob_pattern = {
      --   [[*.lua]]
      -- },
    })
  end, "REGEX search in CWD" },
  ["<C-j>"] = { function()
    vim.ui.input(
      { prompt = "Enter regex pattern to search working directory: " },
      function(input)
        if not input then
          return
        end
        builtin.grep_string({
          prompt_title = "Search " .. input .. " In Working Directory",
          use_regex = true,
        })
      end)
  end, "regex search in working directory" },
}, opt)

local get_selected = function()
  if vim.fn.mode() == "n" then
    vim.cmd('normal! "vyiw')
  else
    vim.cmd('normal! "vy')
  end
  return vim.fn.getreg('v')
end
wk.register({
  ["<C-*>"] = { function()
    local selected = get_selected()
    builtin.grep_string({
      word_match = selected,
      prompt_title = string.format([[Search "%s" In Current Buffer]], selected),
      search_dirs = { vim.fn.expand('%'), },
    })
  end, "telescope *", mode = { "n", "v" } },
})
wk.register({
  j = { function()
    local selected = get_selected()
    builtin.grep_string({
      word_match = selected,
      prompt_title = string.format([[Search "%s" In Current Buffer]], selected),
      search_dirs = { vim.fn.expand('%'), },
    })
  end, "search visual word in current buffer", mode = "v" },
  J = { function()
    local selected = get_selected()
    builtin.grep_string({
      word_match = selected,
      prompt_title = string.format([[Search "%s" In CWD]], selected),
      search_dirs = { vim.fn.getcwd(), }
    })
  end, "search visual word in cwd", mode = "v" },
}, opt)

wk.register({
  -- t = { "<cmd>Telescope marks<cr>", "telescope marks" },
  -- m = { "<cmd>MarksListBuf<cr>", "list LOCAL marks in current buffer" },
  -- M = { "<cmd>MarksListGlobal<cr>", "list GLOBAL marks in all buffers" },
  -- d = { "<cmd>h '[<cr>", "meaning of special mark" },
  D = { -- marks.nvim
    name = "marks.nvim commands",
    ["0"] = { "m, set random mark" },
    ["1"] = { "m1 set mark 1" },
    ["2"] = { "ma set mark a" },
    ["3"] = { "mA set mark A (across buffers)" },
    ["4"] = { "m;a preview mark a" },
    ["5"] = { "m[ move to next mark (m] opposite)" },
    ["6"] = { "m- delete current mark" },
    ["a"] = { "dma delete mark a" },
    ["b"] = { "dm- delete all marks" },
  },
}, opt)
