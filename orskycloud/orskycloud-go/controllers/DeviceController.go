package controllers

import (
	"github.com/astaxie/beego"
	"orskycloud-go/models"
	"orskycloud-go/utils"
	"os"
	"strconv"
)

type DeviceController struct {
	beego.Controller
}

func (this *DeviceController) MyDevice() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}

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
	var page utils.Page
	if flag != true {
		page = models.PageDevice(pageNum, username, password)
	}
	// this.Data["Devices"] = devices
	this.Data["Page"] = page
	this.Data["Active_Dev"] = "active"
	this.Layout = "layout/layout.tpl"
	this.TplName = "my_device.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/my_device_scripts.tpl"
	this.Data["User"] = username

}

func (this *DeviceController) NewDevice() {
	//	this.Data["Page"] = page
	//	this.Data["Active_Dev"] = "active"
	username := this.GetSession("username").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}

	this.Layout = "layout/layout.tpl"
	this.TplName = "newdevice.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/newdevice_scripts.tpl"
	this.Data["User"] = username
}

func (this *DeviceController) CreateDevice() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	var newDevice models.Device
	newDevice.DevName = this.GetString("devicename")
	newDevice.Description = this.GetString("description")

	res := models.CreateNewDevice(username, password, newDevice)
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}

func (this *DeviceController) DeleteDevice() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	did := this.GetString("did")
	res := models.DeleteDeviceOp(username, password, did)
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}

func (this *DeviceController) EditDevice() {
	did := this.Ctx.Input.Param(":did")
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	ret_data := models.ReturnByIdDeviceInfo(username, password, did)

	ret_data.ID = did
	beego.Debug("ret_data:", ret_data)
	this.Data["DeviceName"] = ret_data.DevName
	this.Data["Description"] = ret_data.Description
	this.Data["Did"] = ret_data.ID
	this.Layout = "layout/layout.tpl"
	this.TplName = "editdevice.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/editdevice_scripts.tpl"
	this.Data["User"] = username

}

func (this *DeviceController) EditDeviceModify() {
	var dev models.Device
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	dev.DevName, dev.Description = this.GetString("devicename"), this.GetString("description")
	dev.ID = this.GetString("did")
	res := models.UpdateDeviceInfo(username, password, dev)
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}
