local M = {}

local Flash = require("flash")

local two_char_jump_fn = function(action)
  ---@param opts Flash.Format
  local function format(opts)
    -- always show first and second label
    return {
      { opts.match.label1, "FlashMatch" },
      { opts.match.label2, "FlashLabel" },
    }
  end

  local default_search = {
    multi_window = true,
    exclude = {
      "neo-tree",
      "aerial",
    },
  }

  return function()
    Flash.jump({
      search = vim.tbl_extend("force", default_search, { mode = "search" }),
      label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
      pattern = [[\<]],
      action = function(match, state)
        state:hide()
        Flash.jump({
          search = vim.tbl_extend("force", default_search, { mode = "search", max_length = 0 }),
          highlight = { matches = false },
          label = { after = false, before = { 0, 0 }, format = format },
          matcher = function(win)
            -- limit matches to the current label
            return vim.tbl_filter(function(m)
              return m.label == match.label and m.win == win
            end, state.results)
          end,
          labeler = function(matches)
            for _, m in ipairs(matches) do
              m.label = m.label2 -- use the second label
            end
          end,
          action = action,
        })
      end,
      labeler = function(matches, state)
        local labels = state:labels()
        for m, match in ipairs(matches) do
          match.label1 = labels[math.floor((m - 1) / #labels) + 1]
          match.label2 = labels[(m - 1) % #labels + 1]
          match.label = match.label1
        end
      end,
    })
  end
end

M.two_char_jump = two_char_jump_fn()

M.peek_definition = function()
  Flash.jump({
    action = function(match, state)
      -- vim.api.nvim_win_call(match.win, function()
      vim.cmd([[normal! m`]])
      vim.api.nvim_set_current_win(match.win)
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      require("goto-preview").goto_preview_definition({})
      _G.geto_preview_recover = function()
        state:restore()
      end
      -- vim.lsp.buf.definition()
      -- vim.cmd([[Trouble lsp_definitions]])
    end,
  })
end

-- Examples:
-- - Jump to { ( [: search_jump("[{([]")
-- - Jump to } ) ]: search_jump("[})\\]]")
M.search_jump = function(pattern)
  return function()
    Flash.jump({
      search = { max_length = 0, mode = "search" },
      pattern = pattern,
      highlight = {
        groups = {
          current = "FlashLabel",
        },
      },
    })
  end
end

M.peek_diagnostics = function(opts)
  local default_opts = {
    matcher = function(win)
      ---@param diag Diagnostic
      return vim.tbl_map(function(diag)
        return {
          pos = { diag.lnum + 1, diag.col },
          end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
        }
      end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
    end,
    action = function(match, state)
      vim.api.nvim_win_call(match.win, function()
        vim.api.nvim_win_set_cursor(match.win, match.pos)
        vim.diagnostic.open_float()
      end)
      state:restore()
    end,
  }
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  Flash.jump(opts)
end

-- A enhanced treesitter_search
-- Search -> Tresitter in the all matched pos
-- References:
-- * https://github.com/folke/flash.nvim/pull/51#issuecomment-1607124051
-- * https://github.com/folke/flash.nvim/discussions/38
M.treesitter_remote = function(opts)
  local Treesitter = require("flash.plugins.treesitter")
  local Search = require("flash.search")
  local default_opts = {
    search = { incremental = false },
    matcher = function(win, state, matcher_opts)
      local search = Search.new(win, state)
      local matches = {} ---@type Flash.Match[]
      for _, m in ipairs(search:get(matcher_opts)) do
        -- don't add labels to the search results
        m.label = false
        table.insert(matches, m)
        -- Fix warn "No treesitter parser for this buffer with filetype=neo-tree"
        local buf = vim.api.nvim_win_get_buf(win)
        local ok, _ = pcall(vim.treesitter.get_parser, buf)
        if ok then
          for _, n in ipairs(Treesitter.get_nodes(win, m.pos)) do
            -- don't highlight treesitter nodes. Use labels only
            n.highlight = false
            table.insert(matches, n)
          end
        end
      end
      return matches
    end,
    jump = { pos = "range" },
    label = {
      before = true,
      after = true,
      style = "inline",
    },
    remote_op = { restore = true, motion = true },
  }
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  Flash.jump(opts)
end

-- Search -> Jump -> Tresitter in the pos
-- FIX: has issue with wrong range and can't operate across windows
-- References:
-- * https://github.com/folke/flash.nvim/discussions/24
M._remote_treesitter = function(opts)
  local default_opts = {
    action = function(match, state)
      -- state:hide()
      -- vim.api.nvim_win_call(match.win, function()
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      Flash.treesitter()
      -- end)
      state:restore()
    end,
  }
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  Flash.jump(opts)
end

-- More snippets
-- * Jump to references: https://github.com/folke/flash.nvim/discussions/13

return M
