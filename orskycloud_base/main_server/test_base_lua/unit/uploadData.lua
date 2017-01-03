local tb  = (require "test_base_lua.test_base").new({unit_name="uploadData"})
local common  = require("lua.comm.common")
local redis   = require("db_redis.db_base")
local red = redis:new()
local redis_c = require("resty.redis")


function tb:init()
	self.uid = string.rep('0', 32)
	self.did = string.rep('0', 32)
	self.uri = '/api/uploadData.json?uid='
	self.data = { Sensor = {{unit = "kg", name = "weight", createTime = "2016-9-12 00:00:00", designation =  "体重"}}, data={}}
	red:hset("uid:" .. self.uid, "did:" .. self.did, common.json_encode(self.data))
end


function tb:destroy()
	red:hdel("uid:" .. self.uid, "did:" .. self.did)
end


function tb:test_001_normal_upload_data()
	local send = {{sensor = "weight", value = 78}, {sensor = "weight", value = 74}}
	local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did,
		{method = ngx.HTTP_POST, body = common.json_encode(send)})
	assert(res.status == 200)
	local data = common.json_decode(res.body)
	local ret_msg = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "upload success" or ret_success ~= true then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("ret_msg or ret_success failed.")
	end
	local red_data = red:hget("uid:" .. self.uid, "did:" .. self.did)
	local exp_data = common.json_decode(red_data)["data"]
	exp_data[1].timestamp = nil
	exp_data[2].timestamp = nil
	if common.is_table_equal(exp_data, send) == false then
		tb:log("send data:", common.json_encode(send))
		tb:log("exp data:", common.json_encode(exp_data))
		error("exp_data not equal send data.")
	end
end


function tb:test_002_abnormal_bad_request()
	local send = {{sensor = "weight", value = 78}, {sensor = "weight", value = 74}}
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST, body = common.json_encode(send)})
	assert(res.status == 400)
end


function tb:test_003_abnormal_bad_request()
	local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did,
		{method = ngx.HTTP_POST})
	assert(res.status == 400)
end


function tb:test_004_abnormal_redis_hget_error()
	local function red_hget(red_self, uid, did)
		if uid == "uid:" .. self.uid and did == "did:" .. self.did then
			return nil, "redis hget error"
		else
			local org_funs = self.mock_funs[red_hget]
			return org_funs(red_self, uid, did)
		end
	end
	local mock_rules = {
		{redis_c, "hget", red_hget}
	}
	local function _test_run()
		local send = {{sensor = "weight", value = 78}, {sensor = "weight", value = 74}}
		local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did,
			{method = ngx.HTTP_POST, body = common.json_encode(send)})
		assert(res.status == ngx.HTTP_SERVICE_UNAVAILABLE)
	end
	self:mock_run(mock_rules, _test_run)
end


function tb:test_005_abnormal_redis_data_empty()
	local send = {{sensor = "weight", value = 78}, {sensor = "weight", value = 74}}
	local res, err = ngx.location.capture(self.uri .. "1221212212121212212" .. "&did=" .. self.did,
		{method = ngx.HTTP_POST, body = common.json_encode(send)})
	assert(res.status == 200)

	local data = common.json_decode(res.body)
	local ret_msg = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "device id not exist or user not exist" or ret_success ~= false then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("ret_msg or ret_success failed.")
	end
end

function tb:test_006_abnormal_redis_hset_error()
	local function red_hset(red_self, uid, did, ...)
		if uid == "uid:" .. self.uid and did == "did:" .. self.did then
			return nil, "redis hset error"
		else
			local org_funs = self.mock_funs[red_hget]
			return org_funs(red_self, uid, did, ...)
		end
	end
	local mock_rules = {
		{redis_c, "hset", red_hset}
	}
	local function _test_run()
		local send = {{sensor = "weight", value = 78}, {sensor = "weight", value = 74}}
		local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did,
			{method = ngx.HTTP_POST, body = common.json_encode(send)})
		assert(res.status == ngx.HTTP_SERVICE_UNAVAILABLE)
	end
	self:mock_run(mock_rules, _test_run)
end


tb:run()