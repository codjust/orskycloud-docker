<div class="row-fluid">
	<div class="page-header">
	<h1>New Device <small>Add a new device</small></h1>
	</div>
	<form class="form-horizontal">
		<fieldset>
			<div class="control-group">
				<label class="control-label" for="role">设备名称:</label>
				<div class="controls">
					<input type="text" class="input-xlarge" id="devicename" placeholder="长度4以上"/>
				</div>
				</div>
			<div class="control-group">
				<label class="control-label" for="description">设备描述：</label>
				<div class="controls">
					<textarea class="input-xlarge" id="description" rows="3" placeholder="可以为空"></textarea>
				</div>
			</div>
			<div class="form-actions">
				<input type="button" class="btn btn-success btn-large" value="确定新建" onclick="SubmitNewDevice()" /> <a class="btn" href="roles.html">取消</a>
			</div>
		</fieldset>
	</form>
 </div>