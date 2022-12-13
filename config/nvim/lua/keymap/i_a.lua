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
    [";"] = [[;...; (, . / similar)]],
    ["b"] = "(...), [...], or <...>",
    ["B"] = [[same as a{]],
    ["w"] = [[word with spaces]],
    ["W"] = [[WORD with spaces]],
    ["p"] = [[paragraph with blanklines]],
    ["s"] = [[sentence with spaces]],
    -- target.vim
    ["a"] = [[argument]],
    ["q"] = [['...', "..." or `...`]],
    ["N"] = {
      name = "prev object",
      ["B"] = [[same as a{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as a{]],
    },
    -- vim-indent-object
    ["i"] = [[indent content without line ↓]],
    ["I"] = [[indent content]],
    -- vim-textobj-entire
    ["e"] = [[entire content]],
    -- vim-textobj-line
    ["l"] = [[entire line]],
    -- vim-textobj-indblock
    ["o"] = [[indent with blanklines]],
    ["O"] = [[indent (exact) with blanklines]],
    -- matchup
    ["%"] = [[matchup (support repeat)]],
  },
  ["i"] = {
    name = "inside",
    ['"'] = [[inner "..."]],
    ["'"] = [[inner '...']],
    ["`"] = [[inner `...`]],
    ["("] = [[inner (...)]],
    ["{"] = [[inner {...}]],
    ["["] = "inner [...]",
    [";"] = [[inner ;...; (, . / similar)]],
    ["<lt>"] = [[inner <...>]],
    ["t"] = [[inner tag block]],
    ["b"] = "inner (...), [...], or <...>",
    ["B"] = [[same as i{]],
    ["w"] = [[word]],
    ["W"] = [[WORD]],
    ["p"] = [[paragraph]],
    ["s"] = [[sentence]],
    -- target.vim
    ["a"] = [[argument]],
    ["q"] = [[inner '...', "..." or `...`]],
    ["N"] = {
      name = "prev object",
      ["B"] = [[same as i{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as i{]],
    },
    -- vim-indent-object
    ["i"] = [[inner indent content]],
    ["I"] = [[same as i]],
    -- vim-textobj-entire
    ["e"] = [[entire content without blanklines]],
    -- vim-textobj-line
    ["l"] = [[entire line without indent]],
    -- vim-textobj-indblock
    ["o"] = [[indent]],
    ["O"] = [[indent (exact)]],
    -- matchup
    ["%"] = [[matchup (support repeat)]],
  },
  -- target.vim
  ["A"] = {
    name = "around with spaces",
    ['"'] = [["..."]],
    ["'"] = [['...']],
    ["`"] = [[`...`]],
    ["("] = [[(...)]],
    ["{"] = [[{...}]],
    ["["] = "[...]",
    ["<lt>"] = [[<...>]],
    ["t"] = [[tag block (with blankline)]],
    ["b"] = "(...), [...], or <...>",
    ["B"] = [[same as A{]],

    ["a"] = [[argument]],
    ["q"] = [['...' or "..."]],
    ["N"] = {
      name = "prev object",
      ["B"] = [[same as A{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as A{]],
    }
  },
  ["I"] = {
    name = [[inside with spaces]],
    ['"'] = [[inner "..."]],
    ["'"] = [[inner '...']],
    ["`"] = [[inner `...`]],
    ["("] = [[inner (...)]],
    ["{"] = [[inner {...}]],
    ["["] = "inner [...]",
    ["<lt>"] = [[inner <...>]],
    ["t"] = [[inner tag block]],
    ["b"] = "inner (...), [...], or <...>",
    ["B"] = [[same as I{]],

    ["a"] = [[argument]],
    ["q"] = [[inner '...', "..." or `...`]],
    ["N"] = {
      name = "prev object",
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
      objects["i"]["N"][k] = "prev " .. v
      objects["i"]["n"][k] = "next " .. v
      objects["I"]["N"][k] = "prev " .. v
      objects["I"]["n"][k] = "next " .. v
    end
  end
end
for k, v in pairs(objects['A']) do
  if k ~= "name" and k ~= "n" and k ~= "N" then
    if k ~= "B" then
      objects["a"]["N"][k] = "prev " .. v
      objects["a"]["n"][k] = "next " .. v
      objects["A"]["N"][k] = "prev " .. v
      objects["A"]["n"][k] = "next " .. v
    end
  end
end
require("which-key").register(objects, { mode = "o", prefix = "", preset = true })
