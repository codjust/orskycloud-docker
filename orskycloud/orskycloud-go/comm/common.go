package comm

import (
	"crypto/md5"
	"encoding/hex"
	"io"
	"strconv"
	"time"
)

func Md5_go(value interface{}) string {
	var str string
	switch value.(type) {
	case int:
		num, _ := value.(int)
		str = strconv.Itoa(num)
	case string:
		s, _ := value.(string)
		str = s
	}
	h := md5.New()
	io.WriteString(h, str)
	ret_md5 := h.Sum(nil)
	return hex.EncodeToString(ret_md5[:])
}

func CompareTime(T1 string, T2 string) bool {
	t1, err := time.Parse("2006-01-02 15:04:05", T1)
	t2, err := time.Parse("2006-01-02 15:04:05", T2)
	if err != nil {
		panic(err)
	}
	if t1.Before(t2) {
		return true
	} else {
		return false
	}
}
