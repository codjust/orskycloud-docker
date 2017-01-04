package models

import (
	//"encoding/json"
	"github.com/astaxie/beego"
	"github.com/bitly/go-simplejson" // for json get
	//"orskycloud-go/cache_module"
	"orskycloud-go/comm"
	// "orskycloud-go/utils"
	"strings"
	// "time"
	"strconv"
)

type DevSenList struct {
	Did      string
	Dev_Name string
	S_Array  []Sensor
}

type HistoryData struct {
	Name        string //传感器标识
	Designation string //描述或者别名
	Timestamp   string //上传时间
	Value       string //值
	Unit        string //单位
}

func GetDevSenList(username string, password string) []DevSenList {
	client, err := red.Get()
	ErrHandlr(err)

	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()

	var ret_array []DevSenList
	var value DevSenList
	device_list_temp, _ := client.Cmd("hget", "uid:"+userkey, "device").Str()
	devices_list := strings.Split(device_list_temp, "#")
	for _, did := range devices_list {
		dev_info, _ := client.Cmd("hget", "uid:"+userkey, "did:"+did).Str()
		dev_json, err := simplejson.NewJson([]byte(dev_info))
		ErrHandlr(err)
		value.Dev_Name, err = dev_json.Get("deviceName").String()
		ErrHandlr(err)
		value.Did = did
		s_json := dev_json.Get("Sensor")
		if Get_json_array_len(s_json) == 0 {
			beego.Debug("Len:", Get_json_array_len(s_json))
			ret_array = append(ret_array, value)
			continue
		}
		var s_tmp Sensor
		for i := 0; i < Get_json_array_len(s_json); i++ {
			s_tmp.Name, _ = s_json.GetIndex(i).Get("name").String()
			value.S_Array = append(value.S_Array, s_tmp)
		}
		ret_array = append(ret_array, value)
	}
	red.Put(client)
	return ret_array
}

type S_List struct {
	Name        string
	Designation string
}

func GetSenSor(username string, password string, Did string) []S_List {
	client, err := red.Get()
	ErrHandlr(err)

	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+Did).String()
	dev_json, err := simplejson.NewJson([]byte(dev_info))
	ErrHandlr(err)
	s_json := dev_json.Get("Sensor")
	var s_list []S_List
	if Get_json_array_len(s_json) == 0 {
		beego.Debug("Len:", Get_json_array_len(s_json))
		return s_list
	}
	var s_tmp S_List
	for i := 0; i < Get_json_array_len(s_json); i++ {
		s_tmp.Name, _ = s_json.GetIndex(i).Get("name").String()
		s_tmp.Designation, _ = s_json.GetIndex(i).Get("designation").String()
		beego.Debug("Name:", s_tmp)
		s_list = append(s_list, s_tmp)
	}

	red.Put(client)

	return s_list
}

func ReturnSelectHistory(username, password, Did, Name, Start, End string) ([]HistoryData, int, bool) {
	client, err := red.Get()
	ErrHandlr(err)

	var IsEmpty bool
	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+Did).String()
	dev_json, err := simplejson.NewJson([]byte(dev_info))
	ErrHandlr(err)
	var Data []HistoryData
	var tmp_data HistoryData
	var designation string
	var unit string
	var Count = 0
	sensor_json := dev_json.Get("Sensor")
	for i := 0; i < Get_json_array_len(sensor_json); i++ {
		tmp, _ := sensor_json.GetIndex(i).Get("name").String()
		if tmp == Name {
			designation, _ = sensor_json.GetIndex(i).Get("designation").String()
			unit, _ = sensor_json.GetIndex(i).Get("unit").String()
			beego.Debug("ReturnSelectHistory:Designation", designation)
			break
		}
	}

	data_json := dev_json.Get("data")
	for i := 0; i < Get_json_array_len(data_json); i++ {
		tmp, _ := data_json.GetIndex(i).Get("sensor").String()
		beego.Debug("ReturnSelectHistory: Name", tmp)
		if tmp == Name {
			timestamp, _ := data_json.GetIndex(i).Get("timestamp").String()
			beego.Debug("ReturnSelectHistory:in for", i)
			if comm.CompareTime(Start, timestamp) == true && comm.CompareTime(timestamp, End) == true {
				//value, _ := data_json.GetIndex(i).Get("value").String()
				v_tmp, _ := data_json.GetIndex(i).Get("value").Int()
				value := strconv.Itoa(v_tmp)
				beego.Debug("ReturnSelectHistory:value", v_tmp)
				tmp_data.Name = Name
				tmp_data.Timestamp = timestamp
				tmp_data.Value = value
				tmp_data.Designation = designation
				tmp_data.Unit = unit
				Data = append(Data, tmp_data) //save value
				beego.Debug("ReturnSelectHistory:tmp_data", tmp_data)
				Count++
			}
		}
	}

	if Count == 0 {
		IsEmpty = false //返回数据为空
	} else {
		IsEmpty = true
	}

	red.Put(client)
	return Data, Count, IsEmpty

}
func PaginationSelectData(username, password, Did, Name, Start, End string, Page int) ([]HistoryData, int, int, bool) {
	//key := beego.AppConfig.String("cache.historydata.key")
	pageSize, _ := beego.AppConfig.Int("history.page.size")
	var tp int //total page
	//if cache_module.IsExistCache(key) == false {
	beego.Debug("history data cache not exist.")
	Data, ret_count, IsEmpty := ReturnSelectHistory(username, password, Did, Name, Start, End)
	if IsEmpty == false {
		return Data, tp, ret_count, false
	}
	tp = ret_count / pageSize
	lastPageSize := 0
	if ret_count%pageSize > 0 {
		tp = ret_count/pageSize + 1
		lastPageSize = ret_count % pageSize
	}
	cacheHistoryData := make([][]HistoryData, tp)
	for i := 0; i < tp; i++ {
		if i == (tp-1) && lastPageSize != 0 {
			cacheHistoryData[i] = make([]HistoryData, lastPageSize)
			temp := Data[(i * pageSize):(i*pageSize + lastPageSize)]
			copy(cacheHistoryData[i], temp)
		} else {
			cacheHistoryData[i] = make([]HistoryData, pageSize)
			temp := Data[(i * pageSize):(i*pageSize + pageSize)]
			copy(cacheHistoryData[i], temp)
		}
	}
	//cache_module.PutCache(key, cacheHistoryData, 1000*1000)
	//}
	ret_data := cacheHistoryData
	return ret_data[Page-1], tp, ret_count, true
}

