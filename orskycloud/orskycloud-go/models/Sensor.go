package models

import (
	//"encoding/json"
	"github.com/astaxie/beego"
	"github.com/bitly/go-simplejson" // for json get
	"orskycloud-go/cache_module"
	"orskycloud-go/utils"
	//"reflect"
	"orskycloud-go/comm"
	"strings"
)

type Sensor struct {
	Name        string
	Did         string
	Device      string
	Designation string
	Unit        string
	CreateTime  string
}

//临时设备信息结构体
type Dev_Temp struct {
	Did        string
	DeviceName string
}

func Get_json_array_len(data *simplejson.Json) int {
	data_arr, err := data.Array()
	if err != nil {
		panic(err.Error())
	}

	return len(data_arr)
}

func ReturnSensorInfo(username string, password string) ([]Sensor, int) {
	client, err := red.Get()
	ErrHandlr(err)

	var SensorInfo []Sensor
	var temp_sensor Sensor
	count := 0
	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	device_list_temp, _ := client.Cmd("hget", "uid:"+userkey, "device").Str()
	devices_list := strings.Split(device_list_temp, "#")
	for _, did := range devices_list {
		dev_info, _ := client.Cmd("hget", "uid:"+userkey, "did:"+did).Str()
		dev_json, err := simplejson.NewJson([]byte(dev_info))
		ErrHandlr(err)
		dev_name, _ := dev_json.Get("deviceName").String()
		sensor := dev_json.Get("Sensor")
		if Get_json_array_len(sensor) == 0 {
			beego.Debug("Len:", Get_json_array_len(sensor))
			continue
		}
		for i := 0; i < Get_json_array_len(sensor); i++ {
			Name_Temp, _ := sensor.GetIndex(i).Get("name").String()
			if Name_Temp == "" {
				continue
			}
			temp_sensor.Did = did
			temp_sensor.Device = dev_name
			temp_sensor.Name, _ = sensor.GetIndex(i).Get("name").String()
			temp_sensor.Designation, _ = sensor.GetIndex(i).Get("designation").String()
			temp_sensor.Unit, _ = sensor.GetIndex(i).Get("unit").String()
			temp_sensor.CreateTime, _ = sensor.GetIndex(i).Get("createTime").String()
			SensorInfo = append(SensorInfo, temp_sensor)
			//		beego.Debug("data1:", temp_sensor)
			count++
		}
	}
	red.Put(client)
	return SensorInfo, count

}

func IsExistSensor(username, password string) bool {
	_, Count := ReturnSensorInfo(username, password)
	if Count == 0 {
		return false
	} else {
		return true
	}
}

func ReturnSensorCacheData(username string, password string, pageNum int) (interface{}, int, int, int) {
	key := beego.AppConfig.String("cache.sensor.key")
	pageSize, _ := beego.AppConfig.Int("page.size")
	var tp int //total page
	var ret_count int
	if cache_module.IsExistCache(key) == false {
		beego.Debug("sensor cache not exist.")
		dev_list, count := ReturnSensorInfo(username, password)
		ret_count = count
		tp = count / pageSize
		lastPageSize := 0
		if count%pageSize > 0 {
			tp = count/pageSize + 1
			lastPageSize = count % pageSize
		}

		cacheDevice := make([][]Sensor, tp)
		for i := 0; i < tp; i++ {
			if i == (tp-1) && lastPageSize != 0 {
				cacheDevice[i] = make([]Sensor, lastPageSize)
				temp := dev_list[(i * pageSize):(i*pageSize + lastPageSize)]
				copy(cacheDevice[i], temp)
			} else {
				cacheDevice[i] = make([]Sensor, pageSize)
				temp := dev_list[(i * pageSize):(i*pageSize + pageSize)]
				copy(cacheDevice[i], temp)
			}
		}
		cache_module.PutCache(key, cacheDevice, 1000*1000)
	}

	devices := cache_module.GetCache(key).([][]Sensor)
	return devices[pageNum-1], tp, ret_count, pageSize
}

