-- Preview image
-- Install dependencies
-- 1. brew install imagemagick
-- 2. brew install luarocks
-- 3. luarocks --lua-version=5.1 install magick (magick only supports lua 5.1)
-- 4. brew install lua51 (You must have lua 5.1 on your system)
return {
  "3rd/image.nvim",
  enabled = not vim.g.neovide,
  opts = {},
  config = function(_, opts)
    package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
    package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
    require("image").setup(opts)
  end,
}
