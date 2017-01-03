local redis = require("lua.db_redis.db_base")
local red   = redis:new()



local res,err = red:hget("UserId","john")
if err then
	ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end


local result,err = red:hget("uid:001","count")
if err then
  ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end

ngx.say(res,result)