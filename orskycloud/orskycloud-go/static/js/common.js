function SelectTime()
{
	var CurrentSelected = document.getElementById("select").value
	var myDate = new Date();
	myDate.getYear(); //获取当前年份(2位)
	Year = myDate.getFullYear();
	Month = myDate.getMonth() + 1; //获取当前月份(0-11,0代表1月)
	Day = myDate.getDate(); //获取当前日(1-31)

	Hour = myDate.getHours(); //获取当前小时数(0-23)
	Minute = myDate.getMinutes(); //获取当前分钟数(0-59)
	Second = myDate.getSeconds(); //获取当前秒数(0-59)

 /**
* 获取本周、本季度、本月、上月的开端日期、停止日期
*/
var now = new Date(); //当前日期
var nowDayOfWeek = now.getDay(); //今天本周的第几天
var nowDay = now.getDate(); //当前日
var nowMonth = now.getMonth(); //当前月
var nowYear = now.getYear(); //当前年
nowYear += (nowYear < 2000) ? 1900 : 0; //

var lastMonthDate = new Date(); //上月日期
lastMonthDate.setDate(1);
lastMonthDate.setMonth(lastMonthDate.getMonth()-1);
var lastYear = lastMonthDate.getYear();
var lastMonth = lastMonthDate.getMonth();

//格局化日期：yyyy-MM-dd
function formatDate(date) {
var myyear = date.getFullYear();
var mymonth = date.getMonth()+1;
var myweekday = date.getDate();
if(mymonth < 10){
mymonth = "0" + mymonth;
}
if(myweekday < 10){
myweekday = "0" + myweekday;
}
return (myyear+"-"+mymonth + "-" + myweekday);
}

//获得某月的天数
function getMonthDays(myMonth){
var monthStartDate = new Date(nowYear, myMonth, 1);
var monthEndDate = new Date(nowYear, myMonth + 1, 1);
var days = (monthEndDate - monthStartDate)/(1000 * 60 * 60 * 24);
return days;
}



//获得本周的开端日期
function getWeekStartDate() {
var weekStartDate = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek);
return formatDate(weekStartDate);
}

//获得本周的停止日期
function getWeekEndDate() {
var weekEndDate = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek));
return formatDate(weekEndDate);
}

//获得本月的开端日期
function getMonthStartDate(){
var monthStartDate = new Date(nowYear, nowMonth, 1);
return formatDate(monthStartDate);
}

//获得本月的停止日期
function getMonthEndDate(){
var monthEndDate = new Date(nowYear, nowMonth, getMonthDays(nowMonth));
return formatDate(monthEndDate);
}

//获得上月开端时候
function getLastMonthStartDate(){
var lastMonthStartDate = new Date(nowYear, lastMonth, 1);
return formatDate(lastMonthStartDate);
}

//获得上月停止时候
function getLastMonthEndDate(){
var lastMonthEndDate = new Date(nowYear, lastMonth, getMonthDays(lastMonth));
return formatDate(lastMonthEndDate);
}

function formatTime(Hour,Minute,Second){
    if(Hour < 10){
      Hour = "0" + Hour
    }
    if(Minute < 10){
      Minute = "0" + Minute
    }
    if(Second < 10){
      Second = "0" + Second
    }
    return Hour + ":" + Minute + ":" + Second
}

   var StartTime = "";
   var EndTime = "";
   switch(CurrentSelected)
   {
   	case "day":
      var TempDay = Day;
      if(Month < 10) {
        Month = "0" + Month;
      }
      if(Day < 10){
        Day = "0" + Day
      }
   		EndTime		= Year + "-" + Month + "-" + Day + " " +  formatTime(Hour,Minute,Second);
      TempDay = TempDay - 1 ;
      if(TempDay < 10 )
      {
        TempDay = "0" + TempDay;
      }
   		StartTime   = Year + "-" + Month + "-" + TempDay + " " + formatTime(Hour,Minute,Second);
   		document.getElementById("start").value = StartTime
   		document.getElementById("end").value = EndTime
   		break;
   	case "week":
   		StartTime = getWeekStartDate() + " " + formatTime(Hour,Minute,Second);
   		EndTime   = getWeekEndDate() + " " + formatTime(Hour,Minute,Second);
   		document.getElementById("start").value = StartTime
   		document.getElementById("end").value = EndTime
   		break;
   	case "month":
   		StartTime = getMonthStartDate() + " " + formatTime(Hour,Minute,Second);
   		EndTime   = getMonthEndDate() + " " + formatTime(Hour,Minute,Second);
   		document.getElementById("start").value = StartTime
   		document.getElementById("end").value = EndTime
   		break;
   	case "year":
        if(Month < 10) {
            Month = "0" + Month;
        }
        if(Day < 10){
            Day = "0" + Day
        }
   	    EndTime	= Year + "-" + Month + "-" + Day + " " +  formatTime(Hour,Minute,Second);
   	    EndTime = Year + "-" + Month + "-" + Day + " " + formatTime(Hour,Minute,Second);
   		Year = Year - 1;
   		StartTime   = Year + "-" + Month + "-" + Day + " " + formatTime(Hour,Minute,Second);
   		document.getElementById("start").value = StartTime
   		document.getElementById("end").value = EndTime
   		break;
   	case "self":
   		document.getElementById("start").value = ""
   		document.getElementById("end").value = ""
   		break;
   	default:
   		document.getElementById("start").value = StartTime
   		document.getElementById("end").value = EndTime
   		break;
   }
}


function AddSensorItem(did,select)
{
    var Did = document.getElementById(did).value;
    $.ajax({
            async: false,
            url: "/history/list",    //后台webservice里的方法名称
            type: "post",
            data:{"did": Did},
            traditional: true,
            success: function (data) {
                 var optionstring = "";
                for (var i in data) {
                    var jsonObj =data[i];
                        optionstring += "<option value=\"" + jsonObj.Name + "\" >" + jsonObj.Designation + "</option>";
                        $("#" + select).html("<option value='请选择'>请选择...</option> "+optionstring);
                    }
                },
                error: function (msg) {
                    alert("出错了！");
                }
    });
}
