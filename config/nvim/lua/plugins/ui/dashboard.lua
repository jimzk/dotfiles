-- Override: https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/plugins/ui.lua#L351
local load_session = function()
  require("telescope").extensions.possession.list(require("telescope.themes").get_dropdown({
    layout_config = { mirror = true },
  }))
end

local frecency = function()
  require("telescope").extensions.frecency.frecency({
    workspace = "CWD",
  })
end

local smart_open = function()
  require("telescope").extensions.smart_open.smart_open({
    prompt_title = "Smart Open",
    cwd_only = true,
    filename_first = true,
  })
end

return {
  "nvimdev/dashboard-nvim",
  dependencies = {
    {
      "rubiin/fortune.nvim",
      version = "*",
      opts = {
        max_width = 47,
        content_type = "tips",
      },
    },
  },
  opts = function(_, opts)
    -- stylua: ignore
    opts.config.center = {
      { action = load_session,                desc = " Session",         icon = " ", key = "p" },
      -- { action = "Telescope find_files",      desc = " Find File",       icon = " ", key = "f" },
      -- { action = frecency,                    desc = " Find File",       icon = " ", key = "f" },
      { action = smart_open,                  desc = " Find File",       icon = " ", key = "f" },
      -- { action = "Telescope oldfiles",        desc = " Old File",        icon = " ", key = "o" },
      { action = "ene | startinsert",         desc = " New File",        icon = " ", key = "n" },
      -- { action = "Telescope live_grep",       desc = " Find text",       icon = " ", key = "g" },
      { action = "Telescope live_grep_args",  desc = " Search Text",     icon = " ", key = "s" },
      { action = "Telescope project",         desc = " Git Project",     icon = " ", key = "g" },
      { action = "PossessionLoad config",     desc = " Config",          icon = " ", key = "c" },
      { action = "Lazy",                      desc = " Lazy",            icon = "󰒲 ", key = "z" },
      { action = "qa",                        desc = " Quit",            icon = " ", key = "q" },
    }
    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end
    opts.config.footer = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      local footer = { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
      local tips = require("fortune").get_fortune()
      footer = vim.list_extend(footer, { "" })
      footer = vim.list_extend(footer, tips)
      return footer
    end
  end,
}
