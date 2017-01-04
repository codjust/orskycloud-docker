<script>
	$(document).ready(function() {
		$('.dropdown-menu li a').hover(
		function() {
			$(this).children('i').addClass('icon-white');
		},
		function() {
			$(this).children('i').removeClass('icon-white');
		});

		if($(window).width() > 760)
		{
			$('tr.list-users td div ul').addClass('pull-right');
		}
	});

 $(function () {
    $("#pagination0").bootstrapPaginator({
      currentPage: '{{.Page.PageNo}}',
      totalPages: '{{.Page.TotalPage}}',
      bootstrapMajorVersion: 3,
      size: "small",
      onPageClicked: function(e,originalEvent,type,page){
        window.location.href = "/mysensor/" + page
      }
    });
  });


function SubmitDeleteSensor(Did, Name)
{
	var isDelete = confirm("确定删除该传感器吗？");

	if(isDelete == true)
	{
		$.ajax({
			async: false,
			type:"POST",
			url:"/mysensor/delete",
			data:{"name": Name, "did":Did}
			}).done(function(msg){
			if(msg.Val == "success")
			{
				alert("删除成功！")
				window.location.href = "/mysensor"
			}
			else if(msg.Val == "failed")
			{
				alert("添加失败，数据库操作错误，请重试！")
			}
		});
	}
}



</script>