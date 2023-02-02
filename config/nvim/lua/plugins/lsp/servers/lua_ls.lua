local get_library = function()
  local library = vim.api.nvim_get_runtime_file("", true)
  -- table.insert(library, vim.fn.expand('~/.hammerspoon/Spoons/EmmyLua.spoon/annotations/'))
  -- table.insert(library, "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs")
  return library
end

return {
  -- https://github.com/LuaLS/lua-language-server/blob/master/locale/en-us/setting.lua
  -- https://github.com/LuaLS/lua-language-server/wiki/Settings
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the global `vim`
        globals = { "vim", "hs", "spoon" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = get_library(),
        -- Do not show annoying setting message
        -- https://www.reddit.com/r/neovim/comments/10qvoky/why_am_i_keep_getting_asked_this_question_all_the/
        checkThirdParty = false,
      },
      format = {
        enable = true,
        -- https://github.com/LuaLS/lua-language-server/wiki/Formatter
        -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config.md
        defaultConfig = {
          -- The value should be STRING!
          indent_style = "space",
          indent_size = "2",
          quote_style = "double",
          local_assign_continuation_align_to_first_expression = "true",
          -- call_arg_parentheses = "remove_table_only",
          -- keep_one_space_between_table_and_bracket = true,
          -- align_table_field_to_first_field = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
      completion = {
        -- Do not complete with arguments, as we always omit arguments
        callSnippet = "Disable",
      },
      semantic = {
        enable = false, -- Disable highlight as it conflict with treesitter
      },
    },
  },
}
