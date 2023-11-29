return {
  -- Visit latest visited files
  -- https://www.reddit.com/r/neovim/comments/185yi7q/minivisits_track_and_reuse_file_system_visits/
  "echasnovski/mini.visits",
  event = "BufRead",
  keys = {
    { "<leader>ml", function() MiniVisits.select_path() end, desc = "list visited file (MiniVisits)" },
    {
      "<leader>md",
      function()
        local list = MiniVisits.list_paths()
        local cwd = vim.fn.getcwd() .. "/"
        for i, path in ipairs(list) do
          list[i] = path:gsub(cwd, "")
        end
        vim.ui.select(list, {
          prompt = "Delete Path",
        }, function(choice)
          if not choice then return end
          MiniVisits.remove_path(cwd .. choice)
        end)
      end,
      desc = "remove visited file (MiniVisits)",
    },
    {
      "<leader>mD",
      function()
        MiniVisits.remove_path("")
        vim.notify("Remove all visited files from list")
      end,
      desc = "remove all visited files (MiniVisits)",
    },
    -- Label is the secondary category
    {
      "<leader>mL",
      function() MiniVisits.select_label("", "") end,
      desc = "list files in label (MiniVisits)",
    },
    {
      "<leader>ma",
      function()
        local labels = MiniVisits.list_labels("", "")
        labels = { "[New]", table.unpack(labels) }
        if #labels ~= 0 then
          vim.ui.select(labels, {
            prompt = "Select a label to add",
          }, function(choice)
            if choice then
              if choice == "[New]" then
                MiniVisits.add_label()
              else
                MiniVisits.add_label(choice)
              end
            end
          end)
        end
      end,
      desc = "add file to label (MiniVisits)",
    },
    {
      "<leader>m<S-BS>",
      function()
        local labels = MiniVisits.list_labels("", "")
        if #labels ~= 0 then
          vim.ui.select(labels, {
            prompt = "Select a label to remove",
          }, function(label)
            if label then
              MiniVisits.remove_label(label, "")
              vim.notify("Remove label " .. label)
            end
          end)
        else
          require("lazy.core.util").warn("No label to delete", { title = "Mini.Visit" })
        end
      end,
      desc = "remove label (MiniVisits)",
    },
    {
      "<leader>m<BS>",
      function()
        local labels = MiniVisits.list_labels()
        if #labels ~= 0 then
          vim.ui.select(labels, {
            prompt = "Remove file from label",
          }, function(label)
            local path = vim.fn.expand("%:p:.")
            if label then
              MiniVisits.remove_label(label, path)
              vim.notify("Remove current file from label " .. label)
            end
          end)
        else
          require("lazy.core.util").warn("No label to delete", { title = "Mini.Visit" })
        end
      end,
      desc = "remove current file from label (MiniVisits)",
    },
  },
  opts = {},
}
