return {
  -- Code snippet runner
  "michaelb/sniprun",
  build = "bash install.sh",
  keys = {
    { "<leader>c<cr>", ":SnipRun<cr>", mode = { "n", "v" }, desc = "code runner" },
    { "<leader>c<bs>", ":SnipClose<cr>", mode = { "n" }, desc = "clear code runner result" },
  },
  opts = {
    interpreter_options = {
      Rust_original = {
        compiler = "rustc",
      },
    },
  },
}
