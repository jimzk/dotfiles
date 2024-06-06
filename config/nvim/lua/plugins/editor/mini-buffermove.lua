-- Override:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua#L411
return {
  "echasnovski/mini.bufremove",
  event = "BufReadPost",
  keys = function()
    return {
      {
        "q",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local current_winnr = vim.api.nvim_get_current_win()

          local win_floated = vim.api.nvim_win_get_config(current_winnr).relative ~= ""
          local buflisted = vim.bo[bufnr].buflisted
          local is_normal_file = vim.bo.bufhidden == ""
          if win_floated or not buflisted or not is_normal_file then
            vim.cmd([[close]])
            return
          end

          local windows = vim.api.nvim_list_wins()
          for _, winnr in pairs(windows) do
            if winnr ~= current_winnr and vim.api.nvim_win_get_buf(winnr) == bufnr then
              vim.notify("Buffer in other window. Can't delete.", vim.log.levels.WARN, { title = "Buffer" })
              return
            end
          end
          -- vim.cmd("BufferLineCyclePrev")
          vim.cmd("BufferPrevious")
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(bufnr)
            elseif choice == 2 then -- No
              bd(bufnr, true)
            end
          else
            bd(bufnr)
          end
          Util.update_tabline()
        end,
        desc = "Delete Buffer",
      },
      { "<BS>", "q", remap = true, desc = "Delete Buffer" },
      {
        "<C-BS>",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          vim.cmd("BufferPrevious")
          require("mini.bufremove").delete(bufnr, true)
          Util.update_tabline()
        end,
        desc = "Delete Buffer (Force)",
      },
    }
  end,
}
