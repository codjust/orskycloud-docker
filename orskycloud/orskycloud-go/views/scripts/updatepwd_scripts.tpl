<script type="text/javascript">
function SubmitModifyPwd(){
	var OldPwd = document.getElementById("oldpwd").value;
	var NewPwd = document.getElementById("newpwd").value;
	var Again  = document.getElementById("againsure").value;

	var OrgPwd = {{.Pwd}}
	if(OldPwd != OrgPwd){
		alert("旧密码不正确")
		return;
	}

	if(NewPwd.length < 6){
		alert("新密码长度不合法！")
		return;
	}

	if(NewPwd != Again ){
		alert("两次密码不一致！")
		return;
	}
		$.ajax({
		async: false,
		type:"POST",
		url:"/updatepwd/modify",
		data:{"newpwd": NewPwd}
		}).done(function(msg){
		if(msg.Val == "success")
		{
			alert("更新成功！")
			window.location.href = "/updatepwd"
		}
		else if(msg.Val == "failed")
		{
			alert("更新失败，数据库操作错误，请重试！")
		}

	});

}

</script>