func PageSensor(pageNo int, username string, password string) utils.Page {
	sensors, tp, count, pageSize := ReturnSensorCacheData(username, password, pageNo)
	beego.Debug("dev:", sensors, pageNo)
	return utils.Page{PageNo: pageNo, PageSize: pageSize, TotalPage: tp, TotalCount: count, FirstPage: pageNo == 1, LastPage: pageNo == tp, List: sensors}
}

func ReturnDevList(username, password string) ([]Dev_Temp, string) {
	client, err := red.Get()
	ErrHandlr(err)

	var d_list []Dev_Temp
	var dev_temp Dev_Temp
	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	device_list_temp, _ := client.Cmd("hget", "uid:"+userkey, "device").Str()
	if device_list_temp == "" {
		return d_list, "null"
	}
	devices_list := strings.Split(device_list_temp, "#")
	for _, v := range devices_list {
		dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+v).String()
		dev_json, err := simplejson.NewJson([]byte(dev_info))
		ErrHandlr(err)
		dev_temp.DeviceName, err = dev_json.Get("deviceName").String()
		ErrHandlr(err)
		dev_temp.Did = v
		d_list = append(d_list, dev_temp)
	}

	red.Put(client)
	return d_list, ""
}

func CreateNewSensor(username string, password string, sensor Sensor) string {
	client, err := red.Get()
	ErrHandlr(err)
	//key := username + "#" + password
	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+sensor.Did).String()
	dev_json, err := simplejson.NewJson([]byte(dev_info))
	ErrHandlr(err)
	sensorList := dev_json.Get("Sensor")

	var tb_sensor []map[string]interface{}
	var ret_msg string
	for i := 0; i < Get_json_array_len(sensorList); i++ {
		temp, _ := sensorList.GetIndex(i).Get("name").String()
		if sensor.Name == temp {
			ret_msg = "exist"
			red.Put(client)
			return ret_msg
		}
		if temp == "" {
			continue
		}
		element := make(map[string]interface{})
		element["name"], _ = sensorList.GetIndex(i).Get("name").String()
		element["unit"], _ = sensorList.GetIndex(i).Get("unit").String()
		element["designation"], _ = sensorList.GetIndex(i).Get("designation").String()
		element["createTime"], _ = sensorList.GetIndex(i).Get("createTime").String()
		tb_sensor = append(tb_sensor, element)
	}
	element := make(map[string]interface{})
	element["name"] = sensor.Name
	element["unit"] = sensor.Unit
	element["designation"] = sensor.Designation
	element["createTime"] = sensor.CreateTime
	//beego.Debug("sensor:1:", tb_sensor)
	tb_sensor = append(tb_sensor, element) //add new sensor
	dev_json.Set("Sensor", tb_sensor)

	//beego.Debug("Time:", sensor.CreateTime)
	//beego.Debug("sensor2::", tb_sensor)

	fin_data, err := dev_json.MarshalJSON()
	ErrHandlr(err)
	r := client.Cmd("hset", "uid:"+userkey, "did:"+sensor.Did, fin_data)
	if r.Err != nil {
		ret_msg = "failed"
	} else {
		ret_msg = "success"
	}
	red.Put(client)

	//清除下缓存
	cache_key := beego.AppConfig.String("cache.sensor.key")
	cache_module.DeleteCache(cache_key)

	return ret_msg
}

