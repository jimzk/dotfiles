# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

# Tips and Tricks

- https://www.reddit.com/r/neovim/comments/17uwnoe/comment/k99dozh
- https://www.reddit.com/r/neovim/comments/1abd2cq/what_are_your_favorite_tricks_using_neovim
- https://www.reddit.com/r/neovim/comments/1af1r03/what_was_that_one_keybinding_that_you_somehow
  - `<C-t>`/`<C-d>` indent/deindent in insert mode.
  - `g;` goes to the last edit you made.
  - `gi` goes to the last insert position.
  - `<C-w>o` closes other windows.
  - `:%norm abc` runs command `abc` on every line.
    - `:%g/regex/norm abc` runs `abc` on all lines that match `/regex/`.
    - `:%v/regex/norm abc` runs `abc` on all lines that *don't* match `/regex/`.
    - `:'<,'>v/regex/d` deletes all lines within the visual select that don't contain `/regex/`.

Development Tips
- https://www.reddit.com/r/neovim/comments/1agnej6/comment/kojvwjq
- https://www.reddit.com/r/neovim/comments/1agnej6/introducing_yodawgnvim/
- https://github.com/lewis6991/nvim-test
