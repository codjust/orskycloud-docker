module("lua.comm.common", package.seeall)
--基础函数
local json = require(require("ffi").os=="Windows" and "resty.dkjson" or "cjson")
local lock   = require "resty.lock"

--解析json，封装cjson，加入pcall异常处理
function json_decode(str)
	local json_value = nil
	pcall(function (str) json_value = json.decode(str) end,str)
	return json_value
end


function json_encode( data, empty_table_as_object )
  --lua的数据类型里面，array和dict是同一个东西。对应到json encode的时候，就会有不同的判断
  --对于linux，我们用的是cjson库：A Lua table with only positive integer keys of type number will be encoded as a JSON array. All other tables will be encoded as a JSON object.
  --cjson对于空的table，就会被处理为object，也就是{}
  --dkjson默认对空table会处理为array，也就是[]
  --处理方法：对于cjson，使用encode_empty_table_as_object这个方法。文档里面没有，看源码
  --对于dkjson，需要设置meta信息。local a= {}；a.s = {};a.b='中文';setmetatable(a.s,  { __jsontype = 'object' });ngx.say(comm.json_encode(a))
    local json_value = nil
    if json.encode_empty_table_as_object then
        json.encode_empty_table_as_object(empty_table_as_object or false) -- 空的table默认为array
    end
    if require("ffi").os ~= "Windows" then
        json.encode_sparse_array(true)
    end
    --json_value = json.encode(data)
    pcall(function (data) json_value = json.encode(data) end, data)
    return json_value
end

function check_args(args, require_key)
    if not args or "table" ~= type(args) then
      return false
    end
    local key, value
    for k,_ in ipairs(require_key) do
        key = require_key[k]
        value = args[key]

        if nil == value then
            return false
        elseif "string" == type(value) and #value == 0 then
            return false
        end
    end

    return true
end


function check_body_table(args, require_key)
  if not args or type(args) ~= "table" then
    return false
  end

  for k, _ in pairs(require_key) do
    if args[k] == nil then
      return false
    end
  end
  return true
end


function split(str, pat)
   local t = {}
   if str == '' or str == nil then
       return t
   end

   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         --print(cap)
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end


function trim(str)
  return str:match "^%s*(.-)%s*$"
end


function is_table_equal(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end

    if ty1 ~= "table" and ty2 ~= "table" then return t1 == t2 end
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not is_table_equal(v1,v2) then return false end
    end
    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not is_table_equal(v1, v2) then return false end
    end
    return true

end


function get_data_with_cache( opts, fun, ... )
  local ngx_dict_name = "cache_ngx"
  -- get from cache
  local cache_ngx = ngx.shared[ngx_dict_name]
  local values = cache_ngx:get(opts.key)
  if values then
    values = json_decode(values)
    return values.res, values.err
  end
  -- cache miss!
  local lock = lock:new(ngx_dict_name, opts.lock)
  local elapsed, err = lock:lock("lock_" .. opts.key)
  if not elapsed then
    return nil, "get data with cache lock fail err: " .. err
  end
  -- someone might have already put the value into the cache
  -- so we check it here again:
  values = cache_ngx:get(opts.key)
  if values then
    lock:unlock()

    values = json_decode(values)
    return values.res, values.err
  end
  -- get data
  local exp_time = opts.exp_time or 0 -- default 0s mean forever
  local res, err = fun(...)
  if err then
    -- use the old cache at first
    values = cache_ngx:get_stale(opts.key)
    if values then
      values = json_decode(values)
      res, err = values.res, values.err
    end

    exp_time = opts.exp_time_fail or exp_time
  else
    exp_time = opts.exp_time_succ or exp_time
  end

  --  update the shm cache with the newly fetched value
  if tonumber(exp_time) >= 0 then
    cache_ngx:set(opts.key, json_encode({res=res, err=err}), exp_time)
  end
  lock:unlock()
  return res, err
end
