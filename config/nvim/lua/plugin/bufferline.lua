vim.o.mousemoveevent = true
require("bufferline").setup{
  options = {
    -- default mode is 'buffer' which also opens buffer as tab
    mode = "tabs",
    separator_style = "thin",  -- value: slant, padded_slant, thick, thin
    -- https://github.com/akinsho/bufferline.nvim#hover-events
    -- hover = {
    --     enabled = true,
    --     delay = 200,
    --     reveal = {'close'}
    -- },

    -- show diagnostic in tab name
    -- diagnostics = "nvim_lsp",
    -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
    --   local s = " "
    --   for e, n in pairs(diagnostics_dict) do
    --   local sym = e == "error" and " "
    --       or (e == "warning" and " " or "" )
    --   s = s .. n .. sym
    --   end
    --   return s
    -- end,
  },
}
