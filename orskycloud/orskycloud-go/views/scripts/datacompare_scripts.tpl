<script type="text/javascript" src="/static/js/common.js"></script>
<script type="text/javascript">

document.onload = AddSensorItem("did1", "s_name1")
document.onload = AddSensorItem("did2", "s_name2")
SelectTime()

function CreateCharts(data){
    var Arr1 = data.ExpDataFirst
    var Arr2 = data.ExpDataSecond
    // var value = new Array();
    // var timestrap = new Array();
    var name1
    var unit1
    unit1 = Arr1[0].Unit
    name1 = Arr1[0].Name
    designation1 = Arr1[0].Designation
    var Value1 = "{name:'" + designation1 + "',data:[";
    var Timestamp1 = "[";
    for(var i in Arr1)
    {
        var jsonObj = Arr1[i];
        Value1 += jsonObj.Value + ",";
        Timestamp1 += "'" + jsonObj.Timestamp + "',"
    }
    Value1 = Value1.substring(0, Value1.length - 1)
    Value1 = Value1 + "]}"
    Timestamp1 = Timestamp1.substring(0, Timestamp1.length - 1)
    Timestamp1 = Timestamp1 + "]"


    var name2
    var unit2
    unit2 = Arr2[0].Unit
    name2 = Arr2[0].Name
    designation2 = Arr2[0].Designation
    var Value2 = "{name:'" + designation2 + "',data:[";
    var Timestamp2 = "[";
    for(var i in Arr2)
    {
        var jsonObj = Arr2[i];
        Value2 += jsonObj.Value + ",";
        Timestamp2 += "'" + jsonObj.Timestamp + "',"
    }
    Value2 = Value2.substring(0, Value2.length - 1)
    Value2 = Value2 + "]}"
    Timestamp2 = Timestamp2.substring(0, Timestamp2.length - 1)
    Timestamp2 = Timestamp2 + "]"

    //x轴选取时间区间长度长的
    var Timestamp
    if(Timestamp1.length > Timestamp2.length)
    	Timestamp = Timestamp1;
   	else
   		Timestamp = Timestamp2;

    $(function () {
        $('#container').highcharts({
            title: {
                text: '历史数据对比图',
                x: -20 //center
            },
            subtitle: {
                text: 'Data comparison chart',
                x: -20
            },
            xAxis: {
                categories:  eval(Timestamp)
            },
            yAxis: {
                title: {
                    text: eval("'" + name1 + "(" + unit1 + ")/"+ name2 + "("+ unit2 + ")'")
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: eval("'" + unit1 + " or " + unit2 + "'")
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: eval("[" + Value1 + "," + Value2 + "]")
        });
});
}

function AnalysisDataTrend(){
	var did1  = document.getElementById("did1").value
    var name1 = document.getElementById("s_name1").value
    var did2  = document.getElementById("did2").value
    var name2 = document.getElementById("s_name2").value
    var start  = document.getElementById("start").value
    var end    = document.getElementById("end").value

    if(name1 == "请选择" || name2 == "请选择"){
        alert("请选择要查询的传感器！")
        return
    }
    //2015-12-11 19:27:57
    var pattern = /\d{4}-\d{2}-\d{2}\s?\d{2}:\d{2}:(\d+)/
    var r1 = pattern.test(start)
    var r2 = pattern.test(end)
    if(r1 == false || r2 == false)
    {
        alert("时间格式错误，请设置：2015-12-1 12:12:12")
        return;
    }

    $.ajax({
        async: false,
        url: "/history/compare/analysis",    //后台webservice里的方法名称
        type: "post",
        data:{"did1": did1,"did2":did2, "name1": name1, "name2":name2, "start":start, "end":end},
        traditional: true,
        success: function (data) {
            var Flag1  = data.IsEmpty1;
            var Flag2  = data.IsEmpty2;
            if(Flag1 == false || Flag2 == false) {
                alert("传感器数据为空或该时间段数据为空！，请重新选择！")
                return;
            }
            CreateCharts(data);
            },
        error: function (msg) {
                 alert("出错了！");
            }
    });


}

</script>