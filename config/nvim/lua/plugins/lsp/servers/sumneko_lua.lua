local get_library = function()
  local library = vim.api.nvim_get_runtime_file("", true)
  -- table.insert(library, vim.fn.expand('~/.hammerspoon/Spoons/EmmyLua.spoon/annotations/'))
  -- table.insert(library, "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs")
  return library
end

return {
  -- https://github.com/sumneko/lua-language-server/blob/master/locale/en-us/setting.lua
  -- https://github.com/sumneko/lua-language-server/wiki/Settings
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the global `vim`
        globals = { "vim", "hs" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = get_library(),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
      completion = {
        callSnippet = "Disable", -- Do not complete with arguments. Consistent with ray-x/lsp_signature.nvim
      },
      semantic = {
        enable = false, -- Disable highlight as it conflict with treesitter
      },
    },
  },
}