type Pagination struct {
	IsEmpty     bool
	TotalPage   int
	CurrentPage int
	Count       int
	Data        []HistoryData
}

func GetHistory(username, password, Did, Name, Start, End string, Page string) Pagination {

	page, _ := strconv.Atoi(Page)
	//返回的数据：CurrentPage, TotalPage, 选中页的数据
	data, totalpage, count, isempty := PaginationSelectData(username, password, Did, Name, Start, End, page)

	ret_data := Pagination{isempty, totalpage, page, count, data}

	beego.Debug("GetHistory:ret_data->:", ret_data)
	return ret_data
}

func DeleteSelectData(username, password, Did, Name, Start, End string) string {
	var Ret_Data []map[string]interface{}
	var ret_msg string
	var IsEmpty bool
	var fin_data []byte
	IsEmpty = true
	client, err := red.Get()
	ErrHandlr(err)

	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	dev_info := client.Cmd("hget", "uid:"+userkey, "did:"+Did).String()
	dev_json, err := simplejson.NewJson([]byte(dev_info))
	ErrHandlr(err)

	data_json := dev_json.Get("data")
	StrLen := Get_json_array_len(data_json)
	if StrLen == 0 {
		IsEmpty = true
		ret_msg = "empty"
		goto End
	}
	for i := 0; i < StrLen; i++ {
		sensor, _ := data_json.GetIndex(i).Get("sensor").String()
		timestamp, _ := data_json.GetIndex(i).Get("timestamp").String()
		if sensor == Name && comm.CompareTime(Start, timestamp) == true && comm.CompareTime(timestamp, End) == true {
			beego.Debug("Query redis data ... ")
			IsEmpty = false
			break
		}
	}
	if IsEmpty == true {
		ret_msg = "empty"
		goto End
	}

	for i := 0; i < StrLen; i++ {
		sensor, _ := data_json.GetIndex(i).Get("sensor").String()
		timestamp, _ := data_json.GetIndex(i).Get("timestamp").String()
		if sensor == Name && comm.CompareTime(Start, timestamp) == true && comm.CompareTime(timestamp, End) == true {
			continue
		}
		element := make(map[string]interface{})
		element["sensor"], _ = data_json.GetIndex(i).Get("sensor").String()
		element["timestamp"], _ = data_json.GetIndex(i).Get("timestamp").String()
		element["value"], _ = data_json.GetIndex(i).Get("value").Int()
		Ret_Data = append(Ret_Data, element)

	}

	if len(Ret_Data) != 0 {
		dev_json.Set("data", Ret_Data)
	} else {
		element := make(map[string]interface{})
		Ret_Data = append(Ret_Data, element)
		dev_json.Set("data", Ret_Data)
	}

	fin_data, err = dev_json.MarshalJSON()
	if err == nil {
		r := client.Cmd("hset", "uid:"+userkey, "did:"+Did, fin_data)
		if r.Err != nil {
			ret_msg = "failed"
		} else {
			ret_msg = "success"
		}
	} else {
		ErrHandlr(err)
	}
End:
	red.Put(client)
	//beego.Debug("Nothing happen", IsEmpty)
	return ret_msg
}

type TrendData struct {
	IsEmpty bool
	Count   int
	ExpData []HistoryData
}

func GetHistoryTrendData(username, password, Did, Name, Start, End string) TrendData {
	ExpData, Count, IsEmpty := ReturnSelectHistory(username, password, Did, Name, Start, End)

	ret_data := TrendData{IsEmpty, Count, ExpData}
	return ret_data
}

type CompareData struct {
	IsEmpty1      bool
	IsEmpty2      bool
	Count1        int
	Count2        int
	ExpDataFirst  []HistoryData
	ExpDataSecond []HistoryData
}

func GetAnalysisData(username, password, Did1, Did2, Name1, Name2, Start, End string) CompareData {
	ExpData1, Count1, IsEmpty1 := ReturnSelectHistory(username, password, Did1, Name1, Start, End)
	ExpData2, Count2, IsEmpty2 := ReturnSelectHistory(username, password, Did2, Name2, Start, End)

	ret_data := CompareData{IsEmpty1, IsEmpty2, Count1, Count2, ExpData1, ExpData2}

	return ret_data
}
