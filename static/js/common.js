// 移动端响应式匹配
(function () {
  document.addEventListener('DOMContentLoaded', function () {
	var deviceWidth = document.documentElement.clientWidth;
	console.log(deviceWidth)
		// 默认1920*1080
		document.documentElement.style.fontSize = deviceWidth / 160 + 'px';
		
	   }, false);
	   
	window.onresize = function(){
		var deviceWidth = document.documentElement.clientWidth;
		
			document.documentElement.style.fontSize = deviceWidth / 160+ 'px';
		
	};
})();


