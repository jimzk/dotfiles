return {
  "bkad/CamelCaseMotion",
  event = "BufReadPre",
  init = function()
    -- w for camel move, W for entire keyword move
    -- map({ "n", "v", "o" }, "w", "<Plug>CamelCaseMotion_w")
    -- map({ "n", "v", "o" }, "b", "<Plug>CamelCaseMotion_b")
    -- map({ "n", "v", "o" }, "e", "<Plug>CamelCaseMotion_e")
    -- map({ "n", "v", "o" }, "ge", "<Plug>CamelCaseMotion_ge")

    map({ "v", "o" }, "i<C-w>", "<Plug>CamelCaseMotion_iw")
    -- map({ "v", "o" }, "iW", "iw")

    -- map({ "n", "v", "o" }, "W", "w")
    -- map({ "n", "v", "o" }, "B", "b")
    -- map({ "n", "v", "o" }, "E", "e")
    -- map({ "n", "v", "o" }, "gE", "ge")
    -- Include # _ - in word
    -- vim.opt.iskeyword = "@,48-57,192-255,#,_,-"
  end,
}
