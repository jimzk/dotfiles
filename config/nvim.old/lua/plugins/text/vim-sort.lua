return {
  -- gs to sort linewise/character
  -- e.g. gs2j (two lines), gsip (paragraph), gsii (indentation)
  --      gsib (character): (b, c, a) => (a, b, c)
  "christoomey/vim-sort-motion",
  event = "BufRead",
  keys = {
    { "gs", desc = "sort linewise/character" },
  },
}
