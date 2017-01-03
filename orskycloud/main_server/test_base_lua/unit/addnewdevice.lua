local tb  = (require "test_base_lua.test_base").new({unit_name="addnewdevice"})
local common  = require("lua.comm.common")
local ljson   = require("lua.comm.ljson")
local redis   = require("db_redis.db_base")
local red = redis:new()
local redis_c = require("resty.redis")

-- 添加新设备，格式
-- curl '127.0.0.1/api/addnewdevice.json?uid=001' -d '{"deviceName":"newDevice","description":"a test device"}'
-- 新建设备初始化数据样本：
-- {
--     "deviceName":"smartdev",
--     "createTime":"2016-9-12 00:00:00",
--     "description":"none",
--     "Sensor":[
--     ],
--     "data":[
--     ]
-- }
function tb:init()
	self.uid = string.rep('0', 32)
	self.did = string.rep('0', 32)
	self.uri = '/api/addnewdevice.json?uid='
	-- self.data = { deviceName = "Test1", description = "description1", createTime = "2016-12-19 23:07:12", Sensor = {{unit = "kg", name = "weight", createTime = "2016-9-12 00:00:00", designation =  "体重"}}, data={{}}}

	self.data = { deviceName = "TestDev", description = "none"}
	self.device   = self.did
	self.userlist = self.uid .. "#"
	-- init redis data
	red:set("UserList", self.userlist)
	red:hset("uid:" .. self.uid, "device", self.device)
	-- red:hset("uid:" .. self.uid, "did:" .. self.did, common.json_encode(self.data))
end


function tb:destroy()
	red:del("UserList")
	red:hdel("uid:" .. self.uid, "device")
end


function tb:test_001_normal_add_new_device()
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST, body = common.json_encode(self.data)})
	assert(res.status == 200)
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "add device success" or ret_success ~= true then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end

	local device, err = red:hget("uid:" .. self.uid, "device")
	local devicelist = common.split(device, '#')
	local devinfo
	for _, v in pairs(devicelist) do
		if v ~= self.did then
			devinfo = red:hget("uid:" .. self.uid, "did:" .. v)
			break
		--	tb:log("devinfo:", devinfo)
		end
	end
	local count, err = red:hget("uid:" .. self.uid, "count")
	--tb:log("device:", device)
	local red_data =  common.json_decode(devinfo)
	red_data["createTime"] = nil
	red_data["Sensor"] = nil
	red_data["data"]   = nil
	if common.is_table_equal(self.data, red_data) == false or count == 1 then
		tb:log("exp_data:", common.json_encode(self.data))
		tb:log("redis_data:", devinfo)
		tb:log("count:", count)
		error("error data redis.")
	end
end


function tb:test_002_normal_add_new_device()
	red:hdel("uid:" .. self.uid, "device")
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST, body = common.json_encode(self.data)})
	assert(res.status == 200)
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "add device success" or ret_success ~= true then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end

	local device, err = red:hget("uid:" .. self.uid, "device")
	local devicelist = common.split(device, '#')
	local devinfo = red:hget("uid:" .. self.uid, "did:" .. devicelist[1])

	local count, err = red:hget("uid:" .. self.uid, "count")
	-- tb:log("device:", device)
	local red_data =  common.json_decode(devinfo)
	red_data["createTime"] = nil
	red_data["Sensor"] = nil
	red_data["data"]   = nil
	if common.is_table_equal(self.data, red_data) == false or count == 1 then
		tb:log("exp_data:", common.json_encode(self.data))
		tb:log("redis_data:", devinfo)
		tb:log("count:", count)
		error("error data redis.")
	end
end


function tb:test_003_abnormal_bad_request()
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST, body = common.json_encode({description = "none"})})

	if res.status ~= 400 then
		error("error return code:" .. res.status)
	end
end


function tb:test_004_abnormal_userlist_is_null()
	red:del("UserList")
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST, body = common.json_encode(self.data)})

	if res.status ~= 200 then
		error("failed return code:" .. res.status)
	end

	--tb:log(res.body)
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "userlist is null,not user sign up yet" or ret_success ~= false then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end
end


function  tb:test_005_abnormal_not_exist_uid()
	local res, err = ngx.location.capture(self.uri .. string.rep('1', 32),
		{method = ngx.HTTP_POST, body = common.json_encode(self.data)})
	if res.status ~= 200 then
		error("failed return code:" .. res.status)
	end
	local data = common.json_decode(res.body)
	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "userid error，maybe not sign up yet" or ret_success ~= false then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("error msg and successful return.")
	end
end


function tb:test_006_abnormal_redis_exec_failed()
	local function red_exec()
		return nil
	end
	local mock_rules = {
		{redis_c, "exec", red_exec}
	}

	local function _test_run()
		local res, err = ngx.location.capture(self.uri .. self.uid,
			{method = ngx.HTTP_POST, body = common.json_encode(self.data)})
		if res.status ~= 200 then
			error("failed return code:" .. res.status)
		end
		local data = common.json_decode(res.body)
		local ret_msg     = data["Message"]
		local ret_success = data["Successful"]
		if ret_msg ~= "add new device failed." or ret_success ~= false then
			tb:log("ret_msg:", ret_msg)
			tb:log("ret_success:", ret_success)
			error("error msg and successful return.")
		end
	end

	self:mock_run(mock_rules, _test_run)
end


function tb:test_007_abnormal_body_is_nil()
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST})

	if res.status ~= 400 then
		error("error return code:" .. res.status)
	end
end

tb:run()