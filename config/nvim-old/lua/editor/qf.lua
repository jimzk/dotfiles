vim.api.nvim_create_autocmd('FileType', {
  pattern = { "qf" },
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.cursorline = true
  end
})

-- First line in qf is fix line. Make it highlight identical with other lines.
-- https://github.com/neovim/neovim/issues/5722#issuecomment-648820525
vim.cmd [[au ColorScheme * hi QuickFixLine cterm=bold ctermfg=none ctermbg=none]]
vim.cmd [[au ColorScheme * hi! link BqfPreviewCursor BqfPreviewRange]]

-- More beautiful quickfix appearance
-- https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix
local fn = vim.fn

-- plain replace
function string.replace(self, old, new)
  local b, e = self:find(old, 1, true)
  if b == nil then
    return self
  else
    return self:sub(1, b - 1) .. new .. self:sub(e + 1)
  end
end

function _G.qftf(info)
  local ret = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  -- It's a good opportunity to change current directory in quickfixtextfunc :)
  --
  -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
  local list
  if info.quickfix == 1 then
    list = fn.getqflist({ id = info.id, items = 0, all = 0 })
  else
    list = fn.getloclist(info.winid, { id = info.id, items = 0, all = 0 })
  end
  local items = list.items
  local limit = 31
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'
  local cwd = fn.getcwd() .. "/"
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname
              :replace(cwd, '')
              :replace(vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      -- Remove leading spaces
      e.text = e.text:gsub("^%s*", "")
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
