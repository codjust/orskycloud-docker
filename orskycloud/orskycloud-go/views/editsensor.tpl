<div class="row-fluid">
	<div class="page-header">
		<h1>My Sensor <small>Edit Sensor</small></h1>
	</div>
		<form class="form-horizontal" method = "post" action = >
			<fieldset>
				<div class="control-group">
					<label class="control-label" for="username">传感器标识:</label>
						<div class="controls">
						<input type="text" class="input-xlarge" id="name" value= "{{.Sensor.Name}}" readonly="true"/>
						</div>
				</div>
				<div class="control-group">
						<label class="control-label" for="usrkey">传感器名称:</label>
						<div class="controls">
						<input type="text" class="input-xlarge" id="designation"  value= "{{.Sensor.Designation}}" />
						</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="phone">单位:</label>
						<div class="controls">
							<input type="text" class="input-xlarge" id="unit" value="{{.Sensor.Unit}}" />
						</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="phone">创建时间:</label>
						<div class="controls">
							<input type="text" class="input-xlarge" id="createTime" value="{{.Sensor.CreateTime}}" readonly="true"/>
						</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="role">所属设备：</label>
					<div class="controls">
							<input type="text" class="input-xlarge" id="device" value="{{.Sensor.Device}}" readonly="true" />
					</div>
				<div class="form-actions">
						<input type="button" class="btn btn-success btn-large" value="确定修改" onclick="SubmitEditSensor({{.Sensor.Did}})" />
				</div>
				</fieldset>
		</form>
</div>