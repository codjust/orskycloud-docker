
local common = require "lua.comm.common"
local redis  = require("lua.db_redis.db_base")
local red    = redis:new()

local _M = {
	_VERSION = 0.1
}


function _M._red_hget_(key, fileid)
	return red:hget(key, fileid)
end


return _M