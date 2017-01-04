package controllers

import (
	"github.com/astaxie/beego"
	"orskycloud-go/cache_module"
	//"orskycloud-go/logicfunc"
	"orskycloud-go/models"
	//"os"
	//"strconv"
)

type HomePageController struct {
	beego.Controller
}

func (this *HomePageController) HomePage() {
	//这里要判断一下是否登录isLogin
	//this.SetSession("username", "John")
	//this.SetSession("password", "1234567")
	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	beego.Debug(username, password)
	last_logic_time := models.ReturnHomePage(username, password)
	beego.Debug("time:", last_logic_time)
	this.Data["Last_login_time"] = last_logic_time
	this.Data["User"] = username
	this.Layout = "layout/layout.tpl"
	this.TplName = "homepage.html"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/home_scripts.tpl"
}

func (this *HomePageController) MyCache() {
	cache_module.PutData()
	beego.Debug("data:", cache_module.Get())
}
