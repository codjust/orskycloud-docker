<div class="row-fluid">
		<div class="page-header">
			<h1>History Data<small>Select time to view</small></h1>
		</div>
	<table >
	<div>
	<tr>
		<th><p style = "font-size: 15px">传感器：</p></th>
		<td><select id="did" style="width:120px" onchange="AddSensorItem()">
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
		<td><input type="button" value="查询" class="btn btn-success btn-large" onclick="SearchHistory()" /></td>
		<td>&nbsp;&nbsp;</td>
		<td><input type="button" value="删除" class="btn btn-success btn-large" onclick="DeleteHistory()" /></td>
		</div>
	</tr>
	</div>
  </table>
<table class="table table-striped table-bordered table-condensed" id = "tb">
	<tr class="list-users">
		<th>标识</th>
		<th>名称</th>
		<th>更新时间</th>
		<th>值</th>
	</tr>
	<!-- <tr>
		<td>1</td>
		<td>2</td>
		<td>3</td>
		<td>4</td>
	</tr> -->
</table>
<div class="pagination">
	<ul class="pagination" id="pagination1"></ul>
</div>
</div>