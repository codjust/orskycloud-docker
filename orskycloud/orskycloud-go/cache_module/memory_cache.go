package cache_module

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/cache"
	//"github.com/astaxie/beego/cache/redis"
	"os"
	"time"
)

var bm cache.Cache

func init() {
	var err error
	//bm, err = cache.NewCache("redis", `{"key":"local","conn":"127.0.0.1:6039","dbNum":"0"}`) //{conn":"127.0.0.1:6039"}
	bm, err = cache.NewCache("memory", `{"interval":60}`)
	if err != nil {
		beego.Debug("create cache failed.")
		os.Exit(1)
	}
}

func PutData() {
	bm.Put("test", "xxxxxxx", 10)
}

func Get() string {
	data := bm.Get("test")
	return data.(string)
}

func IsExistCache(key string) bool {
	return bm.IsExist(key)
}

func PutCache(key string, val interface{}, timeout time.Duration) error {
	return bm.Put(key, val, timeout)
}

//Get(key string) interface{}
func GetCache(key string) interface{} {
	return bm.Get(key)
}

func DeleteCache(key string) {
	if IsExistCache(key) {
		err := bm.Delete(key)
		if err != nil {
			beego.Debug("delete cache failed.cache name:", key)
			os.Exit(1)
		}
	} else {
		beego.Debug("cache not exist")
	}

}
