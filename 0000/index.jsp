<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<jsp:include page="/head.jsp"/>

<!--请在下方写此页面业务相关的CSS-->
<title>首页</title>
<link rel="stylesheet" type="text/css" href="/static/css/index.css">
</head>
<body>
<!--顶部导航-->
<jsp:include page="/top.jsp"/>
<!--_header 作为公共模版分离出去-->

<div class="container-fluid index-main" id="indexMain">
    <div class="topmark">
        <span class="button pull-right"><i class="iconfont">&#xe60e;</i></span>
    </div>
    <div class="row row1">
        <div class="col-md-3">
            <div class="text">
                违章总数
                <ol class="number" id="total"></ol>
            </div>

            <div class="text">
                今日新增
                <ol class="number" id="daycount"></ol>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading title">
                    违章热点路段
                </div>
                <div class="panel-body">
                    <ul class="list-group" id="dayhotroad">

                    </ul>
                </div>
            </div>

        </div>

        <div class="col-md-6 cqmap">
            <div class="box">
                <div class="text">
                    平台车辆总数
                    <ol class="number" id="cartotal"></ol>
                </div>
                <div class="text" id="roadtotal">

                </div>
            </div>
            <p id="time"></p>
            <!--地图-->
            <div id="map" style="width:100%;height:700px"></div>

        </div>
        <div class="col-md-3">
            <div class="panel panel-default" style="margin-top: 20px">
                <div class="panel-heading title">
                    本月违章饼图
                </div>
                <div class="panel-body">
                    <div id="pie" style="width:100%;height:600px"></div>
                </div>
            </div>


        </div>
    </div>
    <div class="row row2">
        <div class="col-md-3">
            <div class="panel panel-default">
                <div class="panel-heading title">
                    <a href="/frequencyAnalysis.action?forwordtype=0">违章热点时间</a>
                </div>
                <div class="panel-body">
                    <ul class="list-group" id="hourCount">

                    </ul>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="panel panel-default">
                <div class="panel-heading title">
                    <a href="/peccancyType.action?forwordtype=0">违章热点类型</a>
                </div>
                <div class="panel-body">
                    <ul class="list-group" id="peccancyType">

                    </ul>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="panel panel-default panel-span">
                <div class="panel-heading title">
                    <a href="/carPeccancy.action?forwordtype=0">
                        <span>车牌号</span>
                        <span>违章类型</span>
                        <span>违章路段</span>
                    </a>
                </div>
                <div class="panel-body">
                    <ul class="list-group" id="newPecancyInfo">

                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="/lib/bs/js/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="/lib/bs/js/bootstrap.min.js"></script>
