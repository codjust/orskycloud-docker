package models

import (
	//"fmt"
	"github.com/astaxie/beego"
	"github.com/fzzy/radix/pool"
	//"github.com/fzzy/radix/redis"
	"orskycloud-go/comm"
	//"os"
	"time"
)

var (
	REDIS_HOST string
	REDIS_DB   int
	red        *pool.Pool
)
var e *beego.Controller

func ErrHandlr(err error) {
	if err != nil {
		beego.Debug("model op error:", err)
		e.Redirect("/login", 302)
		//os.Exit(1)
	}
}

func init() {
	REDIS_HOST = beego.AppConfig.String("redis.host")
	REDIS_DB, _ = beego.AppConfig.Int("REDIS_DB")

	var err error
	red, err = pool.NewPool("tcp", REDIS_HOST, 10)
	ErrHandlr(err)
}

func HandleRegist(username, password string) string {
	key := username + "#" + comm.Md5_go(password)
	client, err := red.Get()
	ErrHandlr(err)
	res, _ := client.Cmd("hget", "User", key).Str()
	if res != "" {
		return "exist"
	}
	client.Cmd("incr", "nextUserId").Str()
	uid_t, _ := client.Cmd("get", "nextUserId").Str()
	beego.Debug("uid_t:", uid_t)
	uid := comm.Md5_go(uid_t)
	beego.Debug("uid md5:", uid)
	UserList, err := client.Cmd("get", "UserList").Str()
	UserList = UserList + uid + "#"
	localtime := time.Now().Format("2006-01-02 15:04:05")
	client.Cmd("multi") //redis事务
	client.Cmd("set", "UserList", UserList)
	client.Cmd("hset", "User", key, uid)
	client.Cmd("incr", "UserCount")
	client.Cmd("hset", "uid:"+uid, "username", username)
	client.Cmd("hset", "uid:"+uid, "password", comm.Md5_go(password))
	client.Cmd("hset", "uid:"+uid, "sign_up_time", localtime)
	r := client.Cmd("exec")
	red.Put(client)
	if r.Err != nil {
		return "failed"
	} else {
		return "success"
	}
}

func HandleLogin(username, password string) string {
	key := username + "#" + comm.Md5_go(password)
	client, err := red.Get()
	ErrHandlr(err)

	res, _ := client.Cmd("hget", "User", key).Str()
	//更新一下登陆时间
	if res == "" {
		return "login failed"
	}
	red.Put(client)
	return "login success"
}

func ReturnHomePage(username, password string) string {
	client, err := red.Get()
	ErrHandlr(err)
	key := username + "#" + comm.Md5_go(password)
	userkey, _ := client.Cmd("hget", "User", key).Str()
	last_login_time, _ := client.Cmd("hget", "uid:"+userkey, "last_login_time").Str()
	//更新登陆时间
	localtime := time.Now().Format("2006-01-02 15:04:05")
	r := client.Cmd("hset", "uid:"+userkey, "last_login_time", localtime)
	if r.Err != nil {
		return "login failed"
	}
	red.Put(client)
	return last_login_time
}
