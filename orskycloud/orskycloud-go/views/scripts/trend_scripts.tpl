<script type="text/javascript" src="/static/js/common.js"></script>
<script type="text/javascript">

document.onload = AddSensorItem("did", "s_name")  //页面加载完自动执行此方法
SelectTime()

function CreateCharts(data){
    var Arr = data.ExpData
    // var value = new Array();
    // var timestrap = new Array();
    var name
    var unit
    unit = Arr[0].Unit
    name = Arr[0].Name
    designation = Arr[0].Designation
    var Value = "{name:'" + designation + "',data:[";
    var Timestamp = "[";
    for(var i in Arr)
    {
        var jsonObj = Arr[i];
        Value += jsonObj.Value + ",";
        Timestamp += "'" + jsonObj.Timestamp + "',"
    }
    Value = Value.substring(0, Value.length - 1)
    Value = Value + "]}"
    Timestamp = Timestamp.substring(0, Timestamp.length - 1)
    Timestamp = Timestamp + "]"
    $(function () {
        $('#container').highcharts({
            title: {
                text: '历史数据走势图',
                x: -20 //center
            },
            subtitle: {
                text: 'Historical data charts',
                x: -20
            },
            xAxis: {
                categories:  eval(Timestamp)
            },
            yAxis: {
                title: {
                    text: eval("'" + name +"(" + unit + ")'")
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: eval("'" + unit + "'")
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: eval("[" + Value + "]")
        });
});

}


function SearchHistoryTrend(){
    var h_did  = document.getElementById("did").value
    var h_name = document.getElementById("s_name").value
    var start  = document.getElementById("start").value
    var end    = document.getElementById("end").value

    if(h_name == "请选择"){
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
        url: "/history/trend/data",    //后台webservice里的方法名称
        type: "post",
        data:{"did": h_did, "name": h_name, "start":start, "end":end},
        traditional: true,
        success: function (data) {
            var Flag  = data.IsEmpty;
            if(Flag == false) {
                alert("该传感器数据为空或该时间段时间为空！")
                return;
            }
            CreateCharts(data);
            },
        error: function (msg) {
                 alert("出错了！");
            }
     });
}
// $(function () {
// var title = {
//       text: '城市平均气温'
//    };
//    var subtitle = {
//       text: 'Source: web3.xin'
//    };
//    var xAxis = {
//       categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
//    };
//    var yAxis = {
//       title: {
//          text: 'Temperature (\xB0C)'
//       },
//       plotLines: [{
//          value: 0,
//          width: 1,
//          color: '#808080'
//       }]
//    };

//    var tooltip = {
//       valueSuffix: '\xB0C'
//    }

//    var legend = {
//       layout: 'vertical',
//       align: 'right',
//       verticalAlign: 'middle',
//       borderWidth: 0
//    };

//    var series =  [
//       {
//          name: 'Tokyo',
//          data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6, 56,34,43,43,43,7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6, 56,34,43,43,43,7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6, 56,34,43,43,43,7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6, 56,34,43,43,43,7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6, 56,34,43,43,43]
//       },
//       {
//          name: 'New York',
//          data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8,
//             24.1, 20.1, 14.1, 8.6, 2.5]
//       },
//       {
//          name: 'London',
//          data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0,
//             16.6, 14.2, 10.3, 6.6, 4.8]
//       }
//    ];

//    var json = {};

//    json.title = title;
//    json.subtitle = subtitle;
//    json.xAxis = xAxis;
//    json.yAxis = yAxis;
//    json.tooltip = tooltip;
//    json.legend = legend;
//    json.series = series;

//    $('#container').highcharts(json);
// });

</script>