-- 获取用户所有设备和传感器信息,没有返回提示信息

-- curl '127.0.0.1/api/getalldevicesensor.json?uid=001'
local common = require "lua.comm.common"

local logic_func = require "lua.comm.logic_func"
local redis  = require "lua.db_redis.db_base"

local red    = redis:new()

local args = ngx.req.get_uri_args()
local uid  = args.uid
if not uid then
	ngx.log(ngx.ERR,"request uid is nil")
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local response = {}
response.Successful = true
response.Message    = "success"

local uid_list, err = red:get("UserList")
if err then
	ngx.log(ngx.ERR, "redis get failed.")
	ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end
local tb_uid = common.split(uid_list, "#")
local id_t
for _, id in pairs(tb_uid) do
	if id == uid then
		id_t = id
		break
	end
end
if id_t ~= uid then
	ngx.log(ngx.ERR, "error uid or uid not exist.", id_t)
	response.Successful = false
	response.Message    = "error uid or uid not exist."
	ngx.say(common.json_encode(response))
	return
end

local device_list, err = common.get_data_with_cache(
								{
									key="cdn_cache_device",
									exp_time_succ=60*30,
								 	exp_time_fail=3
								 },
								logic_func._red_hget_, "uid:" .. uid, "device")
if err then
	ngx.log(ngx.ERR, "redis hget error")
	ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end

if not device_list then
	ngx.log(ngx.ERR, "Device list is nil")
	response.Successful = false
	response.Message    = "Device not create yet"
	ngx.say(common.json_encode(response))
	return
end

local dev_list = common.split(device_list, "#")
local ret_info = {}
for _, v in ipairs(dev_list) do
	--local dev_temp, err = red:hget("uid:" .. uid, "did:" .. v)
	local dev_t, err = common.get_data_with_cache(
								{
									key="cdn_cache_dev_temp",
									exp_time_succ=60*30,
								 	exp_time_fail=3
								 },
								logic_func._red_hget_, "uid:" .. uid, "did:" .. v)
	if err then
		ngx.log(ngx.ERR, "redis hget error")
		ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
	end
	local dev_temp = common.json_decode(dev_t)
	dev_temp["data"] = nil
	table.insert(ret_info, dev_temp)
end

table.insert(response, ret_info)
ngx.say(common.json_encode(response))




