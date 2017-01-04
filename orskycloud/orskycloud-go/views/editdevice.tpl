<div class="row-fluid">
	<div class="page-header">
	<h1>Edit Device <small>modify device information</small></h1>
	</div>
	<form class="form-horizontal">
		<fieldset>
			<div class="control-group">
				<label class="control-label" for="role">设备名称:</label>
				<div class="controls">
					<input type="text" class="input-xlarge" id="devicename" value = {{.DeviceName}}/>
				</div>
				</div>
			<div class="control-group">
				<label class="control-label" for="description">设备描述：</label>
				<div class="controls">
					<textarea class="input-xlarge" id="description" rows="3" >{{.Description}}</textarea>
				</div>
			</div>
			<div class="form-actions">
				<input type="button" class="btn btn-success btn-large" value="确定修改" onclick="SubmitEditDevice({{.Did}})" />
			</div>
		</fieldset>
	</form>
 </div>