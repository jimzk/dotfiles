return {
  -- Startup screen
  "goolord/alpha-nvim",
  event = "VimEnter",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
      ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
      ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
      ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
      ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
      ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

    dashboard.section.header.val = vim.split(logo, "\n")
    dashboard.section.buttons.val = {
      -- dashboard.button("f", " " .. " Find Files",
      --   [[<cmd>lua Util.telescope("find_files", { prompt_title = "Find Files (cwd)", })() <CR>]]),
      dashboard.button("f", " " .. " Find Files", [[<cmd>Telescope frecency workspace=CWD<CR>]]),
      dashboard.button("e", " " .. " New Files", ":ene <BAR> startinsert <CR>"),
      -- dashboard.button("o", " " .. " Recent Files", ":Telescope frecency <CR>"),
      dashboard.button("g", " " .. " Search Text", ":Telescope live_grep <CR>"),
      dashboard.button("c", " " .. " Nvim Config", [[<cmd>PossessionLoad config<CR>]]),
      dashboard.button("z", "󰒲 " .. " Lazy", ":Lazy<CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),

      -- Session list
      -- Guide from https://github.com/jedrzejboczar/possession.nvim#startup-screen increases startuptime heavily. I rewrite by reading session files directly.
      (function()
        local group = { type = "group", opts = { spacing = 0 } }
        group.val = {
          {
            type = "text",
            val = "Sessions",
            opts = {
              position = "center"
            }
          }
        }
        local path = vim.fn.stdpath("data") .. "/possession"
        local files = vim.split(vim.fn.glob(path .. "/*.json"), "\n")
        local i = 1
        for _, file in pairs(files) do
          local basename = vim.fs.basename(file):gsub("%.json", "")
          if basename ~= "config" then
            local button = dashboard.button(tostring(i), " " .. basename, "<cmd>PossessionLoad " .. basename .. "<cr>")
            table.insert(group.val, button)
            i = i + 1
          end
        end
        return group
      end)()
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.footer.opts.hl = "Type"
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.opts.layout[1].val = 8
    return dashboard
  end,
  config = function(_, dashboard)
    vim.b.miniindentscope_disable = true

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
