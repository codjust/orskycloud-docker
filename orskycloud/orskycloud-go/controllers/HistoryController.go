package controllers

import (
	"github.com/astaxie/beego"
	//"orskycloud-go/cache_module"
	//"orskycloud-go/logicfunc"
	"orskycloud-go/models"
	//	"os"
	//"strconv"
	//"time"
)

type HistoryController struct {
	beego.Controller
}

func (this *HistoryController) HistoryPage() {

	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	flag := models.IsExistDevice(username, password)
	var exp_data []models.DevSenList
	if flag != true {
		exp_data = models.GetDevSenList(username, password)
	}
	this.Data["Data"] = exp_data
	this.TplName = "historydata.tpl"
	this.Data["Active_History"] = "active"
	this.Layout = "layout/layout.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/history_scripts.tpl"
	this.Data["User"] = username
}

func (this *HistoryController) GetSensorList() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	Did := this.GetString("did")
	flag := models.IsExistDevice(username, password)
	var ret_data []models.S_List
	if flag != true {
		ret_data = models.GetSenSor(username, password, Did)
	}
	beego.Debug("ret_data", ret_data)
	this.Data["json"] = &ret_data
	this.ServeJSON()
}

func (this *HistoryController) GetHistoryData() {

	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	Did := this.GetString("did")
	Name := this.GetString("name")
	Start := this.GetString("start")
	End := this.GetString("end")
	Page := this.GetString("page")
	beego.Debug("Page:", Did, Name, Start, End, Page)
	result := models.GetHistory(username, password, Did, Name, Start, End, Page)
	beego.Debug("result:", result)
	this.Data["json"] = &result
	this.ServeJSON()
}

func (this *HistoryController) DeleteHistoryData() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	Did := this.GetString("did")
	Name := this.GetString("name")
	Start := this.GetString("start")
	End := this.GetString("end")
	beego.Debug("Page:", Did, Name, Start, End)

	res := models.DeleteSelectData(username, password, Did, Name, Start, End)
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}

func (this *HistoryController) HistoryTrend() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	flag := models.IsExistDevice(username, password)
	var exp_data []models.DevSenList
	if flag != true {
		beego.Debug("xxxxxxxx")
		exp_data = models.GetDevSenList(username, password)
	}
	this.Data["Data"] = exp_data
	this.TplName = "historytrend.tpl"
	this.Data["Active_Trend"] = "active"
	this.Layout = "layout/layout.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/trend_scripts.tpl"
	this.Data["User"] = username
}

func (this *HistoryController) HistoryTrendData() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	Did := this.GetString("did")
	Name := this.GetString("name")
	Start := this.GetString("start")
	End := this.GetString("end")
	//	Page := this.GetString("page")
	result := models.GetHistoryTrendData(username, password, Did, Name, Start, End)
	beego.Debug("result:", result)
	this.Data["json"] = &result
	this.ServeJSON()
}

func (this *HistoryController) DataCompare() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	flag := models.IsExistDevice(username, password)
	var exp_data []models.DevSenList
	if flag != true {
		exp_data = models.GetDevSenList(username, password)
	}
	this.Data["Data"] = exp_data
	this.TplName = "datacompare.tpl"
	this.Data["Active_Compare"] = "active"
	this.Layout = "layout/layout.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/datacompare_scripts.tpl"
	this.Data["User"] = username
}

func (this *HistoryController) AnalysisDataCompare() {
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	Did1 := this.GetString("did1")
	Did2 := this.GetString("did2")
	Name1 := this.GetString("name1")
	Name2 := this.GetString("name2")
	Start := this.GetString("start")
	End := this.GetString("end")

	result := models.GetAnalysisData(username, password, Did1, Did2, Name1, Name2, Start, End)
	beego.Debug("result:", result)
	this.Data["json"] = &result
	this.ServeJSON()
}
