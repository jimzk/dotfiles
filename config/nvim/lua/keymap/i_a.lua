local objects = {
  ["a"] = {
    name = "around",
    ['"'] = [["..."]],
    ["'"] = [['...']],
    ["`"] = [[`...`]],
    ["("] = [[(...)]],
    ["{"] = [[{...}]],
    ["["] = "[...]",
    ["t"] = [[tag block (with blankline)]],
    ["<lt>"] = [[<...>]],
    [";"] = [[;...; (also work on , . / )]],
    ["b"] = "bracket (), [] or <>",
    ["B"] = [[same as a{]],
    ["w"] = [[word (with blankline)]],
    ["W"] = [[WORD (with blankline)]],
    ["p"] = [[paragraph (with blankline)]],
    ["s"] = [[sentence (with blankline)]],
    -- target.vim
    ["a"] = [[argument]],
    ["q"] = [['...', "..." or `...`]],
    ["N"] = {
      name = "previous object",
      ["B"] = [[same as a{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as a{]],
    },
    -- vim-indent-object
    ["i"] = [[content in same indent but no line ↓]],
    ["I"] = [[content in same indent]],
    -- vim-textobj-entire
    ["e"] = [[entire content]],
    -- vim-textobj-line
    ["l"] = [[entire line]],
    -- vim-textobj-indblock
    ["o"] = [[indent including blanklines]],
    ["O"] = [[indent (exact) including blanklines]],
  },
  ["i"] = {
    name = "inside",
    ['"'] = [[inner "..."]],
    ["'"] = [[inner '...']],
    ["`"] = [[inner `...`]],
    ["("] = [[inner (...)]],
    ["{"] = [[inner {...}]],
    ["["] = "inner [...]",
    [";"] = [[inner ;...; (also work on , . / )]],
    ["<lt>"] = [[inner <...>]],
    ["t"] = [[inner tag block]],
    ["b"] = "inner bracket (), [] or <>",
    ["B"] = [[same as i{]],
    ["w"] = [[inner word]],
    ["W"] = [[inner WORD]],
    ["p"] = [[inner paragraph (till blankline)]],
    ["s"] = [[inner sentence]],
    -- target.vim
    ["a"] = [[argument]],
    ["q"] = [[inner '...', "..." or `...`]],
    ["N"] = {
      name = "previous object",
      ["B"] = [[same as i{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as i{]],
    },
    -- vim-indent-object
    ["i"] = [[inner content in same indent]],
    ["I"] = [[same as i]],
    -- vim-textobj-entire
    ["e"] = [[entire content without surrounding blank lines]],
    -- vim-textobj-line
    ["l"] = [[entire line without indent]],
    -- vim-textobj-indblock
    ["o"] = [[indent]],
    ["O"] = [[indent (exact)]],
  },
  -- target.vim
  ["A"] = {
    name = "around with trailing spaces",
    ['"'] = [["..."]],
    ["'"] = [['...']],
    ["`"] = [[`...`]],
    ["("] = [[(...)]],
    ["{"] = [[{...}]],
    ["["] = "[...]",
    ["<lt>"] = [[<...>]],
    ["t"] = [[tag block (with blank line)]],
    ["b"] = "any bracket",
    ["B"] = [[same as A{]],

    ["a"] = [[argument]],
    ["q"] = [['...' or "..."]],
    ["N"] = {
      name = "previous object",
      ["B"] = [[same as A{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as A{]],
    }
  },
  ["I"] = {
    name = [[inside with surrounding spaces]],
    ['"'] = [[inner "..."]],
    ["'"] = [[inner '...']],
    ["`"] = [[inner `...`]],
    ["("] = [[inner (...)]],
    ["{"] = [[inner {...}]],
    ["["] = "inner [...]",
    ["<lt>"] = [[inner <...>]],
    ["t"] = [[inner tag block]],
    ["b"] = "inner any bracket",
    ["B"] = [[same as I{]],

    ["a"] = [[argument]],
    ["q"] = [[inner '...', "..." or `...`]],
    ["N"] = {
      name = "previous object",
      ["B"] = [[same as I{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as I{]],
    }
  },
}
for k, v in pairs(objects["I"]) do
  if k ~= "name" and k ~= "n" and k ~= "N" then
    if k ~= "B" then
      objects["i"]["N"][k] = "previous " .. v
      objects["i"]["n"][k] = "next " .. v
      objects["I"]["N"][k] = "previous " .. v
      objects["I"]["n"][k] = "next " .. v
    end
  end
end
for k, v in pairs(objects['A']) do
  if k ~= "name" and k ~= "n" and k ~= "N" then
    if k ~= "B" then
      objects["a"]["N"][k] = "previous " .. v
      objects["a"]["n"][k] = "next " .. v
      objects["A"]["N"][k] = "previous " .. v
      objects["A"]["n"][k] = "next " .. v
    end
  end
end
require("which-key").register(objects, { mode = "o", prefix = "", preset = true })
