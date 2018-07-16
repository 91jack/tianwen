
    // 二级导航
    // $('.index-nav .dropdown-toggle').each(function() {
    //     $(this).mouseover(
    //         function () {
    //             $(this).siblings().slideDown()
    //                 .parent().siblings().children('.dropdown-menu').slideUp();
    //
    //             // $(this).siblings().mouseout(function(){
    //             //     $(this).siblings().slideUp();
    //             // })
    //         }
    //     )
    // });

    // $('.dropdown-menu').each(function(){
    //     console.log($('.dropdown-menu'));
    //     var _this = $(this);
    //     $(this).on('mouseout',function(){
    //        // console.log(_this.children('.dropdown-menu'));
    //        _this.slideUp();
    //        console.log(_this)
    //     })
    //
    // });

    // 右侧管理员
    $('.admin-nav .dropdown-toggle').on('click', function(){
        //$(this).children('.dropdown-menu').show();
        console.log($(this).siblings().slideToggle());
    });


    // 点击全屏
    var on = true;
    var myheader = $('header').clone(true);
    $('.topmark .button').on('click', function () {

        if (on) {
            $('header').remove();
            $('body').css({
                'width': window.screen.width + 'px',
                'height': window.screen.height + 'px',
            })
            fullScreen('indexMain');
        } else {
            $(myheader).insertBefore($('body'));
        }
        on = !on;
    });

    // 全屏 F11
    function fullScreen(obj) {
        var element= document.documentElement; //若要全屏页面中div，var element= document.getElementById("divID");
        //var element= document.getElementById(obj);
        //IE 10及以下ActiveXObject
        if (window.ActiveXObject)
        {
            var WsShell = new ActiveXObject('WScript.Shell')
            WsShell.SendKeys('{F11}');
        }
        //HTML W3C 提议
        else if(element.requestFullScreen) {
            element.requestFullScreen();
        }
        //IE11
        else if(element.msRequestFullscreen) {
            element.msRequestFullscreen();
        }
        // Webkit (works in Safari5.1 and Chrome 15)
        else if(element.webkitRequestFullScreen ) {
            element.webkitRequestFullScreen();
        }
        // Firefox (works in nightly)
        else if(element.mozRequestFullScreen) {
            element.mozRequestFullScreen();
        }
    }

    //退出全屏
    function fullExit(obj){
        var element= document.documentElement;//若要全屏页面中div，
        //var element= document.getElementById(obj);
        //IE ActiveXObject
        if (window.ActiveXObject)
        {
            var WsShell = new ActiveXObject('WScript.Shell')
            WsShell.SendKeys('{F11}');
        }
        //HTML5 W3C 提议
        else if(element.requestFullScreen) {
            document.exitFullscreen();
        }
        //IE 11
        else if(element.msRequestFullscreen) {
            document.msExitFullscreen();
        }
        // Webkit (works in Safari5.1 and Chrome 15)
        else if(element.webkitRequestFullScreen ) {
            document.webkitCancelFullScreen();
        }
        // Firefox (works in nightly)
        else if(element.mozRequestFullScreen) {
            document.mozCancelFullScreen();
        }
    }
