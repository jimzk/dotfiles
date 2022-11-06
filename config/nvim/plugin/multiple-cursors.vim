" https://github.com/terryma/vim-multiple-cursors

" Usage:
"   <C-n>:  add multicursor on next match
"   <C-x>:  skip next match
"   <C-p>:  remove multicursor on current match
"   <A-n>:  add multicursor on all match

lua << EOF
require("which-key").register({
  ["<C-n>"] = {"multi select next word"},
})
EOF
