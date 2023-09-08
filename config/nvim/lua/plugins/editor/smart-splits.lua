return {
  -- Individual buffers for each tab
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  build = "./kitty/install-kittens.bash",
  opts = {},
  config = function(opts)
    require("smart-splits").setup(opts)
    -- resize splits
    map("n", "<C-S-h>", require("smart-splits").resize_left)
    map("n", "<C-S-j>", require("smart-splits").resize_down)
    map("n", "<C-S-k>", require("smart-splits").resize_up)
    map("n", "<C-S-l>", require("smart-splits").resize_right)
    -- moving between splits
    map("n", "<C-h>", require("smart-splits").move_cursor_left)
    map("n", "<C-j>", require("smart-splits").move_cursor_down)
    map("n", "<C-k>", require("smart-splits").move_cursor_up)
    map("n", "<C-l>", require("smart-splits").move_cursor_right)
    -- swapping buffers between windows
    map("n", "<C-M-h>", "<cmd>wincmd H<cr>")
    map("n", "<C-M-j>", "<cmd>wincmd J<cr>")
    map("n", "<C-M-k>", "<cmd>wincmd K<cr>")
    map("n", "<C-M-l>", "<cmd>wincmd L<cr>")
  end
}
