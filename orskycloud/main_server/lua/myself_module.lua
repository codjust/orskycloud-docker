
local _M ={_VERSION = '0.10'}

function _M.sum(...)
    local sum= 0

    for i,v in ipairs({...}) do
      sum = sum +v
    end

    return sum
end

return _M
