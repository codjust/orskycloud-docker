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
        window.location.href = "/mydevice/" + page
      }
    });
  });


function SubmitDeleteDevice(did){

	var Did = did
	var isDelete = confirm("确定要删除该设备吗？");
//	alert("did:",Did)
	if(isDelete == true){
		$.ajax({
		async: false,
		type:"POST",
		url:"/mydevice/delete",
		data:{"did": did}
		}).done(function(msg){
		if(msg.Val == "success")
		{
			alert("删除成功！")
			window.location.href = "/mydevice"
		}
		else if(msg.Val == "failed")
		{
			alert("删除失败，数据库操作错误，请重试！")
		}
	});
	}

}


</script>