// 移动端响应式匹配
(function () {
  document.addEventListener('DOMContentLoaded', function () {
	var deviceWidth = document.documentElement.clientWidth;
	var deviceHeight = document.documentElement.clientHeight;
			document.documentElement.style.fontSize = deviceWidth / 96 + 'px';
	   }, false);
	   
	window.onresize = function(){
		var deviceWidth = document.documentElement.clientWidth;
		var deviceHeight = document.documentElement.clientHeight;
			document.documentElement.style.fontSize = deviceWidth / 96+ 'px';
	};
})();


