<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>ORSkyCloud后台管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/static/css/bootstrap.css" rel="stylesheet">
    <link href="/static/css/site.css" rel="stylesheet">
    <link href="/static/css/bootstrap-responsive.css" rel="stylesheet">

    <style type="text/css">
        html,
        body {
            height: 100%;
        }
    </style>
</head>

<body>
    <div class="navbar navbar-fixed-top">
        <div class="navbar-inner">
            <div class="container-fluid">
                <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </a>
                <a class="brand" href="/homepage">Admin</a>
                <div class="btn-group pull-right">
                    <a class="btn" href="/myprofile"><i class="icon-user"></i> {{.User}}</a>
                    <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
                        <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="/myprofile">个人资料</a></li>
                        <li class="divider"></li>
                        <li onclick="IsSignOut()"><a href="#">退出</a></li>
                    </ul>
                </div>
                <div class="nav-collapse">
                    <ul class="nav">
                        <li><a href="/homepage">首页</a></li>
                        <li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown">设备 <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="/mydevice/newdevice">新建设备</a></li>
                                <li class="divider"></li>
                                <li><a href="/mydevice">设备管理</a></li>
                            </ul>
                        </li>
                        <li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown">传感器 <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li onclick="NewCreateSensor()"><a href="#">新建传感器</a></li>
                                <li class="divider"></li>
                                <li><a href="/mysensor">传感器管理</a></li>
                            </ul>
                        </li>
                        <li><a href="/history">数据统计</a></li>
                        <li><a href="/doc/index.html">开发者指南</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span3">
                <div class="well sidebar-nav">
                    <ul class="nav nav-list">
                        <li class="nav-header"><i class="icon-wrench"></i> 查看</li>
                        <li class='{{.Active_Dev}}'><a href="/mydevice">我的设备</a></li>
                        <li class='{{.Active_Sensor}}'><a href="/mysensor">传感器</a></li>
                        <li class="nav-header"><i class="icon-signal"></i>数据统计</li>
                        <li class='{{.Active_History}}'><a href="/history">历史数据</a></li>
                        <li class='{{.Active_Trend}}'><a href="/history/trend">历史走势</a></li>
                        <li class='{{.Active_Compare}}'><a href="/history/compare">数据对比</a></li>
                        <li class="nav-header"><i class="icon-user"></i> 资料</li>
                        <li class='{{.Active_Profile}}'><a href="/myprofile">我的资料</a></li>
                        <li class='{{.Active_UpdatePwd}}'><a href="/updatepwd">修改密码</a></li>
                        <li onclick = "IsSignOut()"><a href="#">退出</a></li>
                    </ul>
                </div>
            </div>
            <div class="span9">
            {{.LayoutContent}}
            <!--     <div class="row-fluid">
                    <div class="page-header">
                        <h1>网站统计 <small></small></h1>
                    </div>
                    <div id="placeholder" style="width:80%;height:300px;"></div>
                    <br />
                    <div id="visits" style="width:80%;height:300px;"></div>
                </div> -->
            </div>
        </div>

        <hr>

        <footer class="well">
            &copy; You Will love it!<a href="/homepage" target="_blank">&nbsp;ORSkyCloud</a>
        </footer>

    </div>

    <script src="/static/js/jquery.js"></script>
    <script src="/static/js/jquery-1.8.0.min.js"></script>
    <script src="/static/js/jquery.flot.js"></script>
    <script src="/static/js/jquery.flot.resize.js"></script>
    <script src="/static/js/bootstrap.min.js"></script>
    <script src="http://cdn.hcharts.cn/jquery/jquery-1.8.3.min.js"></script>
    <script src="http://cdn.hcharts.cn/highcharts/highcharts.js"></script>
    <script src="http://cdn.hcharts.cn/highcharts/modules/exporting.js"></script>
    <script src="/static/js/bootstrap-paginator.min.js"></script>
    <script src="/static/js/jqPaginator.min.js"></script>
    <script type="text/javascript">
    function IsSignOut()
    {
        var IsOut = confirm("确定退出当前账户吗？")
            if(IsOut == true){
                window.location.href = "/login";
            }
    }
    function NewCreateSensor()
    {
        $.ajax({
            async: false,
            type:"GET",
            url:"/mysensor/newsensor"
            }).done(function(msg){
            if(msg.Val == "failed")
            {
                alert("当前无设备，无法新建传感器，请先添加设备。")
                window.location.href = "/mydevice/newdevice"
            }else{
                window.location.href = "/mysensor/newsensor";
            }
        });
    }
    </script>
    {{.Scripts}}
</body>

</html>
