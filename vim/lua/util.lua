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

return M
