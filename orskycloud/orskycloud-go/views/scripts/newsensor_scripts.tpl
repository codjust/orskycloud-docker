<script type="text/javascript">

function SubmitNewSensor(){
	var Name = document.getElementById("name").value;
	var Designation = document.getElementById("designation").value;
	var Unit = document.getElementById("unit").value;
	var Did  = document.getElementById("did").value;

	var isNewSensor = confirm("确定要添加此传感器吗？")

	if(isNewSensor ==  true){
		if(Name.length <= 0 || Designation.length <= 0 || Unit.length <= 0 ){
			alert("输入不能为空!")
			return
		}

		$.ajax({
			async: false,
			type:"POST",
			url:"/mysensor/new/create",
			data:{"name": Name,"designation": Designation, "did":Did, "unit": Unit}
			}).done(function(msg){
			if(msg.Val == "success")
			{
				alert("添加成功！")
				window.location.href = "/mysensor"
			}
			else if(msg.Val == "failed")
			{
				alert("添加失败，数据库操作错误，请重试！")
			}
			else if(msg.Val == "exist")
			{
				alert("该传感器已存在，请重新添加!")
			}
		});
	}


}

</script>