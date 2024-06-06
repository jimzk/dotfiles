return {
  "tomasky/bookmarks.nvim",
  event = "VeryLazy",
  enabled = false,
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
        local map = Util.map
        -- map("n", "mm", bm.bookmark_ann, "Add/Edit Bookmark (bookmarks.nvim)")
        map("n", "<F3>", bm.bookmark_toggle, "Toggle Bookmark (bookmarks.nvim)")
        map("n", "<M-F3>", "<CMD>Telescope bookmarks list<CR>", "Choose Bookmark (bookmarks.nvim)")
        -- map("n", "<C-b><Cr>", "<F3>", "Toggle Bookmark (bookmarks.nvim)", { remap = true })
        -- map("n", "<C-b>m", "<F4>", "Choose Bookmark (bookmarks.nvim)", { remap = true })
        -- map("n", "m<BS>", bm.bookmark_clean, "Clean Bookmarks in Buffer (bookmarks.nvim)")
        vim.defer_fn(function()
          map({ "n", "v" }, "<M-j>", bm.bookmark_next, "Next Bookmark (bookmarks.nvim)")
          map({ "n", "v" }, "<M-k>", bm.bookmark_prev, "Prev Bookmark (bookmarks.nvim)")
        end, 500)
      end,
    })
    local telescope = require("telescope")
    telescope.load_extension("bookmarks")
    local _list = telescope.extensions.bookmarks.list
    telescope.extensions.bookmarks.list = function(opts)
      local default_opts = {
        prompt_title = "Bookmarks in Folder (" .. vim.loop.cwd():gsub("^" .. vim.env.HOME, "~") .. ")",
        attach_mappings = function(prompt_bufnr, map)
          vim.keymap.set("i", "<M-F3>", "<Esc>", { remap = true, buffer = prompt_bufnr })
          return true
        end,
      }
      opts = vim.tbl_deep_extend("force", default_opts, opts or {})
      _list(opts)
    end
  end,
}
