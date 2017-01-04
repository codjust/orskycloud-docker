<script type="text/javascript">

function SubmitEditDevice(Did){
	var DeviceName =  document.getElementById("devicename").value;
	var Description = document.getElementById("description").value;

	var isEdit = confirm("确定要修改此设备信息吗？")

	if(isEdit ==  true){
		if(DeviceName.length <4){
			alert("设备名称长度不合法。")
			return
		}
		$.ajax({
			async: false,
			type:"POST",
			url:"/mydevice/edit/modify",
			data:{"devicename": DeviceName,"description": Description, "did":Did}
			}).done(function(msg){
			if(msg.Val == "success")
			{
				alert("修改成功！")
				window.location.href = "/mydevice"
			}
			else if(msg.Val == "failed")
			{
				alert("修改失败，数据库操作错误，请重试！")
			}

		});

	}


}

</script>