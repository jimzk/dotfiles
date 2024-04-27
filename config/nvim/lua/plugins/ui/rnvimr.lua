return {
  "kevinhwang91/rnvimr",
  event = "VeryLazy",
  enabled = false,
  keys = {
    { "<C-r>r", "<CMD>RnvimrToggle<CR><M-l>", desc = "Ranger" },
  },
  config = function()
    local map = Util.map
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "rnvimr",
      callback = function(options)
        local bufnr = options.buf
        local opts = { buffer = bufnr }
        -- TODO: remember the buffer before open and jump back to it after close
        map("t", "<C-r>", "<C-\\><C-n><CMD>RnvimrToggle<CR>", "Close Ranger", opts)
        map("t", "q", "<C-\\><C-n><CMD>RnvimrToggle<CR>", "Close Ranger", opts)
        map("t", "<C-o>", "<C-\\><C-n><CMD>RnvimrResize<CR>", "Change Ranger Layout", opts)

        map({ "t", "n" }, "<C-h>", "<C-h>", nil, opts)
        map({ "t", "n" }, "<C-j>", "<C-j>", nil, opts)
        map({ "t", "n" }, "<C-k>", "<C-k>", nil, opts)
        map({ "t", "n" }, "<C-l>", "<C-l>", nil, opts)
      end,
    })

    -- Replace netrw
    vim.g.rnvimr_enable_ex = 1
    -- Hidden ranger after picking a file
    vim.g.rnvimr_enable_picker = 1
    -- Hide the files included in gitignore
    -- vim.g.rnvimr_hide_gitignore = 1
    vim.g.rnvimr_layout = {
      ["relative"] = "editor",
      ["width"] = vim.fn.float2nr(vim.fn.round(0.6 * vim.o.columns)),
      ["height"] = vim.fn.float2nr(vim.fn.round(0.6 * vim.o.lines)),
      ["col"] = vim.fn.float2nr(vim.fn.round(0.2 * vim.o.columns)),
      ["row"] = vim.fn.float2nr(vim.fn.round(0.2 * vim.o.lines)),
      ["style"] = "minimal",
    }

    vim.cmd([[
    let g:rnvimr_presets = [
              \ {},
              \ {'width': 0.700, 'height': 0.700},
              \ {'width': 0.800, 'height': 0.800},
              \ {'width': 0.950, 'height': 0.950},
              \ {'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0},
              \ {'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0.5},
              \ {'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0},
              \ {'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0.5},
              \ {'width': 0.500, 'height': 1.000, 'col': 0, 'row': 0},
              \ {'width': 0.500, 'height': 1.000, 'col': 0.5, 'row': 0},
              \ {'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0},
              \ {'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0.5}
              \ ]
    ]])

    -- https://github.com/ranger/ranger/wiki/Official-user-guide#key-bindings-and-hints-
    vim.g.rnvimr_action = {
      -- BUG: in macOS <C-v> work only when pressing twice
      -- https://github.com/kevinhwang91/rnvimr/issues/122
      -- ["<Esc>"] = "quit",
      ["<C-q>"] = "quit",
      ["t"] = "NvimEdit tabedit",
      ["s"] = "NvimEdit split",
      ["v"] = "NvimEdit vsplit",
    }
    vim.cmd("RnvimrStartBackground")
  end,
}