func DeleteCurrentSensor(username string, password string, name string, Did string) string {
	beego.Debug("sensor name:", name, Did)
	client, err := red.Get()
	ErrHandlr(err)
	//key := username + "#" + password
	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+Did).String()
	dev_json, err := simplejson.NewJson([]byte(dev_info))
	ErrHandlr(err)

	sensorList := dev_json.Get("Sensor")

	var tb_sensor []map[string]interface{}
	var ret_msg string
	str_len := Get_json_array_len(sensorList)
	for i := 0; i < str_len; i++ {
		temp, _ := sensorList.GetIndex(i).Get("name").String()
		if name != temp {
			element := make(map[string]interface{})
			element["name"], _ = sensorList.GetIndex(i).Get("name").String()
			element["unit"], _ = sensorList.GetIndex(i).Get("unit").String()
			element["designation"], _ = sensorList.GetIndex(i).Get("designation").String()
			element["createTime"], _ = sensorList.GetIndex(i).Get("createTime").String()
			tb_sensor = append(tb_sensor, element)
		}
		if str_len == 1 && name == temp {
			break
		}
	}
	beego.Debug("tb_sensor:", tb_sensor)
	if str_len == 1 {
		element := make(map[string]interface{})
		tb_sensor = append(tb_sensor, element)
		dev_json.Set("Sensor", tb_sensor)
	} else {
		dev_json.Set("Sensor", tb_sensor)
	}

	beego.Debug("dev_json:", dev_json)
	fin_data, err := dev_json.MarshalJSON()
	ErrHandlr(err)
	r := client.Cmd("hset", "uid:"+userkey, "did:"+Did, fin_data)
	if r.Err != nil {
		ret_msg = "failed"
	} else {
		ret_msg = "success"
	}
	red.Put(client)

	//清除下缓存
	cache_key := beego.AppConfig.String("cache.sensor.key")
	cache_module.DeleteCache(cache_key)
	//ret_msg = "success"
	return ret_msg
}

func ReturnSingalSensor(username string, password string, s_name string, s_did string) Sensor {
	client, err := red.Get()
	ErrHandlr(err)
	//key := username + "#" + password
	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+s_did).String()
	dev_json, err := simplejson.NewJson([]byte(dev_info))
	ErrHandlr(err)

	sensorList := dev_json.Get("Sensor")
	s_dev, _ := dev_json.Get("deviceName").String()
	var s_info Sensor
	str_len := Get_json_array_len(sensorList)
	for i := 0; i < str_len; i++ {
		temp, _ := sensorList.GetIndex(i).Get("name").String()
		if s_name == temp {
			s_info.Name, _ = sensorList.GetIndex(i).Get("name").String()
			s_info.Unit, _ = sensorList.GetIndex(i).Get("unit").String()
			s_info.Designation, _ = sensorList.GetIndex(i).Get("designation").String()
			s_info.CreateTime, _ = sensorList.GetIndex(i).Get("createTime").String()
			break
		}
	}
	s_info.Device = s_dev
	red.Put(client)
	return s_info
}

func ModifySensorInfo(username string, password string, s_info Sensor) string {
	client, err := red.Get()
	ErrHandlr(err)
	//key := username + "#" + password
	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+s_info.Did).String()
	dev_json, err := simplejson.NewJson([]byte(dev_info))
	ErrHandlr(err)
	sensorList := dev_json.Get("Sensor")

	var tb_sensor []map[string]interface{}
	var ret_msg string
	for i := 0; i < Get_json_array_len(sensorList); i++ {
		temp, _ := sensorList.GetIndex(i).Get("name").String()
		if temp == "" {
			continue
		}
		element := make(map[string]interface{})
		if s_info.Name == temp {
			element["name"] = s_info.Name
			element["unit"] = s_info.Unit
			element["designation"] = s_info.Designation
			element["createTime"] = s_info.CreateTime
		} else {
			element["name"], _ = sensorList.GetIndex(i).Get("name").String()
			element["unit"], _ = sensorList.GetIndex(i).Get("unit").String()
			element["designation"], _ = sensorList.GetIndex(i).Get("designation").String()
			element["createTime"], _ = sensorList.GetIndex(i).Get("createTime").String()
		}
		tb_sensor = append(tb_sensor, element)
	}
	dev_json.Set("Sensor", tb_sensor)

	fin_data, err := dev_json.MarshalJSON()
	ErrHandlr(err)
	r := client.Cmd("hset", "uid:"+userkey, "did:"+s_info.Did, fin_data)
	if r.Err != nil {
		ret_msg = "failed"
	} else {
		ret_msg = "success"
	}
	red.Put(client)

	//清除下缓存
	cache_key := beego.AppConfig.String("cache.sensor.key")
	cache_module.DeleteCache(cache_key)

	return ret_msg
}
