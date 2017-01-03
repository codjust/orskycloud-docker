-- Insert redis data
local common = require "lua.comm.common"
local redis  = require "lua.db_redis.db_base"
local red    = redis:new()


-- local filename = ngx.req.get_uri_args()

-- if not filename then
-- 	filename = 'data.json'
-- end
local filePath = [[lua/tools/data.json]]
local file     = io.open(filePath,'r')

if file then
	local data_json = file:read("*all")
	file:close()
	ngx.log(ngx.WARN,"data:", common.json_encode(data_json))
	red:hset("uid:001","did:001",data_json)

	ngx.say("Success")

else
	ngx.log(ngx.ERR,"file open error")
end

