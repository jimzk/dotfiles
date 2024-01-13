return {
  -- Code snippet runner / REPL.
  "michaelb/sniprun",
  build = "bash install.sh",
  keys = {
    { "<leader>cR", ":SnipRun<cr>", mode = { "v" }, desc = "Run Selected Line (Sniprun)" },
    { "<leader>cR", ":SnipRun<cr>", mode = { "n" }, desc = "Run Current Line (Sniprun)" },
    -- { "<leader>c<bs>", ":SnipClose<cr>", mode = { "n" }, desc = "Clear Code Runner Result (Sniprun)" },
  },
  opts = {
    interpreter_options = {
      Rust_original = {
        compiler = "rustc",
      },
    },
  },
}
