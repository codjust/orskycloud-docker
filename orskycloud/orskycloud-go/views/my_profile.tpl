<div class="row-fluid">
	<div class="page-header">
		<h1>My profile <small>Update info</small></h1>
	</div>
		<form class="form-horizontal" method = "post" action = >
			<fieldset>
				<div class="control-group">
					<label class="control-label" for="username">UserName:</label>
						<div class="controls">
						<input type="text" class="input-xlarge" id="username" value='{{.Profile.UserName}}' />
						</div>
				</div>
				<div class="control-group">
						<label class="control-label" for="usrkey">UserKey:</label>
						<div class="controls">
						<input type="text" class="input-xlarge" id="userkey" readonly="true" value='{{.Profile.UserKey}}' />
						</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="phone">Phone:</label>
						<div class="controls">
							<input type="text" class="input-xlarge" id="phone" value='{{.Profile.Phone}}' />
						</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="email">E-Mail:</label>
						<div class="controls">
							<input type="text" class="input-xlarge" id="email" value='{{.Profile.EMail}}' />
						</div>
				</div>
				<div class="control-group">
						<label class="control-label" for="dev_count">设备数量:</label>
						<div class="controls">
							<input type="text" class="input-xlarge" readonly="true" id="count" value='{{.Profile.DevCount}}' />
						</div>
				</div>
				<div class="control-group">
						<label class="control-label" for="sign-time">注册时间:</label>
						<div class="controls">
							<input type="text" class="input-xlarge" readonly="true" id="time" value='{{.Profile.SignTime}}' />
						</div>
				</div>
				<div class="form-actions">
						<input type="button" class="btn btn-success btn-large" value="Save Changes" onclick="SubmitProfileInfo()" />
				</div>
				</fieldset>
		</form>
</div>