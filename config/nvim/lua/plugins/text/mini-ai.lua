-- Override:
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/coding.lua#L187
return {
  "echasnovski/mini.ai",
  event = "BufReadPost",
  opts = function()
    local gen_spec = require("mini.ai").gen_spec
    local ai = require("mini.ai")
    return {
      -- search_method = "cover", -- No find next
      n_lines = 500,
      mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
        -- Keep it consistent with normal ] and [ move
        goto_left = "",
        goto_right = "",
      },
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        x = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        A = gen_spec.function_call({ name_pattern = "[%w_:%.]" }),
        k = { { "%b<>" }, "^.().*().$" },
      },
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup(opts)
    -- register all text objects with which-key
    require("lazyvim.util").on_load("which-key.nvim", function()
      local i = {
        [" "] = "Whitespace",
        -- ['"'] = '"..."',
        -- ["'"] = "'...'",
        -- ["`"] = "`...`",
        -- ["("] = "(...)",
        -- [")"] = "(...) with Whitespace",
        -- [">"] = "<...> with Whitespace",
        -- ["<lt>"] = "<...>",
        -- ["]"] = "[...] with Whitespace",
        -- ["["] = "[...]",
        -- ["}"] = "{...} with Whitespace",
        -- ["{"] = "{...}",
        -- _ = "_..._",

        a = "Argument",
        b = "(...), [...], {...}",
        B = "{...}",
        k = "<...>",
        x = "Class Body",
        f = "Function Body",
        A = "All Arguments",
        o = "Block, Condition, Loop",
        q = "`...`, \"...\" '...'",
        t = "Tag",
        p = "Paragrao",
        ["?"] = "User Prompt",
      }
      for _, v in ipairs({ '"', "'", "`", "(", ")", ">", "<lt>", "[", "]", ",", "}", "{", "w", "W" }) do
        i[v] = "which_key_ignore"
      end
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(" with.*", "")
      end
      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs({ n = "next", l = "last" }) do
        i[key] = vim.tbl_extend("error", { name = name .. " Textobject" }, ic)
        a[key] = vim.tbl_extend("error", { name = name .. " Textobject" }, ac)
      end
      require("which-key").register({
        mode = { "o", "x" },
        i = i,
        a = a,
      })
    end)

    -- ]a and [a move to start at parameter. Defaults stay at end.
    local next_para_repeat, prev_para_repeat = require("util").make_repeatable_move_pair(function()
      require("mini.ai").move_cursor("right", "i", "a", { search_method = "next" })
    end, function()
      require("mini.ai").move_cursor("left", "i", "a", { search_method = "prev" })
    end)
    local map = require("util").map
    map({ "n", "x", "o" }, "]a", next_para_repeat, "Next Parameter")
    map({ "n", "x", "o" }, "[a", prev_para_repeat, "Prev Parameter")
  end,
}
