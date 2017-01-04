var code;//验证码全局变量
function createCode()
{
 code = "";
 var codeLength = 6; //验证码的长度
 var checkCode  = document.getElementById("checkCode");
 var codeChars  = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
      'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'); //所有候选组成验证码的字符，当然也可以用中文的
 for(var i = 0; i < codeLength; i++)
 {
  var charNum = Math.floor(Math.random() * 52);
  code += codeChars[charNum];
 }
 if(checkCode)
 {
  checkCode.className = "code";
  checkCode.innerHTML = code;
 }
}

function CheckRegistInfo(UserName,PassWord,PassWordAgain,inputCode)
{
	// var UserName = document.getElementById("username").value;
	// var PassWord = document.getElementById("password").value;
	// var PassWordAgain = document.getElementById("passwordAgain").value;
	// var inputCode = document.getElementById("inputCode").value;
	if (UserName.length<=0 || PassWord.length <= 0 || PassWordAgain.length <=0 || inputCode.length <= 0)
	{
		alert("输入不能为空")
		return false;
	}
	else if(UserName.length < 4 || UserName.length > 15 )
	{
		alert("用户名长度不合法，请重新输入")
		return false;
	}
	else if(PassWord != PassWordAgain)
	{
		alert("两次密码不一致，请重新设置")
		return false;
	}
	else if(inputCode.toUpperCase() != code.toUpperCase())
 	{
   		alert("验证码输入有误！请重新输入");
   		createCode();
   		return false;
 	}

 	return true;
}
function CheckLogin(UserName,PassWord,inputCode)
{
	//alert("提示：用户名或密码错误或未注册！")
	if (UserName.length<=0 || PassWord.length <= 0 || inputCode.length <= 0)
	{
		alert("输入不能为空")
		return false;
	}
	else if(inputCode.toUpperCase() != code.toUpperCase())
 	{
   		alert("验证码输入有误！请重新输入");
   		createCode();
   		return false;
 	}
 	return true;
}

