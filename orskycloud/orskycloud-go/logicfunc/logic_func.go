package logicfunc

import (
	"github.com/astaxie/beego"
	"orskycloud-go/models"
)

func GetHomePage(username, password string) string {
	beego.Debug("logic:", username, password)
	last_login_time := models.ReturnHomePage(username, password)
	return last_login_time
}
