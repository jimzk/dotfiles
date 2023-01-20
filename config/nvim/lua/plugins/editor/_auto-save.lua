return {
  "Pocco81/auto-save.nvim", -- Save file automatically
  event = "BufReadPost",
  opts = {
    execution_message = {
      message = function()
        return ""
      end,
    },
    trigger_events = { "InsertLeave" }, -- Event TextChanged breaks up autopair <CR>
  },
  init = function()
    map("n", "<leader>js", "<cmd>ASToggle<cr>", "toggle auto save")
  end,
}
