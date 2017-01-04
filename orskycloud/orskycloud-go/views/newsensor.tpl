<div class="row-fluid">
	<div class="page-header">
		<h1>My Sensor <small>new create a sensor</small></h1>
	</div>
		<form class="form-horizontal" method = "post" action = >
			<fieldset>
				<div class="control-group">
					<label class="control-label" for="username">传感器标识:</label>
						<div class="controls">
						<input type="text" class="input-xlarge" id="name" value= "" />
						</div>
				</div>
				<div class="control-group">
						<label class="control-label" for="usrkey">传感器名称:</label>
						<div class="controls">
						<input type="text" class="input-xlarge" id="designation"  value= "" />
						</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="phone">单位:</label>
						<div class="controls">
							<input type="text" class="input-xlarge" id="unit" value="" />
						</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="role">所属设备：</label>
					<div class="controls">
						<select id="did">
						{{range .DList}}
							<option value= '{{.Did}}'>{{.DeviceName}}</option>
						{{end}}
						</select>
						</div>
					</div>
				<div class="form-actions">
						<input type="button" class="btn btn-success btn-large" value="确定添加" onclick="SubmitNewSensor()" />
				</div>
				</fieldset>
		</form>
</div>