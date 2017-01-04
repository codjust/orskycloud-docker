<table >
	<div>
	<tr>
		<th><p style = "font-size: 15px">传感器：</p></th>
		<td><select id="did" style="width:120px" onchange="AddSensorItem('did', 's_name')">
		{{range .Data}}
		<option value='{{.Did}}'>{{.Dev_Name}}</option>
		{{end}}
		</select></td>
		<td><select id="s_name" style="width:120px">
		<option value=></option>
		</select></td>
<!-- 	</tr>
	<tr> -->
		<td>&nbsp;&nbsp;&nbsp;</td>
		<td><select id="select" style="width:100px" onclick="SelectTime()">
		<option value="self">自定义时间</option>
		<option value="day">最近一天</option>
		<option value="week">最近一周</option>
		<option value="month">最近一月</option>
		<option value="year">最近一年</option>
		</select></td>
		<td><input type="text" class="input-xlarge" id="start" style="width:130px"/></td>
		<td><p>-</p></td>
		<td><input type="text" class="input-xlarge" id="end"  style="width:130px"/></td>
		<td>&nbsp;&nbsp;&nbsp;</td>
		<div>
		<td><input type="button" value="查询" class="btn btn-success btn-large" onclick="SearchHistoryTrend()" /></td>
		</div>
	</tr>
	</div>
  </table>
 <table class="table table-striped table-bordered table-condensed">
<div id="container" style="min-width:400px;height:400px">

</div>
</table>