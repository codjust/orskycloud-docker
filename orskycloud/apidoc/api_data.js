define({ "api": [
  {
    "type": "POST",
    "url": "http://hcwzq.cn/api/addnewdevice.json?uid=***",
    "title": "addnewdevice",
    "name": "addnewdevice",
    "group": "All",
    "version": "1.0.1",
    "description": "<p>添加新设备</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "uid",
            "description": "<p>唯一ID，32位md5值</p>"
          },
          {
            "group": "Parameter",
            "type": "json",
            "optional": false,
            "field": "request",
            "description": "<p>请求体，需要添加的设备信息添加到请求体中</p>"
          },
          {
            "group": "Parameter",
            "type": "json",
            "optional": false,
            "field": "response",
            "description": "<p>响应数据</p>"
          }
        ],
        "request": [
          {
            "group": "request",
            "type": "string",
            "optional": false,
            "field": "sensor",
            "description": "<p>传感器标识</p>"
          },
          {
            "group": "request",
            "type": "string",
            "optional": false,
            "field": "value",
            "description": "<p>数据值，数据类型可以是int,string等</p>"
          }
        ],
        "response": [
          {
            "group": "response",
            "type": "string",
            "optional": false,
            "field": "Message",
            "description": "<p>响应信息，接口请求success或failed返回相关信息</p>"
          },
          {
            "group": "response",
            "type": "bool",
            "optional": false,
            "field": "Successful",
            "description": "<p>是否成功。通过该字段可以判断请求是否到达.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Example:",
          "content": "POST http://hcwzq.cn/api/addnewdevice.json?uid=c81e728d9d4c2f636f067f89cc14862c\n{\n    \"deviceName\": \"TestDevice\",\n    \"description\" : \"This is a new device.\"\n   \n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n\"Message\":\"add device success\",\n\"Successful\":true\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 200 OK  \n{\n    \"Successful\":false,\n    \"Message\": \"add device failed.\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "api/addnewdevice.lua",
    "groupTitle": "All"
  },
  {
    "type": "POST",
    "url": "http://hcwzq.cn/api/addnewsensor.json?uid=***&did=***",
    "title": "addnewsensor",
    "name": "addnewsensor",
    "group": "All",
    "version": "1.0.1",
    "description": "<p>添加新传感器</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "uid",
            "description": "<p>唯一用户ID，32位md5值</p>"
          },
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "did",
            "description": "<p>唯一设备ID，32位md5值</p>"
          },
          {
            "group": "Parameter",
            "type": "json",
            "optional": false,
            "field": "request",
            "description": "<p>请求体，需要添加的传感器信息插入到请求体中</p>"
          },
          {
            "group": "Parameter",
            "type": "json",
            "optional": false,
            "field": "response",
            "description": "<p>响应数据</p>"
          }
        ],
        "request": [
          {
            "group": "request",
            "type": "string",
            "optional": false,
            "field": "sensor",
            "description": "<p>传感器标识</p>"
          },
          {
            "group": "request",
            "type": "string",
            "optional": false,
            "field": "value",
            "description": "<p>数据值，数据类型可以是int,string等</p>"
          }
        ],
        "response": [
          {
            "group": "response",
            "type": "string",
            "optional": false,
            "field": "Message",
            "description": "<p>响应信息，接口请求success或failed返回相关信息</p>"
          },
          {
            "group": "response",
            "type": "bool",
            "optional": false,
            "field": "Successful",
            "description": "<p>是否成功。通过该字段可以判断请求是否到达.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Example:",
          "content": "POST http://hcwzq.cn/api/addnewsensor.json?uid=c81e728d9d4c2f636f067f89cc14862c&did=eccbc87e4b5ce2fe28308fd9f2a7baf3\n{\n    \"name\": \"TestSensor\",\n    \"unit\" : \"M\",\n    \"designation\":\"测试传感器\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n\"Message\":\"add sensor success\",\n\"Successful\":true\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 200 OK  \n{\n    \"Successful\":false,\n    \"Message\": \"sensor alreadey exist\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "api/addnewsensor.lua",
    "groupTitle": "All"
  },
  {
    "type": "POST",
    "url": "http://hcwzq.cn/api/getDeviceData.json?uid=*&did=*[&StartTime=*][&EndTime=*]",
    "title": "getDeviceData",
    "name": "getDeviceData",
    "group": "All",
    "version": "1.0.1",
    "description": "<p>获取指定设备的全部传感器数据</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "uid",
            "description": "<p>唯一ID值，32位md5</p>"
          },
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "did",
            "description": "<p>唯一设备ID值，32位md5</p>"
          },
          {
            "group": "Parameter",
            "type": "string",
            "optional": true,
            "field": "StartTime",
            "description": "<p>选择数据区间，开始时间，默认：2015-09-01 00:00:00，格式：2015-09-01 00:00:00</p>"
          },
          {
            "group": "Parameter",
            "type": "string",
            "optional": true,
            "field": "EndTime",
            "description": "<p>选择数据区间，结束时间，默认：当前时间，格式：2015-09-01 00:00:00</p>"
          },
          {
            "group": "Parameter",
            "type": "json",
            "optional": false,
            "field": "response",
            "description": "<p>响应数据</p>"
          }
        ],
        "response": [
          {
            "group": "response",
            "type": "string",
            "optional": false,
            "field": "Message",
            "description": "<p>响应信息，接口请求success或failed返回相关信息</p>"
          },
          {
            "group": "response",
            "type": "bool",
            "optional": false,
            "field": "Successful",
            "description": "<p>是否成功。通过该字段可以判断请求是否到达.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Example:",
          "content": "POST http://hcwzq.cn/api/getDeviceData.json?uid=c81e728d9d4c2f636f067f89cc14862c&did=eccbc87e4b5ce2fe28308fd9f2a7baf3&StartTime=2016-09-01 00:00:00&EndTime=2016-10-01 00:00:00",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n\"1\":[{\n\t\"timestamp\":\"2016-10-20 14:50:30\",\n\t\"sensor\":\"weight\",\n\t\"value\":56\n}],\n\"Message\":\"success\",\n\"Successful\":true\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 200 OK  \n{\n    \"Successful\":false,\n    \"Message\": \"uid error or did error or not exist\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "api/getDeviceData.lua",
    "groupTitle": "All"
  },
  {
    "type": "POST",
    "url": "http://hcwzq.cn/api/getalldevicesensor.json?uid=*",
    "title": "getalldevicesensor",
    "name": "getalldevicesensor",
    "group": "All",
    "version": "1.0.1",
    "description": "<p>获取用户所有设备和传感器信息</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "uid",
            "description": "<p>唯一ID，32位md5值</p>"
          },
          {
            "group": "Parameter",
            "type": "json",
            "optional": false,
            "field": "response",
            "description": "<p>响应数据</p>"
          }
        ],
        "response": [
          {
            "group": "response",
            "type": "string",
            "optional": false,
            "field": "Message",
            "description": "<p>响应信息，接口请求success或failed返回相关信息</p>"
          },
          {
            "group": "response",
            "type": "bool",
            "optional": false,
            "field": "Successful",
            "description": "<p>是否成功。通过该字段可以判断请求是否到达.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Example:",
          "content": "POST http://hcwzq.cn/api/getalldevicesensor.json?uid=c81e728d9d4c2f636f067f89cc14862c",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\"1\":[{\n\"createTime\":\"2016-12-19 23:07:12\",\n\"deviceName\":\"Test1\",\n\"description\":\"description1\",\n\"Sensor\":[{\n\"createTime\":\"2016-9-12 00:00:00\",\n\"unit\":\"kg\",\n\"name\":\"weight\",\n\"designation\":\"体重\"}]\n}],\n\"Message\":\"success\",\n\"Successful\":true\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 200 OK  \n{\n    \"Successful\":false,\n    \"Message\": \"Device not create yet\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "api/getalldevicesensor.lua",
    "groupTitle": "All"
  },
  {
    "type": "POST",
    "url": "http://hcwzq.cn/api/uploadData.json?uid=***&did=***",
    "title": "uploadData",
    "name": "uploadData",
    "group": "All",
    "version": "1.0.1",
    "description": "<p>上传指定设备的传感器数据</p>",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "uid",
            "description": "<p>唯一ID，32位md5值</p>"
          },
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "did",
            "description": "<p>唯一ID，32位md5值</p>"
          },
          {
            "group": "Parameter",
            "type": "json",
            "optional": false,
            "field": "request",
            "description": "<p>请求体，需要上传的数据添加到请求体中</p>"
          },
          {
            "group": "Parameter",
            "type": "json",
            "optional": false,
            "field": "response",
            "description": "<p>响应数据</p>"
          }
        ],
        "request": [
          {
            "group": "request",
            "type": "string",
            "optional": false,
            "field": "sensor",
            "description": "<p>传感器标识</p>"
          },
          {
            "group": "request",
            "type": "string",
            "optional": false,
            "field": "value",
            "description": "<p>数据值，数据类型可以是int,string等</p>"
          }
        ],
        "response": [
          {
            "group": "response",
            "type": "string",
            "optional": false,
            "field": "Message",
            "description": "<p>响应信息，接口请求success或failed返回相关信息</p>"
          },
          {
            "group": "response",
            "type": "bool",
            "optional": false,
            "field": "Successful",
            "description": "<p>是否成功。通过该字段可以判断请求是否到达.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Example:",
          "content": "POST http://hcwzq.cn/api/uploadData.json?uid=c81e728d9d4c2f636f067f89cc14862c&did=eccbc87e4b5ce2fe28308fd9f2a7baf3\n[\n    {\n        \"sensor\": \"weight\",\n        \"value\" : 59\n    },\n    {\n        \"sensor\": \"height\",\n        \"value\": \"12\"\n    }\n]",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n\"Message\":\"upload success\",\n\"Successful\":true\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 200 OK  \n{\n    \"Successful\":false,\n    \"Message\": \"device id not exist or user not exist\"\n}",
          "type": "json"
        }
      ]
    },
    "filename": "api/uploadData.lua",
    "groupTitle": "All"
  }
] });
