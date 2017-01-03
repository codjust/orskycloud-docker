local tb  = (require "test_base_lua.test_base").new({unit_name="addnewsensor"})
local common  = require("lua.comm.common")
local ljson   = require("lua.comm.ljson")
local redis   = require("db_redis.db_base")
local red = redis:new()
local redis_c = require("resty.redis")

-- curl '127.0.0.1/api/addnewsensor.json?uid=001&did=002' -d '{"name":"newsensor","designation":"test","unit": "kg"}'
function tb:init()
	self.uid = string.rep('0', 32)
	self.did = string.rep('1', 32)
	self.uri = '/api/addnewsensor.json?uid='
	self.data = {deviceName = "Test1", description = "description1", createTime = "2016-12-19 23:07:12", Sensor = {{unit = "kg", name = "weight", createTime = "2016-9-12 00:00:00", designation =  "体重"}}, data={{}}}

	self.sensor   = { name = "newsensor", designation = "test", unit = "kg"}
	self.device   = self.did
	self.userlist = self.uid .. "#"
	-- init redis data
	--red:hset("uid:" .. self.uid, "device", self.device)
	red:hset("uid:" .. self.uid, "did:" .. self.did, common.json_encode(self.data))

end


function tb:destroy()
	red:hdel("uid:" .. self.uid, "did:" .. self.did)
end


function tb:test_001_normal_add_new_sensor()
	local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did,
		{method = ngx.HTTP_POST, body = common.json_encode(self.sensor)})
	if res.status ~= 200 then
		error("error return code:" .. res.status)
	end
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "add sensor success" or ret_success ~= true then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end
	local device, err = red:hget("uid:" .. self.uid, "did:" .. self.did)
	local ret_data = common.json_decode(device)["Sensor"]
	local exp_data = self.data["Sensor"]
	table.insert(exp_data, self.sensor)
	if common.is_table_equal(ret_data, exp_data) == false then
		tb:log("ret_data:", common.json_encode(ret_data))
		tb:log("exp_data:", common.json_encode(exp_data))
		error("ret_data not equal exp_data.")
	end
end


function tb:test_002_abnormal_exist_sensor()
	self.sensor.name = "weight"
	local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did,
		{method = ngx.HTTP_POST, body = common.json_encode(self.sensor)})
	if res.status ~= 200 then
		error("error return code:" .. res.status)
	end
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "sensor already exist" or ret_success ~= false then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end
end


function tb:test_003_abnormal_uid_error()
	local res, err = ngx.location.capture(self.uri .. string.rep('2', 32) .. "&did=" .. self.did,
		{method = ngx.HTTP_POST, body = common.json_encode(self.sensor)})
	if res.status ~= 200 then
		error("error return code:" .. res.status)
	end
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "uid error or did error or not exist uid or did" or ret_success ~= false then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end
end

tb:run()