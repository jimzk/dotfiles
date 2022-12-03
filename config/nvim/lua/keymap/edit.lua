require("which-key").register({
  d = {
    name = "delete",
    s = {
      name = "surrounding",
      ['"'] = [[delete ""]],
      ['('] = "delete () and remove inner spaces",
      [')'] = "delete ()",
    }
  },
  c = {
    name = "change",
    l = "detele current char",
    x = {
      name = "[M] exchange text",
      x = "exchange line",
      c = "clear exchange",
    },
    s = {
      name = "[M] replace surroundings",
      ['"'] = [[cs"' replaces "" with '']],
      ['('] = "cs([ replace () with [] ",
      [')'] = "cs)[ replace () with [] and remove inner spaces",
    },
    S = [[cS"' replaces "" with '' and new line]],
  },
}, { prefix = "", preset = true })
