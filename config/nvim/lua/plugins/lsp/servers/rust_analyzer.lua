local snippets = {
  ["Arc::new"] = {
    postfix = "arc",
    body = "Arc::new(${receiver})",
    requires = "std::sync::Arc",
    description = "Put the expression into an `Arc`",
    scope = "expr"
  },
  -- https://github.com/rust-lang/rust-analyzer/issues/4360
  -- ["Arc"] = {
  --   postfix = "Arc",
  --   body = "Arc<${receiver}>",
  --   requires = "std::sync::Arc",
  --   description = "Wrap type by `Arc`",
  --   scope = "expr"
  -- },
  ["Rc::new"] = {
    postfix = "rc",
    body = "Rc::new(${receiver})",
    requires = "std::rc::Rc",
    description = "Put the expression into an `Rc`",
    scope = "expr"
  },
  ["Mutex::new"] = {
    postfix = "mutex",
    body = "Mutex::new(${receiver})",
    requires = "std::sync::Mutex",
    description = "Put the expression into `Mutex`",
    scope = "expr"
  },
  ["Box::pin"] = {
    postfix = "pinbox",
    body = "Box::pin(${receiver})",
    requires = "std::boxed::Box",
    description = "Put the expression into a pinned `Box`",
    scope = "expr"
  },
  ["Ok"] = {
    postfix = "ok",
    body = "Ok(${receiver})",
    description = "Wrap the expression in a `Result::Ok`",
    scope = "expr"
  },
  ["Err"] = {
    postfix = "err",
    body = "Err(${receiver})",
    description = "Wrap the expression in a `Result::Err`",
    scope = "expr"
  },
  ["Some"] = {
    postfix = "some",
    body = "Some(${receiver})",
    description = "Wrap the expression in an `Option::Some`",
    scope = "expr"
  }
}

return {
  -- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
  -- https://rust-analyzer.github.io/manual.html
  settings = {
    ["rust-analyzer"] = {
      completion = {
        postfix = {
          -- Enable postfix like `dbg`, `if`, `not`, etc.
          -- * https://rust-analyzer.github.io/manual.html#magic-completions
          -- * https://rust-analyzer.github.io/manual.html#format-string-completion
          enable = true,
        },
        callable = {
          -- Whether to add parenthesis and argument snippets when completing function.
          -- Possible value: fill_arguments (default), add_parentheses, none
          snippets = "fill_arguments",
        },
        snippets = {
          custom = snippets,
        }
      }
    }
  }
}
