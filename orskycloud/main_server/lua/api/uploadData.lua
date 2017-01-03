
local comm  = require("lua.comm.common")
local redis = require("lua.db_redis.db_base")
local red   = redis:new()
local db_h  = require("lua.db_redis.db")
--上传数据
-- 解析POST请求，根据请求数据对redis进行操作
--请求样例：curl -i '127.0.0.1/api/uploadData.json?uid=1&did=3'

-- 用户上传数据格式：
-- URL：  127.0.0.1/api/uploadData.json?uid=""&&did=
-- 数据：
--   [
--         {
--             "sensor": "weight",
--             "value": 78
--         },
--         {
--             "sensor": "heart",
--             "value": 78
--         }
--     ]
-- }

-- 返回信息：
-- {
--    "Successful": false,
--    "Message": "Invalid device ID"
-- }


-- curl -i '127.0.0.1/api/uploadData.json?uid=001&did=001' -d '[{"sensor": "weight","value": 78},{"sensor": "heart","value": 78}]'

local args = ngx.req.get_uri_args()

local uid = args.uid
local did = args.did

--uid 参数的合法性校验在access阶段处理，接口不另外解决
if not uid or not did then
	ngx.log(ngx.WARN,"bad request args uid,did:",uid,did)
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

ngx.req.read_body()
local body = ngx.req.get_body_data()
if body == nil then
	ngx.log(ngx.WARN,"request body is nil")
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local post_args = comm.json_decode(body)
if comm.check_args(post_args,{}) == false then
	ngx.log(ngx.WARN, "error request body,probably is not a table")
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local response = {}

local res, err = red:hget("uid:" .. uid, "did:" .. did)
if err then
	ngx.log(ngx.WARN, "redis hget uid:"..uid.."error")
	ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end

if res == nil then
   response.Successful = false
   response.Message = "device id not exist or user not exist"
   ngx.say(comm.json_encode(response))
   return
end

local data = comm.json_decode(res)
if db_h.check_data_sersor(data,post_args) == false then
   response.Successful = false
   response.Message = "post data exist error sensor name"
   ngx.say(comm.json_encode(response))
	return
end

--处理upload数据
for k, _ in pairs(post_args) do
    post_args[k]["timestamp"] = ngx.localtime()
    table.insert(data["data"], post_args[k])
    ngx.log(ngx.INFO, "deal with upload data")
end

local res, err = red:hset("uid:"..uid,"did:"..did,comm.json_encode(data))
if err then
  ngx.log(ngx.ERR, "redis hset failed.")
  ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end
if res == 1 or res == 0 then
  response.Successful = true
  response.Message = "upload success"
end
ngx.log(ngx.WARN, "right request args uid :", uid)
ngx.say(comm.json_encode(response))

