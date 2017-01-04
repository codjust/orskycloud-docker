package controllers

import (
	"github.com/astaxie/beego"
	"orskycloud-go/models"
)

type ProfileController struct {
	beego.Controller
}

func (this *ProfileController) MyProfile() {

	username, password := this.GetSession("username").(string), this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	profile := models.ReturnProfileInfo(username, password)

	this.Data["Profile"] = profile
	this.Data["Active_Profile"] = "active"
	this.Layout = "layout/layout.tpl"
	this.TplName = "my_profile.tpl"
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/profile_script.tpl"
	this.Data["User"] = username
}

func (this *ProfileController) Update() {
	username, phone, email := this.GetString("username"), this.GetString("phone"), this.GetString("email")
	user, pwd := this.GetSession("username").(string), this.GetSession("password").(string)
	if user == "" {
		this.Redirect("/login", 301)
	}
	profile := models.Profile{UserName: username, Phone: phone, EMail: email}

	res := models.UpdataProfileInfo(user, pwd, profile)
	if res == "success" {
		//更新session
		this.SetSession("username", username)
	}
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}

func (this *ProfileController) UpdatePwd() {
	username := this.GetSession("username").(string)
	password := this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	this.Data["Active_UpdatePwd"] = "active"
	this.Layout = "layout/layout.tpl"
	this.TplName = "updatepwd.tpl"
	this.Data["Pwd"] = password
	this.LayoutSections = make(map[string]string)
	this.LayoutSections["Scripts"] = "scripts/updatepwd_scripts.tpl"
	this.Data["User"] = username
}

func (this *ProfileController) UpdatePwdModify() {
	username := this.GetSession("username").(string)
	password := this.GetSession("password").(string)
	if username == "" {
		this.Redirect("/login", 301)
	}
	newpwd := this.GetString("newpwd")

	res := models.ModifyPwd(username, password, newpwd)
	if res == "success" {
		//更新session
		this.SetSession("password", newpwd)
	}
	result := struct {
		Val string
	}{res}
	this.Data["json"] = &result
	this.ServeJSON()
}
