return {
  -- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
  -- https://rust-analyzer.github.io/manual.html
  settings = {
    ["rust-analyzer"] = {
      completion = {
        postfix = {
          enable = true,
        },
        callable = {
          -- Do not complete with arguments. Consistent with ray-x/lsp_signature.nvim
          snippets = "add_parentheses",
        }
      }
    }
  }
}
