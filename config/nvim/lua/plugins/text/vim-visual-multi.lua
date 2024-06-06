return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    -- :h vim-visual-multi
    -- :h vm-faq-custom-mappings
    -- :h vm-faq-mappings
    -- :h vm-mappings-all
    vim.g.VM_maps = {
      ["Add Cursor Down"] = "<M-Down>",
      ["Add Cursor Up"] = "<M-Up>",
      ["Find Under"] = "<C-g>",
      ["Find Subword Under"] = "<C-g>",
      ["Select All"] = "<C-M-g>",
      ["Visual All"] = "<C-M-g>",
      ["Mouse Cursor"] = "<M-LeftMouse>",
      ["Mouse Word"] = "<M-RightMouse>",
      -- ["Mouse Column"] = "<M-LeftMouse>",
      -- ["VM Select h"] = "<S-left>",
      -- ["VM Select l"] = "<S-right>",
    }

    -- hslens mess up highlighting
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_start",
      callback = function(args)
        vim.cmd([[HlSearchLensDisable]])
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_exit",
      callback = function(args)
        vim.cmd([[HlSearchLensEnable]])
      end,
    })

    -- Help: :h vm-highlight
    -- vim.g.VM_theme = "neon"
    vim.defer_fn(function()
      vim.cmd([[
        hi! link VM_Mono CurSearch
        hi! link VM_Extend CurSearch
        hi! link VM_Cursor CurSearch
        hi! VM_Insert guibg=#F977C2 guifg=#111111  " Same as my cursor
      ]])
    end, 1000)
  end,
}
