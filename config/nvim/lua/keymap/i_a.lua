
local objects = {
  ["a"] = {
    name = "around",
    ['"'] = [["..."]],
    ["'"] = [['...']],
    ["`"] = [[`...`]],
    ["("] = [[(...)]],
    ["{"] = [[{...}]],
    ["["] = "[...]",
    ["t"] = [[tag block (with whitespace)]],
    ["<lt>"] = [[<...>]],
    ["b"] = "any bracket",
    ["B"] = [[same as a{]],
    ["w"] = [[word (with whitespace)]],
    ["W"] = [[WORD (with whitespace)]],
    ["p"] = [[paragraph (with whitespace)]],
    ["s"] = [[sentence (with whitespace)]],
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
    ["o"] = [[indent including blank lines]],
    ["O"] = [[indent (exact) including blank lines]],
    -- tresitter-textobjects
    ["f"] = [[method]],
    ["c"] = [[class]],
  },
  ["i"] = {
    name = "inside",
    ['"'] = [[inner "..."]],
    ["'"] = [[inner '...']],
    ["`"] = [[inner `...`]],
    ["("] = [[inner (...)]],
    ["{"] = [[inner {...}]],
    ["["] = "inner [...]",
    ["<lt>"] = [[inner <...>]],
    ["t"] = [[inner tag block]],
    ["b"] = "inner any bracket",
    ["B"] = [[same as i{]],
    ["w"] = [[inner word]],
    ["W"] = [[inner WORD]],
    ["p"] = [[inner paragraph]],
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
    -- tresitter-textobjects
    ["f"] = [[inner method]],
    ["c"] = [[inner class]],
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
    ["t"] = [[tag block (with whitespace)]],
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
