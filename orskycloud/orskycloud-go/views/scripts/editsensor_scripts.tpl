<script type="text/javascript">

function SubmitEditSensor(s_did)
{
	var s_name = document.getElementById("name").value;
	var s_desc = document.getElementById("designation").value;
	var s_unit = document.getElementById("unit").value;
	var s_time = document.getElementById("createTime").value;

	$.ajax({
			async: false,
			type:"POST",
			url:"/mysensor/edit/modify",
			data:{"name": s_name,"designation": s_desc, "unit": s_unit, "createTime": s_time, "did": s_did}
			}).done(function(msg){
			if(msg.Val == "success")
			{
				alert("修改成功！")
				window.location.href = "/mysensor"
			}
			else if(msg.Val == "failed")
			{
				alert("修改失败，数据库操作错误，请重试！")
			}
			else if(msg.Val == "exist")
			{
				alert("该传感器已存在，请重新添加!")
			}
		});
}

</script>