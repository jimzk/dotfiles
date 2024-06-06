-- Indicate where the cursor is
return {
  "edluffy/specs.nvim",
  enabled = false,
  event = "BufReadPost",
  keys = {
    {
      "<leader>.",
      function()
        require("specs").show_specs()
      end,
      desc = "Where Am I?",
    },
  },
  config = function()
    require("specs").setup({
      show_jumps = false,
      min_jump = 30,
      popup = {
        delay_ms = 0, -- delay before popup displays
        inc_ms = 15, -- time increments used for fade/resize effects
        blend = 100, -- starting blend, between 0-100 (fully transparent), see :h winblend
        width = 20,
        winhl = "Cursor",
        fader = require("specs").linear_fader,
        resizer = require("specs").shrink_resizer,
      },
      ignore_filetypes = {},
      ignore_buftypes = {
        nofile = false,
      },
    })

    local not_allowed_fts = { "Navbuddy" }
    vim.api.nvim_create_autocmd({
      "FocusGained",
      "WinEnter",
      -- "BufEnter",
      -- "BufWinEnter",
      "WinNew",
      "InsertLeave",
    }, {
      callback = function(opts)
        local bufnr = opts.buf
        local ft = vim.bo[bufnr].filetype
        if vim.tbl_contains(not_allowed_fts, ft) then
          return
        end
        require("specs").show_specs()
      end,
    })
  end,
}
