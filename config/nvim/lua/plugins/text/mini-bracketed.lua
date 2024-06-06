local map = Util.map
local M = {
  -- add more [ and ] navigations
  "echasnovski/mini.bracketed",
  event = "VeryLazy",
}

M.opts = {
  buffer = { suffix = "", options = {} },
  comment = { suffix = "", options = {} },
  conflict = { suffix = "", options = {} },
  diagnostic = { suffix = "", options = {} },
  file = { suffix = "", options = {} },
  indent = { suffix = "", options = {} },
  jump = { suffix = "", options = {} },
  location = { suffix = "", options = {} },
  oldfile = { suffix = "", options = {} },
  quickfix = { suffix = "", options = {} },
  treesitter = { suffix = "", options = {} },
  undo = { suffix = "", options = {} },
  window = { suffix = "", options = {} },
  yank = { suffix = "", options = {} },
}

local move = function(target, direction, opts)
  opts = opts or {}
  return function()
    vim.cmd([[normal! m`]])
    MiniBracketed[target](direction, opts)
    if opts.post_hook then
      opts.post_hook()
    end
  end
end

local map_move_internal = function(mode, keys, next_fn, prev_fn, desc, disable_repeat)
  local next_fn_proxy, prev_fn_proxy
  local zz_keys = vim.api.nvim_replace_termcodes("zz", true, false, true)
  local next_fn_zz = function()
    next_fn()
    vim.api.nvim_feedkeys(zz_keys, "m", true)
  end
  local prev_fn_zz = function()
    prev_fn()
    vim.api.nvim_feedkeys(zz_keys, "m", true)
  end
  if disable_repeat then
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    next_fn_proxy = function()
      next_fn_zz()
      ts_repeat_move.clear_last_move()
    end
    prev_fn_proxy = function()
      prev_fn_zz()
      ts_repeat_move.clear_last_move()
    end
  else
    next_fn_proxy, prev_fn_proxy = Util.make_repeatable_move_pair(next_fn_zz, prev_fn_zz)
  end
  if type(keys) == "string" then
    keys = { "]" .. keys, "[" .. keys }
  end

  map(mode, keys[1], next_fn_proxy, "Next " .. desc)
  map(mode, keys[2], prev_fn_proxy, "Prev " .. desc)
end

local map_move = function(mode, key, target, desc, opts, disable_repeat)
  local next_fn = move(target, "forward", opts)
  local prev_fn = move(target, "backward", opts)
  desc = desc or target:sub(1, 1):upper() .. target:sub(2)
  return map_move_internal(mode, key, next_fn, prev_fn, desc, disable_repeat)
end

M.config = function(_, opts)
  require("mini.bracketed").setup(opts)
  vim.defer_fn(function()
    -- Comment (exclusive comment in operation mode)
    -- map_move({ "o" }, "\\", "comment", { wrap = true })
    map_move({ "n", "x", "o" }, "\\", "comment")
    map_move({ "n", "x", "o" }, "x", "conflict")
    -- map_move({ "n", "x", "o" }, "\\", "treesitter")
    -- map_move({ "n" }, "j", "jump", "jumplist in Buffer")
    map_move({ "n" }, { "]f", "[f" }, "file", nil, {
      post_hook = function()
        if Util.is_neo_tree_shown() then
          vim.cmd("Neotree reveal action=show")
        end
      end,
    })

    -- map("n", "<m-h>", "<Cmd>lua MiniBracketed.jump('backward')<CR>", "Prev jumplist in Buffer")
    -- map("n", "<m-l>", "<Cmd>lua MiniBracketed.jump('forward')<CR>", "Next jumplist in Buffer")
  end, 500)
end

return M
