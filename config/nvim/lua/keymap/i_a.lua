local wk = require("which-key")
local objects = {
  ["a"] = {
    name = "around",
    ['"'] = [["..."]],
    ["'"] = [['...']],
    ["`"] = [[`...`]],
    ["("] = [[(...)]],
    ["{"] = [[{...}]],
    ["["] = "[...]",
    ["t"] = [[tag block]],
    ["<lt>"] = [[<...>]],
    ["B"] = [[alias a{]],
    ["w"] = [[word with spaces]],
    ["W"] = [[WORD with spaces]],
    ["p"] = [[paragraph with blanklines]],
    ["s"] = [[sentence with spaces]],
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
    ["a"] = [[argument]],
    ["q"] = [['...', "..." or `...`]],
    ["N"] = "prev object",
    ["n"] = "next object",
    [","] = ",...,",
    ["<Space>"] = "between whitespaces",
    -- vim-indent-object
    ["i"] = [[indent content]],
    -- vim-textobj-entire
    ["e"] = [[entire content]],
    -- vim-textobj-line
    ["l"] = [[entire line]],
    -- vim-textobj-indblock
    ["o"] = [[indent with blanklines]],
    ["O"] = [[indent (exact) with blanklines]],
  },
  ["i"] = {
    name = "inside",
    ['"'] = [["..."]],
    ["'"] = [['...']],
    ["`"] = [[`...`]],
    ["("] = [[(...)]],
    ["{"] = [[{...}]],
    ["["] = "[...]",
    ["<lt>"] = [[<...>]],
    ["t"] = [[tag block]],
    ["B"] = [[alias i{]],
    ["w"] = [[word]],
    ["W"] = [[WORD]],
    ["p"] = [[paragraph]],
    ["s"] = [[sentence]],
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
    ["a"] = [[argument]],
    ["q"] = [['...', "..." or `...`]],
    ["N"] = "prev object",
    ["n"] = "next object",
    [","] = ",...,",
    ["<Space>"] = "between whitespaces",
    -- vim-indent-object
    ["i"] = [[indent content]],
    -- vim-textobj-entire
    ["e"] = [[entire content without blanklines]],
    -- vim-textobj-line
    ["l"] = [[line without trailing whitespaces]],
    -- vim-textobj-indblock
    ["o"] = [[indent]],
    ["O"] = [[indent (exact)]],
  },
}
wk.register(objects, { mode = "o", prefix = "", preset = true })

wk.register({
  ["<M-w>"] = { "<Plug>CamelCaseMotion_w", "camelCase w" },
  ["<M-b>"] = { "<Plug>CamelCaseMotion_b", "camelCase b" },
  ["<M-e>"] = { "<Plug>CamelCaseMotion_e", "camelCase e" },
  ["<M-g>e"] = { "<Plug>CamelCaseMotion_ge", "camelCase ge" },
  ["i8"] = { "<Plug>CamelCaseMotion_iw", "camelCase iw", mode = { "o", "x" } },
}, { mode = { "n", "v", "o" }, silent = true })