<script src="/lib/echarts/echarts.js"></script>
<script src="/static/js/common.js"></script>
<script src="/lib/js/jQuery.textSlider.js"></script>
<script type="text/javascript">

    // 基于准备好的dom，初始化echarts实例
    var mapChart = echarts.init(document.getElementById('map'));
    var pieChart = echarts.init(document.getElementById('pie'));

    // 强中弱数据格式化
    function toRoad(obj) {
        var outData = [];
        $(obj).each(function (index, item) {
            outData.push({
                name: item.roadname,
                value: [item.lng, item.lat, item.count]
            });
        });
        return outData;
    }

    //  分割字符串
    function makeThreeNum(num) {
        num = num + "";
        var str = "";
        if (num.length % 3 == 0) {
            for (var i = 0; i < Math.floor(num.length / 3); i++) {
                if (i == Math.floor(num.length / 3) - 1)
                    str = num.substring(num.length - 3 * (i * 1 + 1), num.length - 3 * i) + str;
                else
                    str = "," + num.substring(num.length - 3 * (i * 1 + 1), num.length - 3 * i) + str;
            }
        } else {
            for (var i = 0; i < Math.floor(num.length / 3); i++) {
                str = "," + num.substring(num.length - 3 * (i * 1 + 1), num.length - 3 * i) + str;
            }
            str = num.substring(0, num.length - (Math.floor(num.length / 3) * 3)) + str;
        }
        return str;
//        var num = (num || "0").toString();
//
//        return num.match(/\d{1,3}/g).join(',');
    }

    // 数字更新动画
    function update(oldNum, newNum) {
        var oldNum = makeThreeNum(oldNum),
            newNum = makeThreeNum(newNum),
            numberHTML = '';
        for (var i = newNum.length - 1; i >= 0; i--) {
            if (oldNum[i] !== newNum[i]) {
                if (oldNum[i] == undefined || oldNum[i] == null || oldNum[i] == "") {
                    if (newNum[i] != ",")
                        numberHTML = "<li class=\"group active\">" +
                            "<span class=\"old\">0</span>" +
                            "<span class=\"new\">" + newNum[i] + "</span></li>" + numberHTML;
                    else
                        numberHTML = "<li class=\"group active\">" +
                            "<span class=\"old\">,</span>" +
                            "<span class=\"new\">" + newNum[i] + "</span></li>" + numberHTML;
                }
                else
                    numberHTML = "<li class=\"group active\">" +
                        "<span class=\"old\">" + oldNum[i] + "</span>" +
                        "<span class=\"new\">" + newNum[i] + "</span></li>" + numberHTML;
            } else {
                numberHTML = "<li class=\"group\">" +
                    "<span class=\"old\">" + oldNum[i] + "</span>" +
                    "<span class=\"new\">" + newNum[i] + "</span></li>" + numberHTML;
            }
        }
        return numberHTML;
    }

    var option = null;
    var cqData = null;
    var areaname = "";
    var roadname = "";
    var reqstatus = false;
    var childstatus = false;
    var total = 15139031;
    var daycount = 18773;
    var roadtotal = 2161754;
    var totalcardno = 3739;
    var flag = true;
    var nowtime = 0;


    loadDom();
    loadData(areaname, false);

    function setReqStatus() {
        reqstatus = false;
        childstatus = false;
    }

    function loadDom() {
        $.ajax({
            url: '/peccancyController/getHomePage.action',
            type: 'POST',
            async: false,
            data: {area: areaname, roadname: roadname},
            dataType: 'json',
            success: function (res) {
                if (res.code == 20000) {
                    var data = res.data;
                    if (flag) {
                        total = data.total;
                        daycount = data.daycount;
                        roadtotal = data.roadtotal;
                        totalcardno = data.totalcardno;
                        flag = false;
                    }

                    $('#total').html(update(total, data.total));// 违章总数
                    $('#daycount').html(update(daycount, data.daycount));// 今日新增
                    var dataname = areaname == "" ? "重庆市" : areaname;
                    if (roadname == "")
                        $('#roadtotal').html(dataname + "违停卡口数<ol class=\"number\">" + update(roadtotal, data.roadtotal) + "</ol>");// 总路段数
                    else
                        $('#roadtotal').html(roadname + "违停卡口数<ol class=\"number\">" + update(1, 1) + "</ol>");// 总路段数

                    $("#cartotal").html(update(totalcardno, data.totalcardno));

                    total = data.total;
                    daycount = data.daycount;
                    roadtotal = data.roadtotal;
                    totalcardno = data.totalcardno;

                    // 当前时间
                    if (nowtime == 0)
                        nowtime = data.nowtime;


                    // 违章热点路段
                    var str1 = '';
                    $(data.dayhotroad).each(function (index, item) {
                        str1 += " <li class='list-group-item'><span class='badge'>" + item.count + "</span>" + item.roadname + " </li>"
                    });
                    $('#dayhotroad').html(str1);


                    // 违章热点时间
                    var str2 = '';
                    $(data.hourCount).each(function (index, item) {
                        if (item.hourcount > 0) {
                            str2 += " <li class='list-group-item'><span class='badge'>" + item.hourcount + "</span>" + item.hour + " </li>"
                        }
                    });
                    $('#hourCount').html(str2);

                    // 违章热点类型
                    var str3 = '';
                    $(data.peccancyType).each(function (index, item) {
                        str3 += " <li class='list-group-item'><span class='badge'>" + item.count + "</span>" + item.type + " </li>"
                    });
                    $('#peccancyType').html(str3);

                    // 违章车牌
                    var str4 = '';
                    $(data.newPecancyInfo).each(function (index, item) {
                        str4 += "<li class='list-group-item'><span>" + item.carno + "</span><span>" + item.type + "</span><span>" + item.roadname + "</span></li>"
                    });
                    $('#newPecancyInfo').html(str4);

                    var typeData = data.peccancyType;
                    var typeAll = typeData.map(function (item) {
                        return item['type']
                    });

                    var typeCount = [];
                    $(typeData).each(function (index, item) {
                        typeCount.push(
                            {
                                name: item['type'],
                                value: item['count']
                            }
                        )
                    });

                    // 南丁格尔玫瑰图
                    var pieOption = {
                        backgroundColor: '#0C1834',
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c} ({d}%)",
                            position: ['50%', '50%']
                        },
                        color: ['#6191E5', '#B0D7DE', '#1591CF', '#18B2D4'],
                        legend: {
                            orient: 'vertical',
                            x: 'left',
                            left: '10',
                            data: typeAll,
                            textStyle: {
                                color: '#fff'
                            }
                        },
                        series: [
                            {
                                name: '本月违章',
                                type: 'pie',
                                //radius: ['50%', '70%'],
                                center: ['60%', '60%'],
                                minAngle: 10,
                                avoidLabelOverlap: false,
                                label: {
                                    normal: {
                                        show: false,
                                        position: 'center'
                                    },
//                                    emphasis: {
//                                        show: true,
//                                        position: 'center'
//                                    }
//                                    emphasis: {
//                                        show: true,
//                                        formatter: "{c}",
//                                        textStyle: {
//                                            fontSize: '20',
//                                            fontWeight: 'bold',
//
//                                        }
//                                    }
                                },
                                data: typeCount

                            }
                        ]
                    };
                    pieChart.setOption(pieOption);

                } else if (res.code == 10001) {
                    location.href = "/userController/forwordLogin.do";
                } else {
                    alert(res.message);
                }
            }
        });
    }


    function getLocalTime(nS) {
        return new Date(parseInt(nS) * 1000).toLocaleString();
    }

    setInterval(function () {
        $('#time').html(getLocalTime(nowtime));
        //console.log(getLocalTime(nowtime));
        nowtime++;
    }, 1000);


    function loadData(areaname, flag) {
        if (reqstatus && flag)
            return;
        reqstatus = true;
        $.ajax({
            url: '/peccancyController/getMapInfo.action',
            type: 'POST',
            async: false,
            data: {area: areaname},
            dataType: 'json',
            success: function (res) {
                if (res.code == 20000) {
                    var data = res.data;
                    //绘制重庆地图
                    $.ajax({
                        url: '/lib/echarts/cq.json',
                        type: 'GET',
                        async: false,
                        dataType: 'json',
                        success: function (res) {
                        }

                    });


                    $.getJSON('/lib/echarts/cq.json', function (cqdata) {
                        cqData = cqdata;
                        //注册地图
                        echarts.registerMap("chongqing", cqdata);
                        option = {
                            backgroundColor: '#010E26',
                            color: ['orangered', 'yellow', '#258BF8'],
//                            visualMap: {
//                                type: 'continuous',
//                                min : 0,
//                                max : 300,
//                                text:['High','Low'],
//                                realtime: false,
//                                calculable : true,
//                                color: ['orangered','yellow','lightskyblue'],
//                                bottom: '100'
//                            },
                            toolbox: {
                                feature: {
                                    restore: {
                                        show: true,
                                        title: '还原'
                                    }
                                },
                                top: 50,
                                right: 0
                            },
                            legend: {// 图例
                                orient: 'vertical',
                                x: 'left',
                                top: '300',
                                data: ['强', '中', '弱'],
                                textStyle: {
                                    color: '#fff'
                                }
                            },
                            geo: {//地理坐标系组件
                                map: "chongqing",
                                label: {
                                    emphasis: {
                                        show: true,
                                        textStyle: {
                                            color: '#fff'
                                        }
                                    }
                                },
                                zoom: 1.2,
                                roam: false,
                                itemStyle: {
                                    normal: {
                                        borderColor: 'rgba(100,149,237,1)',
                                        borderWidth: 1.5,
                                        areaColor: '#1b1b1b'
                                    },
                                    emphasis: {
                                        areaColor: 'darkorange'
                                    }
                                },
                                tooltip: {
                                    trigger: 'item'
                                }

                            },
                            series: [
                                {
                                    name: '强',
                                    type: 'scatter',
                                    coordinateSystem: 'geo',
                                    data: toRoad(data.strongRoad),
                                    hoverAnimation: true,
                                    symbolSize: function (val) {
                                        return 10
                                    },
                                    itemStyle: {
                                        normal: {
                                            color: '#F6612A',
                                            shadowBlur: 10,
                                            shadowColor: '#f6a182'
                                        }
                                    },
                                    tooltip: {},
                                    zlevel: 3
                                },
                                {
                                    name: '中',
                                    type: 'scatter',
                                    coordinateSystem: 'geo',
                                    data: toRoad(data.centerRoad),
                                    hoverAnimation: true,
                                    symbolSize: function (val) {
                                        return 10
                                    },
                                    tooltip: {},
                                    itemStyle: {
                                        normal: {
                                            color: '#F8FB33',
                                            shadowBlur: 3,
                                            shadowColor: '#fafba4'
                                        }
                                    },
                                    zlevel: 2
                                },
                                {
                                    name: '弱',
                                    type: 'scatter',
                                    coordinateSystem: 'geo',
                                    data: toRoad(data.weakRoad),
                                    hoverAnimation: true,
                                    symbolSize: function (val) {
                                        return 5
                                    },
                                    tooltip: {},
                                    itemStyle: {
                                        normal: {
                                            color: '#4399F6',
                                            shadowBlur: 3,
                                            shadowColor: '#8fc0f6'
                                        }
                                    },
                                    zlevel: 1
                                },
                            ],
                            tooltip: {
                                trigger: 'item',
                                formatter: function (val) {
                                    //console.log(val);
                                    return val.data['name'] + ':' + val.data['value'][2];
                                }
                            },

                            animationDuration: 1000,
                            animationEasing: 'cubicOut',
                            animationDurationUpdate: 1000,

                        }
                        mapChart.setOption(option);

                    });

                } else if (res.code == 10001) {
                    location.href = "/userController/forwordLogin.do";
                } else {
                    alert(res.message);
                }
                setTimeout(setReqStatus, 10000);
            }


        });
    }

    //地图双击事件
    $('#roadtotal').on('click', function () {
        reqstatus = true;
        areaname = "";
        roadname = "";
        websocket.send('{"reqtype":30001,"area":"' + areaname + '"}');
        loadData(areaname, false);
        loadDom();
    });


    //地图点击事件
    mapChart.on('click', function (params) {
        reqstatus = true;
        childstatus = false;
        if (params.componentType == "geo") {
            areaname = params.name;
            websocket.send('{"reqtype":30001,"area":' + areaname + '}');
            roadname = "";
            getChildInfo(areaname, '');
        } else {
            roadname = params.name;
            $('#roadtotal').html("");// 总路段数
            //getChildInfo(areaname, roadname)
        }
        loadDom();
    });


    function getChildInfo(areaname, roadname) {
        // 子区域数据
        if (childstatus)
            return;
        childstatus = true;
        var now = null;
        for (var i = 0; i < cqData.features.length; i++) {
            if (cqData.features[i].properties.name == areaname) {
                now = cqData.features[i];
            }
        }

        var childData = {}
        childData.type = "FeatureCollection";
        childData.features = [];
        childData.features.push(now);

        $.ajax({
            url: '/peccancyController/getMapInfo.action',
            type: 'POST',
            async: false,
            data: {area: areaname, roadname: roadname},
            dataType: 'json',
            success: function (res) {
                if (res.code == 20000) {
                    var data = res.data;
                    loadDom(data);
                    //注册地图
                    echarts.registerMap('now', childData);
                    option = {
                        backgroundColor: '#010E26',
//                        visualMap: {
//                            type: 'continuous',
//                            min : 0,
//                            max : 300,
//                            text:['High','Low'],
//                            realtime: false,
//                            calculable : true,
//                            color: ['orangered','yellow','lightskyblue'],
//                            bottom: '100'
//                        },
                        toolbox: {
                            feature: {
                                restore: {
                                    show: true
                                }
                            }
                        },
                        legend: {// 图例
                            orient: 'vertical',
                            x: 'left',
                            top: '200',
                            data: ['强', '中', '弱'],
                            textStyle: {
                                color: '#fff'
                            }
                        },
                        geo: {//地理坐标系组件
                            map: "now",
                            label: {
                                emphasis: {
                                    show: false
                                }
                            },
                            zoom: 1.1,
                            roam: true,
                            itemStyle: {
                                normal: {
                                    borderColor: 'rgba(100,149,237,1)',
                                    borderWidth: 1.5,
                                    areaColor: '#1b1b1b'
                                },
                                emphasis: {
                                    areaColor: 'darkorange'
                                }
                            },
                            tooltip: {
                                trigger: 'item'
                            }

                        },
                        series: [
                            {
                                name: '强',
                                type: 'scatter',
                                coordinateSystem: 'geo',
                                data: toRoad(data.strongRoad),
                                hoverAnimation: true,
                                symbolSize: function (val) {
                                    return 10
                                },
                                itemStyle: {
                                    normal: {
                                        color: '#F6612A',
                                        shadowBlur: 10,
                                        shadowColor: '#f6a182'
                                    }
                                },
                                tooltip: {},
                                zlevel: 3
                            },
                            {
                                name: '中',
                                type: 'scatter',
                                coordinateSystem: 'geo',
                                data: toRoad(data.centerRoad),
                                hoverAnimation: true,
                                symbolSize: function (val) {
                                    return 10
                                },
                                tooltip: {},
                                itemStyle: {
                                    normal: {
                                        color: '#F8FB33',
                                        shadowBlur: 3,
                                        shadowColor: '#fafba4'
                                    }
                                },
                                zlevel: 2
                            },
                            {
                                name: '弱',
                                type: 'scatter',
                                coordinateSystem: 'geo',
                                data: toRoad(data.weakRoad),
                                hoverAnimation: true,
                                symbolSize: function (val) {
                                    return 5
                                },
                                tooltip: {},
                                itemStyle: {
                                    normal: {
                                        color: '#4399F6',
                                        shadowBlur: 3,
                                        shadowColor: '#8fc0f6'
                                    }
                                },
                                zlevel: 1
                            },
                        ],
                        tooltip: {
                            trigger: 'item'
                        },

                        animationDuration: 1000,
                        animationEasing: 'cubicOut',
                        animationDurationUpdate: 1000,

                    }


                    mapChart.setOption(option);
                }
                setTimeout(setReqStatus, 10000);
            }
        });
    }


    // 文字上下滚动

    $(function () {
        // setTimeout(function(){
//            $(".row2 .panel-body").each(function(){
//                $(this).mouseover(function(){
//                    $(this).textSlider({
//                        line:1,
//                        speed:600,
//                        timer:5000
//                    });
//                });
//
//            });

        //},5000)

    });


    var websocket;
    var reqip = "${servername}";
    var port = "${serverport}";
    if ('WebSocket' in window) {
        websocket = new WebSocket("ws://" + reqip + ":" + port + "/ws.do");
    } else if ('MozWebSocket' in window) {
        websocket = new MozWebSocket("ws://" + reqip + ":" + port + "/ws.do");
    } else {
        websocket = new SockJS("http://" + reqip + ":" + port + "/ws/sockjs.do");
    }
    websocket.onmessage = function (evt) {
        var data = eval('(' + evt.data + ')');
        if (data.code == 1000001) {
            $("#message").append("<p>" + data.data.msg + "</p>");
        } else if (data.code == 1000002)
            $("#message").append("<p>" + data.data.msg + "</p>");
        else if (data.code == 1000003) {
            alert(data.data.msg);
            location.href = "/userController/loginout.do?type=4";
        } else if (data.reqtype == 30001) {

        } else if (data.reqtype == 30002) {
            loadDom();
            if (areaname == undefined || areaname == null || areaname == "") {
                loadData(areaname, true);
            } else {
                getChildInfo(areaname, roadname);
            }
        }
    };
    websocket.onopen = function () {
    }


</script>


</body>
</html>
