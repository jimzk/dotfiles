-- Override:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua#L411
return {
  "echasnovski/mini.bufremove",
  event = "BufReadPost",
  -- enabled = true,
  keys = {
    {
      "<BS>",
      function()
        _G.remove_harpoon()
        local bd = require("mini.bufremove").delete
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then -- Yes
            vim.cmd.write()
            bd(0)
          elseif choice == 2 then -- No
            bd(0, true)
          end
        else
          bd(0)
        end
      end,
      desc = "Delete Buffer",
    },
    -- { "<leader>bd", "<BS>", desc = "Delete Buffer (<BS>)", remap = true },
    -- {
    --   "<leader>bD",
    --   function()
    --     require("mini.bufremove").delete(0, true)
    --   end,
    --   desc = "Delete Buffer Forcely",
    -- },
  },
}
