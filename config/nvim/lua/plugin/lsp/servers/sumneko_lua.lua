local M = {}
local sumneko_lua = {
  -- https://github.com/sumneko/lua-language-server/blob/master/locale/en-us/setting.lua
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT'
      },
      diagnostics = {
        -- Get the language server to recognize the global `vim`
        globals = { 'vim', 'hs' }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.tbl_extend("force",
          vim.api.nvim_get_runtime_file("", true), {
          ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
        })
        ,
        checkThirdParty = false
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false
      },
      completion = {
        callSnippet = "Replace" -- Complete with arguments
      }
    }
  }
}

M.create_config = function(config)
  return vim.tbl_extend("force", config, sumneko_lua)
end

return M
