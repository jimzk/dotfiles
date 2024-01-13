return {
  -- Do something on treesitter node
  -- No much useful
  "CKolkey/ts-node-action",
  dependencies = { "nvim-treesitter" },
  enabled = false,
  keys = {
    -- The most commonly used: cycle boolean, case, quotes,
    {
      "t",
      function()
        require("ts-node-action").node_action()
      end,
      desc = "Node Action",
    },
  },
  -- Add customized actions. Ref: https://github.com/CKolkey/ts-node-action#builtin-actions
  -- Default lua actions: https://github.com/CKolkey/ts-node-action/blob/master/lua/ts-node-action/filetypes/lua.lua
  -- local actions = require("ts-node-action.actions")
  opts = {},
}
