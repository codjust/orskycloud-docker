module(..., package.seeall)

local common = require("lua.comm.common")

-- 校验post data 传感器数据是否已添加
function check_data_sersor(rd_data,post_data)
	-- body
	local db_sensor = rd_data["Sensor"]
	if db_sensor == nil then
		return false
	end
	local equal_flag = false
	-- 有一个sensor不存在即返回false,这里可以优化
	for k, _ in pairs(post_data) do
		equal_flag = false
		for i, _ in pairs(db_sensor) do
			if post_data[k]["sensor"] == db_sensor[i]["name"] then
				equal_flag = true
			   	break
			end
		end
		if equal_flag == false then
			return false
		end
	end

	return true
end


function is_timestamp_compare(src_time,next_time)
	-- 这里默认时间格式都为  "2016-10-20 14:51:09"的形式，前面加格式检查
	local src_temp  = common.split(src_time,' ')
	local src_date  = src_temp[1]
	local src_time  = src_temp[2]

	local next_temp = common.split(next_time, ' ')
	local next_date = next_temp[1]
	local next_time = next_temp[2]

	src_temp  = common.split(src_date, "-")
	next_temp = common.split(next_date, "-")

	-- 实现lua的continue
	for i = 1, 3 do
		repeat
			if src_temp[i] > next_temp[i] then
				return true
			elseif src_temp[i] == next_temp[i] then
				break
			else
				return false
			end
		until true
	end

	src_temp  = common.split(src_time, ":")
	next_temp = common.split(next_time,":")
	for i = 1, 3 do
		repeat
			if src_temp[i] > next_temp[i] then
				return true
			elseif src_temp[i] == next_temp[i] then
				break
			else
				return false
			end
		until true
	end

	return false
end


function select_data(starttime,endtime,res_data)
	local response = {}
	for _, data in ipairs(res_data) do
		local first  = is_timestamp_compare(data["timestamp"], starttime[0])
		local second = is_timestamp_compare(data["timestamp"], endtime[0])
		if first and not second then
			table.insert(response, data)
		end
	end
	return response
end