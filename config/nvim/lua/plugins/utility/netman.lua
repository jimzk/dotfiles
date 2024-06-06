-- Alternative:
-- - https://github.com/amitds1997/remote-nvim.nvim
--   - https://www.reddit.com/r/neovim/comments/1cxr5hm/remotenvimnvim_now_supports_dev_containers
-- - https://github.com/jamestthompson3/nvim-remote-containers
return {
  -- Remote edit file from ssh/sftp/ftp/Docker...
  -- Usage:
  -- * :edit username@1.2.3.4:8080///home/foo/bar.sh
  -- * <CMD>Neotree remote<CR> opens remote file explorer
  --
  -- Ref: https://www.reddit.com/r/neovim/comments/1acrgn3/comment/kjwm29a
  "miversen33/netman.nvim",
  keys = {
    { "<leader>fm", "<CMD>Neotree remote<CR>", desc = "Remote File NeoTree" },
  },
  -- enabled = false,
  config = function()
    require("netman").setup()
    -- require("neo-tree").setup({
    --   sources = {
    --     "filesystem", -- Neotree filesystem source
    --     "netman.ui.neo-tree", -- The one you really care about 😉
    --   },
    -- })
  end,
}
