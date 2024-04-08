M = {}

-- reverse a array t in place (also returns the array for functional use)
-- from https://www.programming-idioms.org/idiom/19/reverse-a-list/1314/lua
function M.reverse(t)
    local n = #t
    local i = 1
    while i < n do
        t[i], t[n] = t[n], t[i]
        i = i + 1
        n = n - 1
    end
    return t
end

function M.uppercase_first(str)
    return (str:gsub("^%l", string.upper))
end

--- Get a ts compatible range of the current visual selection.
-- from github.com/theHamsta/nvim-treesitter/lua/nvim-treesitter/incremental_selection
--
-- The range of ts nodes start with 0 and the ending range is exclusive.
function M.visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
  local _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")

  local start_row, start_col, end_row, end_col

  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    start_row = csrow
    start_col = cscol
    end_row = cerow
    end_col = cecol
  else
    start_row = cerow
    start_col = cecol
    end_row = csrow
    end_col = cscol
  end

  return start_row, start_col, end_row, end_col
end

return M
