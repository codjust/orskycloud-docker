<div class="row-fluid">
	<div class="page-header">
		<h1>My profile <small>Modify Password</small></h1>
	</div>
		<form class="form-horizontal" method = "post" action = >
			<fieldset>
				<div class="control-group">
					<label class="control-label" for="username">旧密码:</label>
						<div class="controls">
						<input type="text" class="input-xlarge" id="oldpwd" value= "" />
						</div>
				</div>
				<div class="control-group">
						<label class="control-label" for="usrkey">新密码:</label>
						<div class="controls">
						<input type="text" class="input-xlarge" id="newpwd"  value= "" />
						</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="phone">再次确认:</label>
						<div class="controls">
							<input type="text" class="input-xlarge" id="againsure" value="" />
						</div>
				</div>
				<div class="form-actions">
						<input type="button" class="btn btn-success btn-large" value="确定修改" onclick="SubmitModifyPwd()" />
				</div>
				</fieldset>
		</form>
</div>