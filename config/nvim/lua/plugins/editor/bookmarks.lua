return {
  "tomasky/bookmarks.nvim",
  event = "VeryLazy",
  enabled = true,
  config = function()
    require("bookmarks").setup({
      -- sign_priority = 8,  --set bookmark sign priority to cover other sign
      save_file = vim.fn.stdpath("data") .. "/bookmarks",
      keywords = {
        ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
        ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
        ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
        ["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
      },
      on_attach = function(bufnr)
        local bm = require("bookmarks")
        local map = require("util").map
        map("n", "<M-m>", "<CMD>Telescope bookmarks list<CR>", "Bookmark List (bookmarks.nvim)")
        map("n", "mm", bm.bookmark_ann, "Add/Edit Bookmark (bookmarks.nvim)")
        map("n", "m<BS>", bm.bookmark_toggle, "Clean Bookmark (bookmarks.nvim)")
        map("n", "m<S-BS>", bm.bookmark_clean, "Clean Bookmarks in File (bookmarks.nvim)")
      end,
    })
    local telescope = require("telescope")
    telescope.load_extension("bookmarks")
    local _list = telescope.extensions.bookmarks.list
    telescope.extensions.bookmarks.list = function(opts)
      local default_opts = {
        prompt_title = "Bookmarks in Folder (" .. vim.loop.cwd():gsub("^" .. vim.env.HOME, "~") .. ")",
        attach_mappings = function(prompt_bufnr, map)
          vim.keymap.set("i", "<M-m>", "<Esc>", { remap = true, buffer = prompt_bufnr })
          return true
        end,
      }
      opts = vim.tbl_deep_extend("force", default_opts, opts or {})
      _list(opts)
    end
  end,
}
