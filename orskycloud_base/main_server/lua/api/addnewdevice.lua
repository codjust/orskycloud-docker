local common = require "lua.comm.common"
local redis  = require "lua.db_redis.db_base"
local red    = redis:new()
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
local args = ngx.req.get_uri_args()
local uid  = args.uid
ngx.req.read_body()
local post_args = ngx.req.get_body_data()
if not uid or not post_args then
	ngx.log(ngx.ERR,"uid is nil")
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local post_data = common.json_decode(post_args)
if common.check_body_table(post_data, {deviceName = "", description = ""}) == false then
	ngx.log(ngx.ERR,"error post data")
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local response = {}
response.Successful = true
response.Message    = "success"

local res, err = red:get("UserList")
if err then
	ngx.log(ngx.ERR, "redis get UserList error")
	ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end

local userlist = common.split(res, "#")
if next(userlist) == nil then
	ngx.log(ngx.ERR, "userlist is nil.")
	response.Successful = false
	response.Message    = "userlist is null,not user sign up yet"
	ngx.say(common.json_encode(response))
	return
end

local t_id
for _, v in pairs(userlist) do
	t_id = v
	if uid == t_id then
		break
	end
end

if uid ~= t_id then
	response.Successful = false
	response.Message    = "userid error，maybe not sign up yet"
	ngx.say(common.json_encode(response))
	return
end

local dev_table = post_data
dev_table["createTime"] = ngx.localtime()
dev_table["Sensor"]     = {}
dev_table["data"]       = {}

local did = red:hincrby("uid:" .. uid, "nextDeviceId", 1)
local device = red:hget("uid:" .. uid, "device")
if device == nil then
	device = ngx.md5(did)
else
	device = device .. "#" .. ngx.md5(did)
end

-- redis 事务
red:multi()
red:hset("uid:" .. uid, "did:" .. ngx.md5(did), common.json_encode(dev_table))
red:hincrby("uid:" .. uid, "count", 1)
red:hset("uid:" .. uid, "device", device)
local res = red:exec()
if res == nil then
	ngx.log(ngx.ERR, "redis multi failed.")
	response.Successful = false
	response.Message    = "add new device failed."
	ngx.say(common.json_encode(response))
	return
end

response.Successful = true
response.Message    = "add device success"
ngx.say(common.json_encode(response))
