local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
-- local c = ls.choice_node
local _c = ls._choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- s({ trig = "vim.api", desc = "vim.api." }, fmt("vim.api.{}", { i(1) })),
  -- s({ trig = "vim.cmd", desc = "vim.cmd." }, fmt('vim.api.cmd("{}")', { i(1) })),
  -- s({ trig = "vn", desc = "vim.notify(..)" }, fmt('vim.notify("{}")', i(1))),
  s(
    { trig = "vim.notify", desc = "vim.notify(..)" },
    fmt('vim.notify("{}", vim.log.levels.{level}, {{ title = "{title}" }})', {
      i(3),
      level = _c(1, {
        t("INFO"),
        t("DEBUG"),
        t("ERROR"),
        t("TRACE"),
        t("WARN"),
        t("OFF"),
      }),
      title = i(2, "Notification"),
    })
  ),

  s("vim.api.nvim_get_current_win", fmt("vim.api.nvim_get_current_win()", {})),
  s("vim.api.nvim_get_current_buf", fmt("vim.api.nvim_get_current_buf()", {})),
  s("vim.api.nvim_win_get_buf", fmt("vim.api.nvim_win_get_buf({})", { i(1, "win_id") })),
  s("vim.api.nvim_tabpage_get_win", fmt("vim.api.nvim_tabpage_get_win({})", { i(1, "tabpage_id") })),
  s(
    "vim.api.nvim_create_autocmd",
    fmt(
      [[
  vim.api.nvim_create_autocmd("{}", {{
    pattern = {{"{}"}},
    callback = function(opts)
      local bufnr = opts.buf
      local filepath = opts.file
      {}
    end
  }})]],
      {
        i(1, "FileType"),
        i(2, "lua"),
        i(0),
      }
    )
  ),

  s(
    "vim.defer_fn",
    fmt(
      [[
  vim.defer_fn(function()
    {}
  end, {})
  ]],
      { i(2), i(1, "1000") }
    )
  ),
  s(
    "vim.schedule",
    fmt(
      [[
  vim.schedule(function()
    {}
  end)
  ]],
      { i(1) }
    )
  ),
}
