package models

import (
	"github.com/astaxie/beego"
	"orskycloud-go/comm"
)

type Profile struct {
	UserName string
	UserKey  string
	Phone    string
	EMail    string
	DevCount string
	SignTime string
}

func ReturnProfileInfo(username string, password string) Profile {
	client, err := red.Get()
	ErrHandlr(err)

	var ProfileInfo Profile
	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	ProfileInfo.UserName, _ = client.Cmd("hget", "uid:"+userkey, "username").Str()
	ProfileInfo.UserKey = userkey
	ProfileInfo.Phone, _ = client.Cmd("hget", "uid:"+userkey, "phone").Str()
	ProfileInfo.EMail, _ = client.Cmd("hget", "uid:"+userkey, "email").Str()
	ProfileInfo.DevCount, _ = client.Cmd("hget", "uid:"+userkey, "count").Str()
	ProfileInfo.SignTime, _ = client.Cmd("hget", "uid:"+userkey, "sign_up_time").Str()
	red.Put(client)

	return ProfileInfo
}

func UpdataProfileInfo(username string, password string, profile Profile) string {
	client, err := red.Get()
	ErrHandlr(err)

	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	newKey := profile.UserName + "#" + comm.Md5_go(password)
	client.Cmd("multi")
	r := client.Cmd("hset", "uid:"+userkey, "username", profile.UserName)
	ErrHandlr(r.Err)
	r = client.Cmd("hset", "uid:"+userkey, "phone", profile.Phone)
	ErrHandlr(r.Err)
	r = client.Cmd("hset", "uid:"+userkey, "email", profile.EMail)
	ErrHandlr(r.Err)
	r = client.Cmd("hdel", "User", key)
	ErrHandlr(r.Err)
	r = client.Cmd("hset", "User", newKey, userkey)
	ErrHandlr(r.Err)
	ret := client.Cmd("exec").String()
	beego.Debug("exec:", ret)
	red.Put(client)
	var ret_msg string
	ret_msg = "success"
	if ret == "" {
		ret_msg = "failed"
		//ErrHandlr("redis exec failed!")
	}
	return ret_msg
}

func ModifyPwd(username string, password string, newpwd string) string {
	client, err := red.Get()
	ErrHandlr(err)

	key := username + "#" + comm.Md5_go(password)
	//key := username + "#" + password
	userkey, _ := client.Cmd("hget", "User", key).Str()
	newKey := username + "#" + comm.Md5_go(newpwd)
	client.Cmd("multi")
	client.Cmd("hset", "uid:"+userkey, "password", newpwd)
	client.Cmd("hdel", "User", key)
	client.Cmd("hset", "User", newKey, userkey)
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
