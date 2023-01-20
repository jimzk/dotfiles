-- better diagnostics list and others
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "Trouble" },
      callback = function()
        local trouble_opt = { skip_groups = true, jump = false }
        local opts = { noremap = true, buffer = true, silent = true }
        map("n", "j", function()
          require("trouble").next(trouble_opt)
        end, opts)
        map("n", "k", function()
          require("trouble").previous(trouble_opt)
        end, opts)
        map("n", "J", "j", opts)
        map("n", "K", "k", opts)
        -- map("n", "H", function() trouble.first(trouble_opt); end, opts)
        -- map("n", "L", function() trouble.last(trouble_opt); end, opts)
      end,
    })
  end,
  opts = {
    group = true,
    position = "bottom",
    height = 15,
    padding = false,
    auto_jump = { "lsp_definitions", "lsp_type_definitions", "lsp_implementations" },
    auto_preview = true,
    action_keys = {
      open_split = "s",
      open_vsplit = "v",
      toggle_preview = "p",
      preview = "l",
      help = "?",
      jump = "<cr>",
    },
    use_diagnostic_signs = true,
  },
}
