local tb = (require "test_base_lua.test_base").new({unit_name="test"})
local comm  = require("lua.comm.common") 
local redis = require("db_redis.db_base")
local red = redis:new()

local redis_c = require("resty.redis")




function tb:test_001_test_mock()
	local function _red_hget(reself,key,value1,value2,...)
		if key == "UserId" and value1 == "john" then
			return "dsd",nil
		else
			local org_fun = self.mm[_red_hget]
			return org_fun(redself,key,value1,value2,...)
		end
	end

	local mock_rules = {
		{redis_c,"hget",_red_hget}
	}
	
	local function _test_run()

		local res,err = ngx.location.capture('/test')
		-- local result,err = self.mm[_red_hget]("UserId","john")
		local tmp = self.mm
		if err then
			error("error mm")
		end

		if tmp[_red_hget] == nil then
			error("dsd")
		else
			error("vdfas"..tmp[_red_hget])
		end
		tb:log(tmp[_red_hget])
		tb:log(nil)
		if res.status ~= 200 then
			error("failed return code:"..res.status)
		end
		tb:log(res.body)
	end

	tb:mock_run_args(mock_rules,_test_run)

end

tb:run()