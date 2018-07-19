// 移动端响应式匹配
(function () {
  document.addEventListener('DOMContentLoaded', function () {
	var deviceWidth = document.documentElement.clientWidth;
	var deviceHeight = document.documentElement.clientHeight;
			document.documentElement.style.fontSize = deviceWidth / 96 + 'px';
			console.log(deviceWidth)
			console.log(deviceWidth / 20)
			document.body.style.width = deviceWidth/20 + 'rem';
			document.body.style.height = deviceHeight/20 + 'rem';
		
		
	   }, false);
	   
	window.onresize = function(){
		var deviceWidth = document.documentElement.clientWidth;
		var deviceHeight = document.documentElement.clientHeight;
		
			document.documentElement.style.fontSize = deviceWidth / 96+ 'px';
			document.body.style.width = deviceWidth/20 + 'rem';
		document.body.style.height = deviceHeight/20 + 'rem';
	};
})();


