return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        local height = vim.o.lines * 0.2
        return height >= 20 and height or 20
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    float_opts = {
      width = math.floor(0.9 * vim.o.columns),
      height = math.floor(0.9 * vim.o.lines),
      winblend = 10, -- transparent
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    local new_zellij = function()
      local session_name = require("possession.session").get_session_name()
      local cmd = session_name and "zellij attach -c " .. session_name or "zellij"
      local zellij = require("toggleterm.terminal").Terminal:new({
        cmd = cmd,
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "none",
        },
      })
      return zellij
    end
    local map = Util.map
    map({ "n", "t" }, "<C-\\>", function()
      _G.zellij = zellij or new_zellij()
      _G.zellij:toggle(nil, "float")
    end, "Terminal")
    map({ "n", "t" }, "<C-M-\\>", function()
      _G.zellij = zellij or new_zellij()
      _G.zellij:toggle(nil, "horizontal")
    end, "Terminal")
  end,
}
