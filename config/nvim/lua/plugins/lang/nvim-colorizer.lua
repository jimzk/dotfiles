return {
  "norcalli/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require 'colorizer'.setup {
      ['*'] = {
        mode = 'foreground';
      }
    }
  end
}
