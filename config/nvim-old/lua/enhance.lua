-- https://www.reddit.com/r/neovim/comments/1083g3o/searcher_some_cool_code_that_i_think_you_should/
local function cmd(alias, command)
  return vim.api.nvim_create_user_command(alias, command, { nargs = 0 })
end

cmd('Search', function()
  vim.ui.input(
    { prompt = "Search: " },
    function(input)
      if not input then return end
      -- local search = vim.fn.input("Search: ")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      -- our picker function: colors
      local searcher = function(opts)
        opts = opts or {}
        pickers.new(opts, {
          prompt_title = "OmniSearch",
          finder = finders.new_table {
            results = {
              { 'Stack Overflow', ('https://www.stackoverflow.com/search\\?q\\=' .. input:gsub(' ', '+')) },
              { 'Google Search', ('https://www.google.com/search\\?q\\=' .. input:gsub(' ', '+')) },
              { 'Youtube', ('https://www.youtube.com/results\\?search_query\\=' .. input:gsub(' ', '+')) },
              { 'Wikipedia', ('https://en.wikipedia.org/w/index.php\\?search\\=' .. input:gsub(' ', '+')) },
              { 'Github', ('https://github.com/search\\?q\\=' .. input:gsub(' ', '+')) },
            },
            entry_maker = function(entry)
              return { value = entry, display = entry[1], ordinal = entry[1] }
            end
          },
          sorter = conf.generic_sorter(opts),
          attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              vim.cmd(("silent execute '!open %s &'"):format(selection['value'][2]))
              copy(("silent execute '!open %s &'"):format(selection['value'][2]))
            end)
            return true
          end,
        }):find()
      end
      searcher(require("telescope.themes").get_dropdown({}))
    end)
end
)
