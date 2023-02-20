return {
  -- Enhanced f/F
  -- Flaw: f/F does not have label for quick selection.
  "justinmk/vim-sneak",
  event = "VeryLazy",
  dependencies = {
    "ggandor/flit.nvim",
  },
  config = function()
    vim.g["sneak#use_ic_scs"] = 1 -- Case sensitive
    vim.g["sneak#absolute_dir"] = 1 -- Absolution search direction
    vim.g["sneak#s_next"] = 0 -- Disable default f/F move to next after search

    local opts = { noremap = true, silent = true, expr = true, replace_keycodes = false }
    map({ "n", "x" }, "f", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_f']], nil, opts)
    map({ "n", "x" }, "F", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_F']], nil, opts)
    -- map("o", "f", [[sneak#is_sneaking() ? '<Plug>Sneak_;' : '<Plug>Sneak_t']], nil, opts)
    -- map("o", "F", [[sneak#is_sneaking() ? '<Plug>Sneak_,' : '<Plug>Sneak_T']], nil, opts)
    vim.defer_fn(function()
      map({ "v", "n" }, "<Esc>", [[sneak#is_sneaking() ? '<Esc>:<C-u>call sneak#cancel()<cr>' : '<Esc>']], nil, opts)
      vim.cmd [[hi! link Sneak LeapLabelPrimary]]
    end, 100)
    vim.on_key(function(char)
      if vim.fn.mode() == "v" then
        local keys = { "y", "Y" }
        if vim.tbl_contains(keys, vim.fn.keytrans(char)) then
          vim.fn["sneak#cancel"]()
        end
      end
    end, vim.api.nvim_create_namespace("sneak"))
  end
}
