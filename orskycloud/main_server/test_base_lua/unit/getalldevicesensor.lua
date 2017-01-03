local tb  = (require "test_base_lua.test_base").new({unit_name="getalldevicesensor"})
local common  = require("lua.comm.common")
local ljson   = require("lua.comm.ljson")
local redis   = require("db_redis.db_base")
local red = redis:new()
local redis_c = require("resty.redis")

-- curl '127.0.0.1/api/getalldevicesensor.json?uid=001'
function tb:init()
	self.uid   = string.rep('0', 32)
	self.did1  = string.rep('0', 32)
	self.did2  = string.rep('1', 32)
	self.uri   = '/api/getalldevicesensor.json?uid='
	self.data1 = { deviceName = "Test1", description = "description1", createTime = "2016-12-19 23:07:12", Sensor = {{unit = "kg", name = "weight", createTime = "2016-9-12 00:00:00", designation =  "体重"}}, data={{}}}
	self.data2 = { deviceName = "Test2", description = "description2", createTime = "2015-12-19 23:07:12", Sensor = {{unit = "kg", name = "high", createTime = "2016-9-12 00:00:00", designation =  "身高"}}, data={}}

	self.device   = self.did1 .. "#" .. self.did2
	self.userlist = self.uid .. "#"
	-- init redis data
	red:set("UserList", self.userlist)
	red:hset("uid:" .. self.uid, "device", self.device)
	red:hset("uid:" .. self.uid, "did:" .. self.did1, common.json_encode(self.data1))
	red:hset("uid:" .. self.uid, "did:" .. self.did2, common.json_encode(self.data2))
end


function tb:destroy()
	local ngx_dict_name = "cache_ngx"
  -- get from cache
  	local cache_ngx = ngx.shared[ngx_dict_name]
  	cache_ngx:flush_all()
	red:del("UserList", self.userlist)
	red:hdel("uid:" .. self.uid, "device")
	red:hdel("uid:" .. self.uid, "did:" .. self.did1)
	red:hdel("uid:" .. self.uid, "did:" .. self.did2)
end


function tb:test_001_normal_get_all_info()
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST})
	assert(res.status == 200)
	local data = common.json_decode(res.body)
    tb:log("response:", res.body)
    local ret_data = data["1"]
	self.data1["data"] = nil
	self.data2["data"] = nil
	if common.is_table_equal(ret_data[1], self.data1) == false and common.is_table_equal(ret_data[2], self.data2) == false then
		tb:log("ret_data1:", ljson.encode(common.json_encode(ret_data[1])))
		tb:log("exp_data1:", ljson.encode(common.json_encode(self.data1)))
		tb:log("ret_data2:", ljson.encode(common.json_encode(ret_data[2])))
		tb:log("exp_data2:", ljson.encode(common.json_encode(self.data2)))
		error("return data not equal exp data.")
	end
end


function tb:test_002_abnormal_not_exist_uid()
	local res, err = ngx.location.capture(self.uri .. string.rep('2', 32),
		{method = ngx.HTTP_POST})
	assert(res.status == 200)
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "error uid or uid not exist." or ret_success ~= false then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end
end


function tb:test_003_abnormal_redis_get_failed()
	local function red_get(red_self, key)
		if key == "UserList" then
			return nil, "redis get error"
		else
			local org_funs = self.mock_funs[red_get]
			return org_funs(red_self, key)
		end
	end
	local mock_rules = {
		{redis_c, "get", red_get}
	}
	local function _test_run()
		local res, err = ngx.location.capture(self.uri .. self.uid,
			{method = ngx.HTTP_POST})
		assert(res.status == ngx.HTTP_SERVICE_UNAVAILABLE)
	end
	self:mock_run(mock_rules, _test_run)
end



function tb:test_004_abnormal_not_exist_device()
	red:hdel("uid:" .. self.uid, "device")
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST})
	assert(res.status == 200)
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "Device not create yet" or ret_success ~= false then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end
end
tb:run()
