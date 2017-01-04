<div class="row-fluid">
	<div class="page-header">
		<h1>设备 <small>全部设备</small></h1>
	</div>
<table class="table table-striped table-bordered table-condensed">
	<thead>
	<tr>
		<th>设备ID</th>
		<th>设备名称</th>
		<th>设备描述</th>
		<th>创建时间</th>
		<th>操作</th>
		<th></th>
	</tr>
	</thead>

	<tbody>
	{{range .Page.List}}
	<tr class="list-users">
		<td>{{.ID}}</td>
		<td>{{.DevName}}</td>
		<td>{{.Description}}</td>
		<td>{{.CreateTime}}</td>
		<!-- <td><span class="label label-success">Active</span></td> -->
		<td>
			<div class="btn-group">
			<a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">Actions <span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li><a href="/mydevice/edit/{{.ID}}"><i class="icon-pencil"></i>编辑</a></li>
					<li onclick = "SubmitDeleteDevice({{.ID}})"><a href="#"><i class="icon-trash"></i> 删除</a></li>
					<li><a href="/mydevice/newdevice"><i class="icon-trash"></i> 新建</a></li>
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
	<ul class="pagination" id="pagination0"><li></li></ul>
	<!-- <ul ><li id="pagination0"></li></ul> -->
</div>
<div>

	<!-- <a href="new-user.html" class="btn btn-success">添加设备</a> -->
</div>
</div>
