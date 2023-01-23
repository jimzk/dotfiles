return {
  -- Do something on treesitter node
  "CKolkey/ts-node-action",
  dependencies = { "nvim-treesitter" },
  keys = {
    -- The most commonly used: cycle boolean, case, quotes,
    { "K", function() require("ts-node-action").node_action() end, desc = "ts node action" },
  },
  opts = function()
    -- Add customized actions. Ref: https://github.com/CKolkey/ts-node-action#builtin-actions
    -- Default lua actions: https://github.com/CKolkey/ts-node-action/blob/master/lua/ts-node-action/filetypes/lua.lua
    -- local actions = require("ts-node-action.actions")
    return {}
  end,
}
