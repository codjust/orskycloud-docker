<div class="row-fluid">
	<div class="page-header">
		<h1>传感器 <small>全部传感器</small></h1>
	</div>
<table class="table table-striped table-bordered table-condensed">
	<thead>
	<tr>
		<th>传感器标示</th>
		<th>所属设备</th>
		<th>传感器名称</th>
		<th>单位</th>
		<th>创建时间</th>
		<th>操作</th>
		<th></th>
	</tr>
	</thead>

	<tbody>
	{{range .Page.List}}
	<tr class="list-users">
		<td>{{.Name}}</td>
		<td>{{.Device}}</td>
		<td>{{.Designation}}</td>
		<td>{{.Unit}}</td>
		<td>{{.CreateTime}}</td>
		<!-- <td><span class="label label-success">Active</span></td> -->
		<td>
			<div class="btn-group">
			<a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">Actions <span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li ><a href="/mysensor/edit?did={{.Did}}&&name={{.Name}}"><i class="icon-pencil"></i>编辑</a></li>
					<li onclick="SubmitDeleteSensor({{.Did}},{{.Name}})"><a href="#"><i class="icon-trash"></i> 删除</a></li>
					<li><a href="/mysensor/newsensor"><i class="icon-trash"></i> 新建</a></li>
					<!-- <li><a href="#"><i class="icon-user"></i> Details</a></li> -->
					<!-- <li class="nav-header">Permissions</li>
					<li><a href="#"><i class="icon-lock"></i> Make <strong>Admin</strong></a></li>
					<li><a href="#"><i class="icon-lock"></i> Make <strong>Moderator</strong></a></li>
					<li><a href="#"><i class="icon-lock"></i> Make <strong>User</strong></a></li> -->
				</ul>
			</div>
		</td>
	</tr>
	{{end}}
	</tbody>
</table>
<div class="pagination">
	<ul class="pagination" id="pagination0"></ul>
</div>
</div>
