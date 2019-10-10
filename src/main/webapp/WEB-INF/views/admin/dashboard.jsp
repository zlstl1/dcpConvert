<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2019-09-18
  Time: 오후 12:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String cp = request.getContextPath();
%>
<html>
<head>
    <jsp:include page="sidebar.jsp"></jsp:include>
</head>
<body>
<div class="row" style="margin-left:250px">
    <div class="col h-100">

            <div class="row m-3">
                <a class="font-weight-bold text-secondary"> Dashboard </a>
            </div>

            <hr>

            <div class="col">
                <div class="row ml-2">
                    <div class="col w-100">
                        <div class="row">
                            <div class="col p-0">
                                <h2 class="font-weight-bold m-0 p-0">CPU</h2>
                            </div>
                            <div class="col-3 p-0">
                                <h2 class="font-weight-bold m-0 p-0">RAM</h2>
                            </div>
                            <div class="col-3 p-0">
                                <h2 class="font-weight-bold m-0 p-0">STORAGE</h2>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col">
                                <h5 class="font-weight-bold text-secondary mt-3">LOAD</h5>
                                <div class="c100 custom green ml-5" id="cpumem">
                                    <span id="cpumemtext"></span>
                                    <div class="slice">
                                        <div class="bar"></div>
                                        <div class="fill"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col">
                                <h5 class="font-weight-bold text-secondary mt-3 mb-4">CLOCK SPEED</h5>
                                <div id="gaugeDemo3" class="gauge gauge-big">
                                    <div class="gauge-arrow" data-percentage="98"
                                         style="transform: rotate(0deg);"></div>
                                </div>
                                <h2 class="mt-3 ml-5 text-secondary" id="cpuclocktext"></h2>
                            </div>

                            <div class="col-3">
                                <h5 class="font-weight-bold text-secondary mt-3">LOAD</h5>
                                <div class="c100 custom green ml-5" id="rammem">
                                    <span id="rammemtext"></span>
                                    <div class="slice">
                                        <div class="bar"></div>
                                        <div class="fill"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-3" style="margin-top: auto;margin-bottom: auto">
                                <h5 class="font-weight-bold text-secondary">C:Drive</h5>
                                <div class="progress" style="height: 50px;">
                                    <div class="progress-bar" role="progressbar" style="width: 49%;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100" id="memused"><h4 id="memusedtext"></h4></div>
                                </div>

                                <h5 class="font-weight-bold text-secondary mt-3 text-right">Used : <a id="diskused"></a> / Free : <a id="diskfree"></a></h5>
                            </div>

                        </div>
                    </div>
                </div>

                <hr class="m-2">

               <div id="gpu">
                   <div class="row ml-2">

                   </div>
               </div>

            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
    var gpu1load = null;
    var gpu2load = null;

    $(document).ready(function(){

        $('#gaugeDemo3 .gauge-arrow').cmGauge();

        $.ajax({
            url:"<%=cp%>/get/single/gpu",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){

                for(var i = 1 ; i <= data.data.result.length; i++){
                    var div = document.createElement('div');

                    div.className = 'row ml-2';

                    div.innerHTML = '<div class="col">\n' +
                        '                <div class="row">\n' +
                        '                    <h2 class="font-weight-bold m-0 p-0">GPU '+i+'</h2>\n' +
                        '                </div>\n' +
                        '                <div class="row ml-2">\n' +
                        '                    <div class="col">\n' +
                        '                        <h5 class="font-weight-bold text-secondary mt-3">TEMP</h5>\n' +
                        '                        <i class="fas fa-5x mt-5 ml-5 gputemp'+i+'"></i>\n' +
                        '                        <a class="fa-5x mt-3 ml-5 gputemptext'+i+'"></a>\n' +
                        '                    </div>\n' +
                        '\n' +
                        '                    <div class="col">\n' +
                        '                        <h5 class="font-weight-bold text-secondary mt-3">LOAD</h5>\n' +
                        '                        <div class="c100 custom green ml-5 gpumem'+i+'">\n' +
                        '                            <span class="gpumemtext'+i+'"></span>\n' +
                        '                            <div class="slice">\n' +
                        '                                <div class="bar"></div>\n' +
                        '                                <div class="fill"></div>\n' +
                        '                            </div>\n' +
                        '                        </div>\n' +
                        '                    </div>\n' +
                        '\n' +
                        '                    <div class="col">\n' +
                        '                        <h5 class="font-weight-bold text-secondary mt-3 mb-4">CLOCK SPEED</h5>\n' +
                        '                        <div class="gauge gauge-big gauge-green ml-5 gaugeDemo'+i+'">\n' +
                        '                            <div class="gauge-arrow" data-percentage="9"\n' +
                        '                                 style="transform: rotate(0deg);"></div>\n' +
                        '                        </div>\n' +
                        '                        <h2 class="mt-3 ml-5 text-secondary gpuclocktext'+i+'"></h2>\n' +
                        '                    </div>\n' +
                        '\n' +
                        '                </div>\n' +
                        '                <hr class="m-2 mt-3">';

                    document.getElementById('gpu').appendChild(div);
                    $('.gaugeDemo'+i+' .gauge-arrow').cmGauge();

                    $('.gpumem' + i.toString()).addClass("p" + data.data.result[i - 1].value[1]);
                    $('.gpumemtext' + i.toString()).text(data.data.result[i - 1].value[1] + "%");

                }
                gpu1load = "p"+data.data.result[0].value[1];
                gpu2load = "p"+data.data.result[1].value[1];
            },
            error: function(err){
                console.log(err);
            }

        });

        update();
        //update
        //$('#gaugeDemo .gauge-arrow').trigger('updateGauge', new Values);

        setInterval(function() {
            update();
        }, 1000);

    });

    var cpuload = null;
    var ramload = null;

    function update(){
        $.ajax({
            url:"<%=cp%>/get/single/cpu",
            type:"POST",
            dataType:"json",
            data:{},
            success:function(data){
                var mem = Math.round(data.data.result[0].value[1]);

                $("#cpumem").removeClass(cpuload);
                $("#cpumem").addClass("p"+mem);

                cpuload = "p"+mem;

                if(mem>60){
                    $("#cpumem").removeClass("green");
                    $("#cpumem").addClass("orange");
                }else{
                    $("#cpumem").removeClass("orange");
                    $("#cpumem").addClass("green");
                }

                $("#cpumemtext").text(mem+"%");

            },
            error: function(err){
                console.log(err);
            }

        });

        $.ajax({
            url:"<%=cp%>/get/single/cpuClock",
            type:"POST",
            dataType:"json",
            data:{},
            success:function(data){
                //2.0 ~ 3.4
                var clock = (data.data.result[0].value[1]/Math.pow(10,9)).toFixed(1);
                var mhz = clock - 2.0;
                var percent = Math.round(mhz / 3.4 * 100);

                $('#gaugeDemo3 .gauge-arrow').trigger('updateGauge', percent);

                $('#cpuclocktext').text(clock + " Ghz");
            },
            error: function(err){
                console.log(err);
            }

        });

        $.ajax({
            url:"<%=cp%>/get/single/mem",
            type:"POST",
            dataType:"json",
            data:{},
            success:function(data){
                var mem = Math.round(data.data.result[0].value[1]);

                $("#rammem").removeClass(ramload);
                $("#rammem").addClass("p"+mem);

                ramload = "p"+mem;

                if(mem>60){
                    $("#rammem").removeClass("green");
                    $("#rammem").addClass("orange");
                }else{
                    $("#rammem").removeClass("orange");
                    $("#rammem").addClass("green");
                }

                $("#rammemtext").text(mem+"%");
            },
            error: function(err){
                console.log(err);
            }

        });

        var disktotal;
        $.ajax({
            url:"<%=cp%>/get/single/disksizetotal",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){
                var total = data.data.result[0].value[1]/Math.pow(10,9);
                disktotal = total;
            },
            error: function(err){
                console.log(err);
            }

        });

        $.ajax({
            url:"<%=cp%>/get/single/disksize",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){
                var used = data.data.result[0].value[1]/Math.pow(10,9);
                var free = disktotal - used;

                $("#diskused").text(used.toFixed(2)+" GB");
                $("#diskfree").text(free.toFixed(2)+" GB");

                var percent = used/disktotal*100;

                $('#memusedtext').text(Math.round(percent) + "%");
                $('#memused').width(Math.round(percent)+'%');
            },
            error: function(err){
                console.log(err);
            }

        });

        $.ajax({
            url:"<%=cp%>/get/single/gpu_temp",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){
                for(var i = 1 ; i <= data.data.result.length; i++){
                    $('.gputemp' + i.toString()).removeClass("fa-thermometer-empty")
                    $('.gputemp' + i.toString()).removeClass("fa-thermometer-quarter");
                    $('.gputemp' + i.toString()).removeClass("fa-thermometer-half");
                    $('.gputemp' + i.toString()).removeClass("fa-thermometer-three-quarters");
                    $('.gputemp' + i.toString()).removeClass("fa-thermometer-full");
                    $('.gputemp' + i.toString()).css({ 'color' : ''});
                    if(Math.round(data.data.result[i-1].value[1]) < 10){
                        $('.gputemp' + i.toString()).addClass("fa-thermometer-empty");
                    }else if(Math.round(data.data.result[i-1].value[1]) >= 10 && Math.round(data.data.result[i-1].value[1]) < 40){
                        $('.gputemp' + i.toString()).addClass("fa-thermometer-quarter");
                    }else if(Math.round(data.data.result[i-1].value[1]) >= 40 && Math.round(data.data.result[i-1].value[1]) < 60){
                        $('.gputemp' + i.toString()).addClass("fa-thermometer-half");
                    }else if(Math.round(data.data.result[i-1].value[1]) >= 60 && Math.round(data.data.result[i-1].value[1]) < 90){
                        $('.gputemp' + i.toString()).addClass("fa-thermometer-three-quarters");
                        $('.gputemp' + i.toString()).css("color","orange");
                    }else if(Math.round(data.data.result[i-1].value[1]) >= 90){
                        $('.gputemp' + i.toString()).addClass("fa-thermometer-full");
                        $('.gputemp' + i.toString()).css("color","red");
                    }
                    $('.gputemptext' + i.toString()).text(Math.round(data.data.result[i-1].value[1])+"°C");
                }

            },
            error: function(err){
                console.log(err);
            }

        });

        $.ajax({
            url: "<%=cp%>/get/single/gpu",
            type: "POST",
            dataType: "json",
            async: false,
            data: {},
            success: function (data) {
                //p+data 추가(removeClass)
                $(".gpumem1").removeClass(gpu1load);
                $(".gpumem2").removeClass(gpu2load);

                for (var i = 1; i <= data.data.result.length; i++) {
                    $('.gpumem' + i.toString()).addClass("p" + data.data.result[i - 1].value[1]);
                    $('.gpumemtext' + i.toString()).text(data.data.result[i - 1].value[1] + "%");

                    if(data.data.result[i - 1].value[1]>60){
                        $(".gpumem"+ i.toString()).removeClass("green");
                        $(".gpumem"+ i.toString()).addClass("orange");
                    }else{
                        $(".gpumem"+ i.toString()).removeClass("orange");
                        $(".gpumem"+ i.toString()).addClass("green");
                    }

                }
            },
            error: function (err) {
                console.log(err);
            }
        });

        $.ajax({
            url:"<%=cp%>/get/single/gpu_clock",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){
                // 0-2000 Mhz
                for(var i = 1 ; i <= data.data.result.length; i++){
                    $('.gaugeDemo' + i.toString() + " .gauge-arrow").trigger('updateGauge', data.data.result[i-1].value[1] / 2000 * 100);
                    $('.gpuclocktext' + i.toString()).text(data.data.result[i-1].value[1]+" Ghz");
                }
            },
            error: function(err){
                console.log(err);
            }

        });
    }
</script>
</html>
