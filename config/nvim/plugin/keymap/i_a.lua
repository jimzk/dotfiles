
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
    ["q"] = [['...' or "..."]],
    ["l"] = {
      name = "previous object",
      ["B"] = [[same as a{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as a{]],
    },
    -- vim-indent-object
    ["i"] = [[indent content and line above]],
    ["I"] = [[indent content and line above/below]],
      --- vim-matchup
    ["%"] = "any bracket or ifelse block",
    -- vim-textobj-entire
    ["e"] = [[entire content of current buffer]]
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
    ["l"] = {
      name = "previous object",
      ["B"] = [[same as i{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as i{]],
    },
    -- vim-indent-object
    ["i"] = [[inner indent content (no line above)]],
    ["I"] = [[inner indent content (no line above/below)]],
    --- vim-matchup
    ["%"] = "inner any bracket or ifelse block",
    -- vim-textobj-entire
    ["e"] = [[entire content without surrounding empty linesof current buffer]]
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
    ["l"] = {
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
    ["l"] = {
      name = "previous object",
      ["B"] = [[same as I{]],
    },
    ["n"] = {
      name = "next object",
      ["B"] = [[same as I{]],
    }
  },
}
for k, v in pairs(objects['I']) do
  if k ~= "name" and k ~= "n" and k ~= "l" then
    if k ~= 'B' then
      objects['i']["l"][k] = "previous " .. v
      objects["i"]["n"][k] = "next " .. v
      objects['I']['l'][k] = "previous " .. v
      objects['I']['n'][k] = "next " .. v
    end
  end
end
for k, v in pairs(objects['A']) do
  if k ~= "name" and k ~= "n" and k ~= "l" then
    if k ~= 'B' then
      objects['a']["l"][k] = "previous " .. v
      objects['a']['n'][k] = "next " .. v
      objects['A']['l'][k] = "previous " .. v
      objects['A']['n'][k] = "next " .. v
    end
  end
end
require("which-key").register(objects, { mode = "o", prefix = "", preset = true })
