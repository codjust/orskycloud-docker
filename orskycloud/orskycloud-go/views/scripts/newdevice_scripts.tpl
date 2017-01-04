<script type="text/javascript">

function SubmitNewDevice(){
	var DeviceName  = document.getElementById("devicename").value;
	var Description = document.getElementById("description").value;

	if(DeviceName.length < 4 ){
		alert("设备名称长度不合法:")
		return;
	}

	var isNew = confirm("确认添加设备：" + DeviceName + "?")
	if(isNew == true)
	{
		$.ajax({
			async: false,
			type:"POST",
			url:"/mydevice/create",
			data:{"devicename": DeviceName,"description": Description}
			}).done(function(msg){
			if(msg.Val == "success")
			{
				alert("新建设备成功！")
				window.location.href = "/mydevice"
			}
			else if(msg.Val == "failed")
			{
				alert("创建失败，数据库操作错误，请重试！")
			}

		});
	}
}

</script>