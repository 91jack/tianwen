// 移动端响应式匹配
(function () {
  document.addEventListener('DOMContentLoaded', function () {
	var deviceWidth = document.documentElement.clientWidth;
	var deviceHeight = document.documentElement.clientHeight;
//	alert(deviceWidth)
//	alert(deviceHeight)
		// 默认1920*1080
		document.documentElement.style.fontSize = deviceWidth / 160 + 'px';
		document.body.style.width = deviceWidth/12 + 'rem';
		document.body.style.height = deviceHeight/12 + 'rem';
		
	   }, false);
	   
	window.onresize = function(){
		var deviceWidth = document.documentElement.clientWidth;
		var deviceHeight = document.documentElement.clientHeight;
		
			document.documentElement.style.fontSize = deviceWidth / 160+ 'px';
			document.body.style.width = deviceWidth/12 + 'rem';
		document.body.style.height = deviceHeight/12 + 'rem';
	};
})();


