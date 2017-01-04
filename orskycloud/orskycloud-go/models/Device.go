package models

import (
	//"encoding/json"
	"github.com/astaxie/beego"
	"github.com/bitly/go-simplejson" // for json get
	"orskycloud-go/cache_module"
	"orskycloud-go/comm"
	"orskycloud-go/utils"
	"strings"
	"time"
)

type Device struct {
	ID          string
	DevName     string
	Description string
	CreateTime  string
}

type DeviceJson struct {
	deviceName  string
	description string
	createTime  string
	Sensor      []*Device
	data        []*Device
}

func ReturnAllDevices(username, password string) ([]Device, int) {
	client, err := red.Get()
	ErrHandlr(err)
	var devices []Device
	var device Device
	count := 0
	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	device_list_temp, _ := client.Cmd("hget", "uid:"+userkey, "device").Str()
	devices_list := strings.Split(device_list_temp, "#")
	for _, dev := range devices_list {
		beego.Debug("dev:", dev)
		count++
		dev_info, _ := client.Cmd("hget", "uid:"+userkey, "did:"+dev).Str()
		dev_json, err := simplejson.NewJson([]byte(dev_info))
		beego.Debug("error:", err)
		ErrHandlr(err)
		device.ID = dev
		device.DevName, err = dev_json.Get("deviceName").String()
		ErrHandlr(err)
		device.Description, err = dev_json.Get("description").String()
		ErrHandlr(err)
		device.CreateTime, err = dev_json.Get("createTime").String()
		ErrHandlr(err)
		devices = append(devices, device)
	}
	red.Put(client)
	beego.Debug("device[0]:", devices[0])
	return devices, count
}

func PageDevice(pageNo int, username string, password string) utils.Page {
	devices, tp, count, pageSize := ReturnDeviceCacheData(username, password, pageNo)
	//beego.Debug("dev:", devices, pageNo)
	return utils.Page{PageNo: pageNo, PageSize: pageSize, TotalPage: tp, TotalCount: count, FirstPage: pageNo == 1, LastPage: pageNo == tp, List: devices}
}

func ReturnDeviceCacheData(username string, password string, pageNum int) (interface{}, int, int, int) {
	key := beego.AppConfig.String("cache.device.key")
	pageSize, _ := beego.AppConfig.Int("page.size")
	var tp int //total page
	var ret_count int
	if cache_module.IsExistCache(key) == false {
		beego.Debug("Not Cache")
		dev_list, count := ReturnAllDevices(username, password)
		ret_count = count
		tp = count / pageSize
		lastPageSize := 0
		if count%pageSize > 0 {
			tp = count/pageSize + 1
			lastPageSize = count % pageSize
		}

		cacheDevice := make([][]Device, tp)
		for i := 0; i < tp; i++ {
			if i == (tp-1) && lastPageSize != 0 {
				cacheDevice[i] = make([]Device, lastPageSize)
				temp := dev_list[(i * pageSize):(i*pageSize + lastPageSize)]
				copy(cacheDevice[i], temp)
			} else {
				cacheDevice[i] = make([]Device, pageSize)
				temp := dev_list[(i * pageSize):(i*pageSize + pageSize)]
				copy(cacheDevice[i], temp)
			}
		}
		cache_module.PutCache(key, cacheDevice, 1000*1000)
	}

	devices := cache_module.GetCache(key).([][]Device)
	return devices[pageNum-1], tp, ret_count, pageSize
}

//判断是否有设备存在
func IsExistDevice(username, password string) bool {
	client, err := red.Get()
	ErrHandlr(err)
	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	device_list_temp, _ := client.Cmd("hget", "uid:"+userkey, "device").Str()
	red.Put(client)
	if device_list_temp == "" {
		return true
	} else {
		return false
	}
}

