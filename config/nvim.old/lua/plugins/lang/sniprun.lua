return {
  -- Code snippet runner
  "michaelb/sniprun",
  build = "bash install.sh",
  keys = {
    { "<leader>c<cr>", ":SnipRun<cr>", mode = { "n", "v" }, desc = "run selected line (SnipRun)" },
    { "<leader>c<cr>", ":SnipRun<cr>", mode = { "n" }, desc = "run current line (SnipRun)" },
    { "<leader>c<bs>", ":SnipClose<cr>", mode = { "n" }, desc = "clear code runner result (SnipRun)" },
  },
  opts = {
    interpreter_options = {
      Rust_original = {
        compiler = "rustc",
      },
    },
  },
}
