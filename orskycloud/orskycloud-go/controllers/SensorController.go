package controllers

import (
	"github.com/astaxie/beego"
	//"orskycloud-go/cache_module"
	//"orskycloud-go/logicfunc"
	"orskycloud-go/models"
	"orskycloud-go/utils"
	"os"
	"strconv"
	"time"
)

type SensorController struct {
	beego.Controller
}

// "createTime": "2016-9-12 00:00:00",
//             "designation": "舒张压",
//             "name": "diastolic pressure",
//             "unit": "mmHg"

func (this *SensorController) MySensor() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	//this.Data["Page"] = page
	var pageNum int
	var err error
	if this.Ctx.Input.Param(":page") == "" {
		pageNum = 1
	} else {
		pageNum, err = strconv.Atoi(this.Ctx.Input.Param(":page"))
		if err != nil {
			beego.Debug("error:", err)
			os.Exit(1)
		}
	}
	flag := models.IsExistDevice(username, password)
	var sensors utils.Page
	if flag != true {
		flag = models.IsExistSensor(username, password)
		if flag == true {
			sensors = models.PageSensor(pageNum, username, password)
		}
	}
	this.Data["Page"] = sensors
	this.Data["Active_Sensor"] = "active"
	this.Layout = "layout/layout.tpl"
	this.TplName = "my_sensor.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/my_sensor_scripts.tpl"
	this.Data["User"] = username
}

func (this *SensorController) NewSensor() {
	//this.Data["Active_Sensor"] = "active"
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	d_list, err := models.ReturnDevList(username, password)
	if err != "" {
		res := struct {
			Val string
		}{"failed"}
		this.Data["json"] = &res
		this.ServeJSON()
	}

	beego.Debug("xxxxxxxxx")

	this.Data["DList"] = d_list
	this.Layout = "layout/layout.tpl"
	this.TplName = "newsensor.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/newsensor_scripts.tpl"
	this.Data["User"] = username

}

func (this *SensorController) CreateSensor() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	localtime := time.Now().Format("2006-01-02 15:04:05")
	var new_sensor models.Sensor
	new_sensor.Name = this.GetString("name")
	new_sensor.Designation = this.GetString("designation")
	new_sensor.Unit = this.GetString("unit")
	new_sensor.Did = this.GetString("did")
	new_sensor.CreateTime = localtime
	res := models.CreateNewSensor(username, password, new_sensor)
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}

func (this *SensorController) DeleteSensor() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	sensorName := this.GetString("name")
	Did := this.GetString("did")
	res := models.DeleteCurrentSensor(username, password, sensorName, Did)
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}

func (this *SensorController) EditSensor() {
	//data:{"name": Name,"designation": Designation, "did":Did, "unit": Unit}
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	s_name := this.GetString("name")
	did := this.GetString("did")

	s_info := models.ReturnSingalSensor(username, password, s_name, did)
	s_info.Did = did
	beego.Debug("did:", did)

	this.Data["Sensor"] = s_info
	this.Layout = "layout/layout.tpl"
	this.TplName = "editsensor.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/editsensor_scripts.tpl"
	this.Data["User"] = username
}

func (this *SensorController) EditModifySensor() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	var s_info models.Sensor

	s_info.Name = this.GetString("name")
	s_info.Designation = this.GetString("designation")
	s_info.Unit = this.GetString("unit")
	s_info.CreateTime = this.GetString("createTime")
	s_info.Did = this.GetString("did")

	res := models.ModifySensorInfo(username, password, s_info)
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}