func CreateNewDevice(username string, password string, dev_info Device) string {
	localtime := time.Now().Format("2006-01-02 15:04:05")
	//	exp_data := DeviceJson{deviceName: dev_info.DevName, description: dev_info.Description, createTime: localtime, Sensor: []*Device{}, data: []*Device{}}
	//	exp_json, _ := json.Marshal(exp_data)

	exp_json := "{\"deviceName\":\"" + dev_info.DevName + "\",\"description\":\"" + dev_info.Description + "\",\"createTime\":\"" + localtime + "\",\"Sensor\":[],\"data\":[]}"

	beego.Debug("json:", exp_json)
	client, err := red.Get()
	ErrHandlr(err)
	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	// get did
	did := client.Cmd("hincrby", "uid:"+userkey, "nextDeviceId", 1).String()
	did = comm.Md5_go(did)
	device_list := client.Cmd("hget", "uid:"+userkey, "device").String()
	beego.Debug("device_list:", len(device_list))
	if len(device_list) < 32 {
		device_list = did
	} else {
		device_list = device_list + "#" + did
	}
	client.Cmd("multi")
	client.Cmd("hset", "uid:"+userkey, "device", device_list)
	client.Cmd("hset", "uid:"+userkey, "did:"+did, exp_json)
	client.Cmd("hincrby", "uid:"+userkey, "count", 1)
	ret := client.Cmd("exec").String()
	red.Put(client)
	var ret_msg string
	ret_msg = "success"
	if ret == "" {
		ret_msg = "failed"
		//ErrHandlr("redis exec failed!")
	}
	return ret_msg
}

func DeleteDeviceOp(username string, password string, did string) string {
	client, err := red.Get()
	ErrHandlr(err)

	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	device_list_temp, _ := client.Cmd("hget", "uid:"+userkey, "device").Str()
	devices_list := strings.Split(device_list_temp, "#")
	var dev_temp string
	for _, dev_id := range devices_list {
		if dev_id != did {
			if dev_temp == "" {
				dev_temp = dev_id
			} else {
				dev_temp = dev_temp + "#" + dev_id
			}
		}
	}
	beego.Debug("delete did:", did)
	beego.Debug("newDevicelist:", dev_temp)
	client.Cmd("multi")
	r := client.Cmd("hset", "uid:"+userkey, "device", dev_temp)
	beego.Debug("op key dev:", "hset "+"uid:"+userkey+"device "+dev_temp)
	ErrHandlr(r.Err)
	r = client.Cmd("hdel", "uid:"+userkey, "did:"+did)
	ErrHandlr(r.Err)
	r = client.Cmd("hincrby", "uid:"+userkey, "count", -1)
	ErrHandlr(r.Err)
	ret := client.Cmd("exec").String()
	beego.Debug("exec ret:", ret)
	red.Put(client)

	//删除数据库数据之后同时需要删除缓存，下次重新载入
	cache_key := beego.AppConfig.String("cache.device.key")
	cache_module.DeleteCache(cache_key)

	var ret_msg string
	ret_msg = "success"
	if ret == "" {
		ret_msg = "failed"
		//ErrHandlr("redis exec failed!")
	}
	return ret_msg

}

func ReturnByIdDeviceInfo(username string, password string, did string) Device {
	client, err := red.Get()
	ErrHandlr(err)

	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+did).String()
	dev_json, err := simplejson.NewJson([]byte(dev_info))
	beego.Debug("error:", err)
	ErrHandlr(err)
	var device Device
	device.DevName, err = dev_json.Get("deviceName").String()
	ErrHandlr(err)
	device.Description, err = dev_json.Get("description").String()
	ErrHandlr(err)
	red.Put(client)

	return device
}

func UpdateDeviceInfo(username string, password string, dev_info Device) string {
	client, err := red.Get()
	ErrHandlr(err)

	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	deviceInfo := client.Cmd("hget", "uid:"+userkey, "did:"+dev_info.ID).String()
	dev_json, err := simplejson.NewJson([]byte(deviceInfo))
	beego.Debug("error:", err)
	ErrHandlr(err)
	dev_json.Set("deviceName", dev_info.DevName)
	dev_json.Set("description", dev_info.Description)

	new_dev, err := dev_json.MarshalJSON()
	ErrHandlr(err)

	r := client.Cmd("hset", "uid:"+userkey, "did:"+dev_info.ID, new_dev)
	ret_msg := "success"
	if r.Err != nil {
		ret_msg = "failed"
	}
	red.Put(client)
	return ret_msg
}
