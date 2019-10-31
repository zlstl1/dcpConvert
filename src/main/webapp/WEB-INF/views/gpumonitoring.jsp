<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String cp = request.getContextPath();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>관리자 페이지</title>
<link rel="stylesheet" href="<%=cp%>/resources/assets/css/main.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/bootstrap.css">

<!-- 김규아 추가 -->
<link rel="stylesheet" href="<%=cp%>/resources/css/circle.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/cmGauge.css">
<link rel="stylesheet" href="<%=cp%>/webjars/font-awesome/5.8.1/css/fontawesome.css">
<link rel="stylesheet" href="<%=cp%>/webjars/font-awesome/5.8.1/css/all.css">

<style type="text/css">
/* Style the lines by removing the fill and applying a stroke */
.line1{
	fill: none;
	stroke: steelblue;
	stroke-width: 1.5px;
}

.line2{
	fill: none;
	stroke: orange;
	stroke-width: 1.5px;
}

.line3{
	fill: none;
	stroke: green;
	stroke-width: 1.5px;
}

.line4{
	fill: none;
	stroke: gray;
	stroke-width: 1.5px;
}

.gauge.gauge-big {
    font-size: 100px;
}

.c100.custom {
  font-size: 170px;
}

.tooltip {
	fill: white;
	stroke: #000;
}

.tooltip-time, .tooltip-date {
	font-weight: bold;
	font-size :12px;
}
</style>

</head>
<body class="subpage">
<jsp:include page="import/navbar.jsp"></jsp:include>

<!-- One -->
<section id="One" class="wrapper style3">
	<div class="inner">
		<header class="align-center">
			<p>실시간 GPU 자원 모니터링이 가능합니다.</p>
			<h2>GPU 모니터링</h2>
		</header>
	</div>
</section>

<!-- Two -->
<section id="two" class="wrapper style2">
	<div class="inner">
		<div class="box">
			<div class="content" id="gpu">
			
				<div class="row ml-2">
				
				</div>
				
			</div>
		</div>
	</div>
</section>

<!-- Footer -->
<%@include file="import/footer.jsp"%>

<script src="<%=cp%>/resources/jquery/jQuery3.4.1.js"></script>
<script src="<%=cp%>/resources/js/bootstrap.bundle.js"></script>
<script src="<%=cp%>/resources/assets/js/jquery.scrollex.min.js"></script>
<script src="<%=cp%>/resources/assets/js/skel.min.js"></script>
<script src="<%=cp%>/resources/assets/js/util.js"></script>
<script src="<%=cp%>/resources/assets/js/main.js"></script>
<script src="<%=cp%>/resources/js/cmGauge.js"></script>
<script src="<%=cp%>/resources/js/d3.min.js"></script>
<script src="<%=cp%>/resources/js/moment.js"></script>

<script type="text/javascript">
var now = null, loadDt = null, time = null, start = null, length = null;
var dataset = new Array(),  min = new Array(), max = new Array();
var timer = null;  

$(document).ready(function(){
	
	$.ajax({
	    url:"<%=cp%>/get/single/gpu",
	    type:"POST",
	    dataType:"json",
	    async:false,
	    data:{},
	    success:function(data){
			
			length =  data.data.result.length;
	        
	        for(var j = 1 ; j <=  length * 3 ; j ++){
	        	eval("var max"+j+"=null");
	        	eval("var min"+j+"=null");
	        }
	        
	        for(var i = 1 ; i <= length; i++){        
	               	
	            var div = document.createElement('div');

	            div.className = 'row ml-2';

	            div.innerHTML = '<div class="col">\n' +
	                '                <div class="row">\n' +
	                '                    <h5 class="font-weight-bold m-0 p-0">GPU '+i+'</h5>\n' +
	                '                </div>\n' +
	                '                <div class="row">\n' +
	                '                    <div class="col text-center">\n' +
	                '                        <p class="font-weight-bold text-secondary mt-3 text-left">TEMP</p>\n' +
	                '                        <i class="fas fa-4x mt-5 gputemp'+i+'"></i>\n' +
	                '                        <a class="fa-3x mt-3 ml-5 gputemptext'+i+'"></a>\n' +
	                '                    </div>\n' +
	                '\n' +
	                '                    <div class="col text-center">\n' +
	                '                        <p class="font-weight-bold text-secondary mt-3 text-left">LOAD</p>\n' +
	                '                        <div class="c100 custom green gpumem'+i+'" style="margin-left:25%" >\n' +
	                '                            <span class="gpumemtext'+i+'"></span>\n' +
	                '                            <div class="slice">\n' + 
	                '                                <div class="bar"></div>\n' +
	                '                                <div class="fill"></div>\n' +
	                '                            </div>\n' +
	                '                        </div>\n' +
	                '                    </div>\n' +
	                '\n' +
	                '                    <div class="col text-center">\n' +
	                '                        <p class="font-weight-bold text-secondary mt-3 mb-4 text-left">CLOCK SPEED</p>\n' +
	                '                        <div class="gauge gauge-big gauge-green gaugeClock'+i+'">\n' +
	                '                            <div class="gauge-arrow" data-percentage="9"\n' +
	                '                                 style="transform: rotate(0deg);"></div>\n' +
	                '                        </div>\n' +
	                '                        <h5 class="mt-4 text-secondary gpuclocktext'+i+'"></h5>\n' +
	                '                    </div>\n' +
	                '\n' +
	                '                    <div class="col text-center">\n' +
	                '                        <p class="font-weight-bold text-secondary mt-3 mb-4 text-left">POWER</p>\n' +
	                '                        <div class="gauge gauge-big gauge-green gaugePower'+i+'">\n' +
	                '                            <div class="gauge-arrow" data-percentage="9"\n' +
	                '                                 style="transform: rotate(0deg);"></div>\n' +
	                '                        </div>\n' +
	                '                        <h5 class="mt-4 text-secondary gpupowertext'+i+'"></h5>\n' +
	                '                    </div>\n' +
	                '                </div>\n' +
	                '\n' +
	                '                <div class="row text-right mt-3">\n'+ 
	                '<div class="col">' +
	                '                    <a href="#" style="color: black;" onclick="detail_button();" id="gpudetail'+i+'text">상세보기 <i class="fa fa-caret-down" aria-hidden="true"></i></a>\n' +
	                '                </div>' +
	                '</div>\n' +
	                '\n' +
	                '                <hr class="m-2 mt-3 mb-3">\n' +
	                '\n' +
	                '\n' +
	                '                <div id="gpudetail'+i+'" style="display: none;">\n' +
	                '                    <div class="row ml-2">\n' +
	                '                        <div class="col">\n' +
	                '                            <p style="color:#000;">TEMP</p>\n' +
	                '                            <div class="row mt-2">\n' +
	                '                                <div class="col ml-3">\n' +
	                '                                    <svg class="ml-3" id="tempchart'+i+'"></svg>\n' +
	                '                                </div>\n' +
	                '                                <div class="col-2" style="margin-bottom: auto;margin-top: auto">\n' +
	                '                                    <table class="table text-center table-hover border-bottom">\n' +
	                '                                        <tr>\n' +
	                '                                            <td class="font-weight-bold" scope="col">MAX</td>\n' +
	                '                                            <td scope="col" id="gputempmax'+i+'"></td>\n' +
	                '                                        </tr>\n' +
	                '                                        <tr>\n' +
	                '                                            <td class="font-weight-bold">min</th>\n' +
	                '                                            <td id="gputempmin'+i+'"></td>\n' +
	                '                                        </tr>\n' +
	                '                                    </table>\n' +
	                '                                </div>\n' +
	                '                            </div>\n' +
	                '                        </div>\n' +
	                '                    </div>\n' +
	                '\n' +
	                '                    <br>\n' +
	                '\n' +
	                '                    <div class="row ml-2">\n' +
	                '                        <div class="col">\n' +
	                '                            <p style="color:#000;">MEM LOAD</p>\n' +
	                '                            <div class="row mt-2">\n' +
	                '                                <div class="col ml-3">\n' +
	                '                                    <svg class="ml-3" id="memchart'+i+'"></svg>\n' +
	                '                                </div>\n' +
	                '                                <div class="col-2" style="margin-bottom: auto;margin-top: auto">\n' +
	                '                                    <table class="table text-center table-hover border-bottom">\n' +
	                '                                        <tr>\n' +
	                '                                            <td class="font-weight-bold" scope="col">MAX</td>\n' +
	                '                                            <td scope="col" id="gpumemmax'+i+'"></td>\n' +
	                '                                        </tr>\n' +
	                '                                        <tr>\n' +
	                '                                            <td class="font-weight-bold">min</th>\n' +
	                '                                            <td id="gpumemmin'+i+'"></td>\n' +
	                '                                        </tr>\n' +
	                '                                    </table>\n' +
	                '                                </div>\n' +
	                '                            </div>\n' +
	                '                        </div>\n' +
	                '                    </div>\n' +
	                '\n' +
	                '                    <br>\n' +
	                '\n' +
	                '                    <div class="row ml-2 mt-2">\n' +
	                '                        <div class="col">\n' +
	                '                            <p style="color:#000;">CLOCK SPEED</p>\n' +
	                '                            <div class="row">\n' +
	                '                                <div class="col ml-3">\n' +
	                '                                    <svg class="ml-3" id="clockchart'+i+'"></svg>\n' +
	                '                                </div>\n' +
	                '                                <div class="col-2" style="margin-bottom: auto;margin-top: auto">\n' +
	                '                                    <table class="table text-center table-hover border-bottom">\n' +
	                '                                        <tr>\n' +
	                '                                            <td class="font-weight-bold" scope="col">MAX</td>\n' +
	                '                                            <td scope="col" id="gpuclockmax'+i+'"></td>\n' +
	                '                                        </tr>\n' +
	                '                                        <tr>\n' +
	                '                                            <td class="font-weight-bold">min</th>\n' +
	                '                                            <td id="gpuclockmin'+i+'"></td>\n' +
	                '                                        </tr>\n' +
	                '                                    </table>\n' +
	                '                                </div>\n' +
	                '                            </div>\n' +
	                '                        </div>\n' +
	                '                    </div> <hr>\n' +
	                '\n' +
	                '                    <br>\n' +
	                '\n' +
	                '                    <div class="row ml-2 mt-2">\n' +
	                '                        <div class="col">\n' +
	                '                            <p style="color:#000;">POWER</p>\n' +
	                '                            <div class="row">\n' +
	                '                                <div class="col ml-3">\n' +
	                '                                    <svg class="ml-3" id="powerchart'+i+'"></svg>\n' +
	                '                                </div>\n' +
	                '                                <div class="col-2" style="margin-bottom: auto;margin-top: auto">\n' +
	                '                                    <table class="table text-center table-hover border-bottom">\n' +
	                '                                        <tr>\n' +
	                '                                            <td class="font-weight-bold" scope="col">MAX</td>\n' +
	                '                                            <td scope="col" id="gpupowermax'+i+'"></td>\n' +
	                '                                        </tr>\n' +
	                '                                        <tr>\n' +
	                '                                            <td class="font-weight-bold">min</th>\n' +
	                '                                            <td id="gpupowermin'+i+'"></td>\n' +
	                '                                        </tr>\n' +
	                '                                    </table>\n' +
	                '                                </div>\n' +
	                '                            </div>\n' +
	                '                        </div>\n' +
	                '                    </div> <hr>\n' +
	                '\n' +
	                '                </div>\n' +
	                '\n' +
	                '\n' +
	                '            </div>';              
	               
	            document.getElementById('gpu').appendChild(div);

	            if(data.data.result[i - 1].value[1]>60){
	                $(".gpumem"+ i.toString()).addClass("orange");
	            }else{
	                $(".gpumem"+ i.toString()).addClass("green");
	            }
	            
	            $('.gpumem' + i.toString()).addClass("p" + data.data.result[i - 1].value[1]);
	            $('.gpumemtext' + i.toString()).text(data.data.result[i - 1].value[1] + "%");

	            // 게이지 차트 만들어주기 위함(이거도 개수만큼)
	            //이거 선언해줘야 뒤에서 update해도 정상적으로 작동함.
	            $('.gaugeClock'+i+' .gauge-arrow').cmGauge();
	            $('.gaugePower'+i+' .gauge-arrow').cmGauge();
	        }
	        
	    },
	    error: function(err){
	        console.log(err);
	    }

	});
	
	update();
	
	setInterval(function() {
        update();
    }, 15000); 

});

var opendisplay;

function detail_button(){
	var id = window.event.target.id;
	var detail = id.replace('text', '');
	
	clearInterval(timer);

	now = Math.round(new Date().getTime() / 1000);
	loadDt = new Date();
	time = new Date(Date.parse(loadDt) - 1000 * 60 * 60);
	start = time.getTime() / 1000;
	
	if(opendisplay != detail){
		//현재 열려있는 display 다 닫아주기
		for(var i = 1 ; i <= length ; i ++ ){
		 	$('#gpudetail'+i).css("display","none"); 
		    $('#gpudetail'+i+'text').html("상세보기 <i class=\"fa fa-caret-down\" aria-hidden=\"true\"></i>");
		    
			d3.selectAll("#tempchart"+i+" > *").remove();
			d3.selectAll("#memchart"+i+" > *").remove();
			d3.selectAll("#clockchart"+i+" > *").remove(); 
			d3.selectAll("#powerchart"+i+" > *").remove(); 
		} 
		$('#'+detail).css("display","block");
		$('#'+detail+'text').html("상세보기 <i class=\"fa fa-caret-up\" aria-hidden=\"true\"></i>");
		
		var lastChar = detail.substr(detail.length - 1)
		updatechart(lastChar);
		
		opendisplay = detail;
	}else{
		$('#'+detail).css("display","none");
		$('#'+detail+'text').html("상세보기 <i class=\"fa fa-caret-down\" aria-hidden=\"true\"></i>");
		opendisplay = null;
	}
}

function update(){
	$.ajax({
	    url:"<%=cp%>/get/single/gpu",
	    type:"POST",
	    dataType:"json",
	    async:false,
	    data:{},
	    success:function(data){
			
			length =  data.data.result.length;
	        	        
	        for(var i = 1 ; i <= length; i++){      
	            if(data.data.result[i - 1].value[1]>60){
	                $(".gpumem"+ i.toString()).removeClass("green");
	                $(".gpumem"+ i.toString()).addClass("orange");
	            }else{
	                $(".gpumem"+ i.toString()).removeClass("orange");
	                $(".gpumem"+ i.toString()).addClass("green");
	            }

	            var text = $( '.gpumem' + i.toString() ).attr( 'class' );
	            var str = text.split(" ");
	            
	            var p = null;
	            for(var j = 0 ; j < str.length ; j++){
	            	if(str[j].startsWith("p")==true){
	            		p = str[j];
	            	}
	            }
	            	            
	            $('.gpumem' + i.toString()).removeClass(p);
	            $('.gpumem' + i.toString()).addClass("p" + data.data.result[i - 1].value[1]);
	            $('.gpumemtext' + i.toString()).text(data.data.result[i - 1].value[1] + "%");
	        }
	        
	    },
	    error: function(err){
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
	            $('.gaugeClock' + i.toString() + " .gauge-arrow").trigger('updateGauge', data.data.result[i-1].value[1] / 2000 * 100);
	            $('.gpuclocktext' + i.toString()).text(data.data.result[i-1].value[1]+" Ghz");
	        }
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
	    url:"<%=cp%>/get/single/gpu_power",
	    type:"POST",
	    dataType:"json",
	    async:false,
	    data:{},
	    success:function(data){
	    	// 0-400 W
	    	for(var i = 1 ; i <= data.data.result.length; i++){
		            $('.gaugePower' + i.toString() + " .gauge-arrow").trigger('updateGauge', data.data.result[i-1].value[1] / 400 * 100);
		            $('.gpupowertext' + i.toString()).text(Math.round(data.data.result[i-1].value[1])+" W");
		        }
	    },
	    error: function(err){
	        console.log(err);
	    }

	});
}

function updatechart(i){
	var num = Number(i)-1;

	$.ajax({
	    url:"<%=cp%>/get/gpu_temp",
	    type:"POST",
	    dataType:"json",
	    async:false,
	    data:{"start":start, "end": now, "step":15},
	    success:function(data){
	        dataset[0] = data.data.result[num].values;
	        
	        var arr = new Array();

	        for(var j = 0 ; j < dataset[0].length ; j++){
	            arr.push(data.data.result[num].values[j][1]);
	        }

	        //javascript에서 제공하는 min,max
	        max[0] = Math.max.apply(null, arr);
	        min[0] = Math.min.apply(null, arr);

	        //d3에서 제공하는 min,mix 
	        //d3.extent(arr, function (el){return el})
	        
	        //뭐가 빠른지모르겠음
	        
	        $('#gputempmax'+i).text(max[0] + " °C");
	        $('#gputempmin'+i).text(min[0] + " °C");

	        
	        console.log();

	    },
	    error: function(err){
	        console.log(err);
	    }

	});
	
	$.ajax({
	    url:"<%=cp%>/get/gpu",
	    type:"POST",
	    dataType:"json",
	    async:false,
	    data:{"start":start, "end": now, "step":15},
	    success:function(data){
	    	dataset[1] = data.data.result[num].values;

	        var arr = new Array();

	        for(var j = 0 ; j < dataset[1].length ; j++){
	            arr.push(data.data.result[num].values[j][1]);
	        }

	        max[1] = Math.max.apply(null, arr);
	        min[1] = Math.min.apply(null, arr);

	        $('#gpumemmax'+i).text(max[1] +" %");
	        $('#gpumemmin'+i).text(min[1] +" %");

	    },
	    error: function(err){
	        console.log(err);
	    }

	});

	$.ajax({
	    url:"<%=cp%>/get/gpu_clock",
	    type:"POST",
	    dataType:"json",
	    async:false,
	    data:{"start":start, "end": now, "step":15},
	    success:function(data){
	    	dataset[2] = data.data.result[num].values;

	        var arr = new Array();

	        for(var j = 0 ; j < dataset[2].length ; j++){
	            arr.push(data.data.result[num].values[j][1]);
	        }

	        max[2] = Math.max.apply(null, arr);
	        min[2] = Math.min.apply(null, arr);

	        $('#gpuclockmax'+i).text(max[2] + " Ghz");
	        $('#gpuclockmin'+i).text(min[2] + " Ghz");
	    },
	    error: function(err){
	        console.log(err);
	    }

	});
	
	$.ajax({
	    url:"<%=cp%>/get/gpu_power",
	    type:"POST",
	    dataType:"json",
	    async:false,
	    data:{"start":start, "end": now, "step":15},
	    success:function(data){
	    	dataset[3] = data.data.result[num].values;

	        var arr = new Array();

	        for(var j = 0 ; j < dataset[2].length ; j++){
	            arr.push(data.data.result[num].values[j][1]);
	        }

	        max[3] = Math.max.apply(null, arr);
	        min[3] = Math.min.apply(null, arr);

	        $('#gpupowermax'+i).text(Math.round(max[3]) + " W");
	        $('#gpupowermin'+i).text(Math.round(min[3]) + " W");
	    },
	    error: function(err){
	        console.log(err);
	    }

	});
	
	setchart(i);
}   

var xScal = null, yScale = null, path=null, xAxis=null, yAxis=null, line=null, svg=null, margin=null;
var xScal2 = null, yScale2 = null, path2=null, xAxis2=null, yAxis2=null, line2=null, svg2=null, margin2=null;
var xScal3 = null, yScale3 = null, path3=null, xAxis3=null, yAxis3=null, line3=null, svg3=null, margin3=null;
var xScal4 = null, yScale4 = null, path4=null, xAxis4=null, yAxis4=null, line4=null, svg4=null, margin4=null;

function setchart(i){
	
	margin = {top: 20, right: 20, bottom: 20, left: 40}
	    , width = 940 - margin.left - margin.right
	    , height = 250 - margin.top - margin.bottom; 

	xScale = d3.scaleTime()
	    .domain([moment.unix(dataset[0][0][0]).toDate(), moment.unix(dataset[0][dataset[0].length-1][0]).toDate()]) // input
	    .range([0, width]); // output
	    
	yScale = d3.scaleLinear()
		.domain([Number(min[0])-1, Number(max[0])+1]) // input      
	    .range([height, 0]); // output
	    
	line = d3.line()
	    .x(function(d, i) { return xScale(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return yScale(d[1]); }) // set the y values for the line generator
	    .curve(d3.curveMonotoneX);// apply smoothing to the line
	    
	svg = d3.select("#tempchart"+i)
	    .attr("width", width + margin.left + margin.right+40)
	    .attr("height", height + margin.top + margin.bottom)
	    .append("g")
	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	xAxis = svg.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")")
	    .call(d3.axisBottom(xScale)); // Create an axis component with d3.axisBottom

	yAxis = svg.append("g")
		.attr("class", "y axis")
		.call(d3.axisLeft(yScale)); // Create an axis component with d3.axisLeft
		   

	path = svg.append("path") 
	    .datum(dataset[0]) // 10. Binds data to the line
	    .attr("class", "line1") // Assign a class for styling
	    .attr("d", line); // 11. Calls the line generato

	svg.append("circle").attr("cx",835).attr("cy", 0).attr("r", 6).style("fill", "steelblue")
	svg.append("text").attr("x", 845).attr("y", 0).text("temp").style("font-size", "15px").attr("alignment-baseline","middle")
	
	var mouseG = svg.append("g")
        .attr("class", "mouse-over-effects");

    mouseG.append("path") // this is the black vertical line to follow mouse
        .attr("class", "mouse-line")
        .style("stroke", "black")
        .style("stroke-width", "1px")
        .style("opacity", "0");

    var lines = document.getElementsByClassName('line1');

    var mousePerLine = mouseG.selectAll('.mouse-per-line')
        .data(dataset[0])
        .enter()
        .append("g")
        .attr("class", "mouse-per-line");

    mousePerLine.append("circle")
        .attr("r", 7)
        .style("stroke", "steelblue")
        .style("fill", "none")
        .style("stroke-width", "1px")
        .style("opacity", "0");

    mousePerLine.append("text")
        .attr("transform", "translate(10,-5)");

    mouseG.append('svg:rect') // append a rect to catch mouse movements on canvas
        .attr('width', width) // can't catch mouse events on a g element
        .attr('height', height)
        .attr('fill', 'none')
        .attr('pointer-events', 'all')
        .on('mouseout', function() { // on mouse out hide line, circles and text
            d3.select(".mouse-line")
                .style("opacity", "0");
            d3.select(".mouse-per-line circle")
                .style("opacity", "0");
            d3.select(".mouse-per-line text")
                .style("opacity", "0");
        })
        .on('mouseover', function() { // on mouse in show line, circles and text
            d3.select(".mouse-line")
                .style("opacity", "1");
            d3.select(".mouse-per-line circle")
                .style("opacity", "1");
            d3.select(".mouse-per-line text")
                .style("opacity", "1");
        })
        .on('mousemove', function() { // mouse moving over canvas
            var mouse = d3.mouse(this);
            d3.select(".mouse-line")
                .attr("d", function() {
                    var d = "M" + mouse[0] + "," + height;
                    d += " " + mouse[0] + "," + 0;
                    return d;
                });

            d3.selectAll(".mouse-per-line")
                .attr("transform", function(d, i) {
                    //console.log(width/mouse[0])
                    var xDate = xScale.invert(mouse[0]),
                        bisect = d3.bisector(function(d) { return d.date; }).right;
                    idx = bisect(d.values, xDate);
                    
                    var beginning = 0,
                        end = lines[i].getTotalLength(),
                        target = null;

                    while (true){
                        target = Math.floor((beginning + end) / 2);
                        pos = lines[i].getPointAtLength(target);
                        if ((target === end || target === beginning) && pos.x !== mouse[0]) {
                            break;
                        }
                        if (pos.x > mouse[0])      end = target;
                        else if (pos.x < mouse[0]) beginning = target;
                        else break; //position found
                    }
					/* 
                    d3.select(this).select('text')
                    	.text(Math.round(yScale.invert(pos.y)));
                     */
                     
                     /* 
                     d3.select(this).select('text')
	                     .html(getTime(xScale.invert(pos.x))+", ")
	                     .attr("font-size", "12px")
	                     //.enter().append("tspan")
	                     .append("br")
	                     .html(Math.round(yScale.invert(pos.y)))
	                     .attr("font-size", "12px");
                      */
                   
                      d3.select(this).select('text')
	                    .html(getTime(xScale.invert(pos.x))+", <br>"+Math.round(yScale.invert(pos.y)))
	                    .attr("class", "tooltip-date");
                       
                    return "translate(" + mouse[0] + "," + pos.y +")";
                });
        });  
    
	margin2 = {top: 20, right: 20, bottom: 20, left: 40}
    , width2 = 940 - margin2.left - margin2.right
    , height2 = 250 - margin2.top - margin2.bottom;

	xScale2 = d3.scaleTime()
	    .domain([moment.unix(dataset[1][0][0]).toDate(), moment.unix(dataset[1][dataset[1].length-1][0]).toDate()])
	    .range([0, width2]);

	yScale2 = d3.scaleLinear()
	    .domain([min[1]-1, max[1]+1]) 
	    .range([height2, 0]); 

	line2 = d3.line()
	    .x(function(d, i) { return xScale2(moment.unix(d[0]).toDate()); })
	    .y(function(d) { return yScale2(d[1]); }) 
	    .curve(d3.curveMonotoneX)
	    ;

	svg2 = d3.select("#memchart"+i)
	    .attr("width", width2 + margin2.left + margin2.right+40)
	    .attr("height", height2 + margin2.top + margin2.bottom)
	    .append("g")
	    .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");

	xAxis2 = svg2.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height2 + ")")
	    .call(d3.axisBottom(xScale2));

	yAxis2 = svg2.append("g")
	    .attr("class", "y axis")
	    .call(d3.axisLeft(yScale2));

	path2 = svg2.append("path")
	    .datum(dataset[1]) 
	    .attr("class", "line2") 
	    .attr("d", line2);
	
	svg2.append("circle").attr("cx",815).attr("cy", 0).attr("r", 6).style("fill", "orange")
	svg2.append("text").attr("x", 825).attr("y", 0).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")
	
	var mouseG2 = svg2.append("g")
        .attr("class", "mouse-over-effects");

    mouseG2.append("path") // this is the black vertical line to follow mouse
        .attr("class", "mouse-line2")
        .style("stroke", "black")
        .style("stroke-width", "1px")
        .style("opacity", "0");

    var lines2 = document.getElementsByClassName('line2');

    var mousePerLine2 = mouseG2.selectAll('.mouse-per-line2')
        .data(dataset[1])
        .enter()
        .append("g")
        .attr("class", "mouse-per-line2");

    mousePerLine2.append("circle")
        .attr("r", 7)
        .style("stroke", "orange")
        .style("fill", "none")
        .style("stroke-width", "1px")
        .style("opacity", "0");

    mousePerLine2.append("text")
        .attr("transform", "translate(10,-5)");

    mouseG2.append('svg:rect') // append a rect to catch mouse movements on canvas
        .attr('width', width2) // can't catch mouse events on a g element
        .attr('height', height2)
        .attr('fill', 'none')
        .attr('pointer-events', 'all')
        .on('mouseout', function() { // on mouse out hide line, circles and text
            d3.select(".mouse-line2")
                .style("opacity", "0");
            d3.select(".mouse-per-line2 circle")
                .style("opacity", "0");
            d3.select(".mouse-per-line2 text")
                .style("opacity", "0");
        })
        .on('mouseover', function() { // on mouse in show line, circles and text
            d3.select(".mouse-line2")
                .style("opacity", "1");
            d3.select(".mouse-per-line2 circle")
                .style("opacity", "1");
            d3.select(".mouse-per-line2 text")
                .style("opacity", "1");
        })
        .on('mousemove', function() { // mouse moving over canvas
            var mouse = d3.mouse(this);
            d3.select(".mouse-line2")
                .attr("d", function() {
                    var d = "M" + mouse[0] + "," + height2;
                    d += " " + mouse[0] + "," + 0;
                    return d;
                });

            d3.selectAll(".mouse-per-line2")
                .attr("transform", function(d, i) {
                    //console.log(width/mouse[0])
                    var xDate = xScale2.invert(mouse[0]),
                        bisect = d3.bisector(function(d) { return d.date; }).right;
                    idx = bisect(d.values, xDate);

                    var beginning = 0,
                        end = lines2[i].getTotalLength(),
                        target = null;

                    while (true){
                        target = Math.floor((beginning + end) / 2);
                        pos = lines2[i].getPointAtLength(target);
                        if ((target === end || target === beginning) && pos.x !== mouse[0]) {
                            break;
                        }
                        if (pos.x > mouse[0])      end = target;
                        else if (pos.x < mouse[0]) beginning = target;
                        else break; //position found
                    }
					/* 
                    d3.select(this).select('text')
                        .text(Math.round(yScale2.invert(pos.y)));
                     */
                    d3.select(this).select('text')
	                    .html(getTime(xScale2.invert(pos.x))+", <br>"+Math.round(yScale2.invert(pos.y)))
	                    .attr("class", "tooltip-date");

                    return "translate(" + mouse[0] + "," + pos.y +")";
                });
        });
    	
	margin3 = {top: 20, right: 20, bottom: 20, left: 40}
	    , width3 = 940 - margin3.left - margin3.right
	    , height3 = 250 - margin3.top - margin3.bottom; 
	
	xScale3 = d3.scaleTime()
	    .domain([moment.unix(dataset[2][0][0]).toDate(), moment.unix(dataset[2][dataset[2].length-1][0]).toDate()]) // input
	    .range([0, width3]);
	    
	yScale3 = d3.scaleLinear()
	    .domain([min[2]-100, max[2]+100]) 
	    .range([height3, 0]); 
	
	line3 = d3.line()
	    .x(function(d, i) { return xScale3(moment.unix(d[0]).toDate()); }) 
	    .y(function(d) { return yScale3(d[1])}) 
	    .curve(d3.curveMonotoneX);
	
	svg3 = d3.select("#clockchart"+i)
	    .attr("width", width3 + margin3.left + margin3.right + 40)
	    .attr("height", height3 + margin3.top + margin3.bottom)
	    .append("g")
	    .attr("transform", "translate(" + margin3.left + "," + margin3.top + ")");
	
	xAxis3 = svg3.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height3 + ")")
	    .call(d3.axisBottom(xScale3));
	    
	yAxis3 = svg3.append("g")
	    .attr("class", "y axis")
	    .call(d3.axisLeft(yScale3));
	    
	path3 = svg3.append("path")
	    .datum(dataset[2])
	    .attr("class", "line3") 
	    .attr("d", line3); 
	    
	svg3.append("circle").attr("cx",790).attr("cy", 0).attr("r", 6).style("fill", "green")
	svg3.append("text").attr("x", 800).attr("y", 0).text("clock speed").style("font-size", "15px").attr("alignment-baseline","middle")
	
	var mouseG3 = svg3.append("g")
        .attr("class", "mouse-over-effects");

    mouseG3.append("path") // this is the black vertical line to follow mouse
        .attr("class", "mouse-line3")
        .style("stroke", "black")
        .style("stroke-width", "1px")
        .style("opacity", "0");

    var lines3 = document.getElementsByClassName('line3');

    var mousePerLine3 = mouseG3.selectAll('.mouse-per-line3')
        .data(dataset[2])
        .enter()
        .append("g")
        .attr("class", "mouse-per-line3");

    mousePerLine3.append("circle")
        .attr("r", 7)
        .style("stroke", "green")
        .style("fill", "none")
        .style("stroke-width", "1px")
        .style("opacity", "0");

    mousePerLine3.append("text")
        .attr("transform", "translate(10,-5)");

    mouseG3.append('svg:rect') // append a rect to catch mouse movements on canvas
        .attr('width', width3) // can't catch mouse events on a g element
        .attr('height', height3)
        .attr('fill', 'none')
        .attr('pointer-events', 'all')
        .on('mouseout', function() { // on mouse out hide line, circles and text
            d3.select(".mouse-line3")
                .style("opacity", "0");
            d3.select(".mouse-per-line3 circle")
                .style("opacity", "0");
            d3.select(".mouse-per-line3 text")
                .style("opacity", "0");
        })
        .on('mouseover', function() { // on mouse in show line, circles and text
            d3.select(".mouse-line3")
                .style("opacity", "1");
            d3.select(".mouse-per-line3 circle")
                .style("opacity", "1");
            d3.select(".mouse-per-line3 text")
                .style("opacity", "1");
        })
        .on('mousemove', function() { // mouse moving over canvas
            var mouse = d3.mouse(this);
            d3.select(".mouse-line3")
                .attr("d", function() {
                    var d = "M" + mouse[0] + "," + height3;
                    d += " " + mouse[0] + "," + 0;
                    return d;
                });

            d3.selectAll(".mouse-per-line3")
                .attr("transform", function(d, i) {
                    //console.log(width/mouse[0])
                    var xDate = xScale3.invert(mouse[0]),
                        bisect = d3.bisector(function(d) { return d.date; }).right;
                    idx = bisect(d.values, xDate);

                    var beginning = 0,
                        end = lines3[i].getTotalLength(),
                        target = null;

                    while (true){
                        target = Math.floor((beginning + end) / 2);
                        pos = lines3[i].getPointAtLength(target);
                        if ((target === end || target === beginning) && pos.x !== mouse[0]) {
                            break;
                        }
                        if (pos.x > mouse[0])      end = target;
                        else if (pos.x < mouse[0]) beginning = target;
                        else break; //position found
                    }
					/* 
                    d3.select(this).select('text')
                        .text(Math.round(yScale3.invert(pos.y)));
                     */
                     
                    d3.select(this).select('text')
	                    .html(getTime(xScale3.invert(pos.x))+", <br>"+Math.round(yScale3.invert(pos.y)))
	                    .attr("class", "tooltip-date");


                    return "translate(" + mouse[0] + "," + pos.y +")";
                });
        });
    
    margin4 = {top: 20, right: 20, bottom: 20, left: 40}
	    , width4 = 940 - margin4.left - margin4.right
	    , height4 = 250 - margin4.top - margin4.bottom; 
	
	xScale4 = d3.scaleTime()
	    .domain([moment.unix(dataset[3][0][0]).toDate(), moment.unix(dataset[3][dataset[3].length-1][0]).toDate()]) // input
	    .range([0, width4]);
	    
	yScale4 = d3.scaleLinear()
	    .domain([min[3]-10, max[3]+10]) 
	    .range([height4, 0]); 
	
	line4 = d3.line()
	    .x(function(d, i) { return xScale4(moment.unix(d[0]).toDate()); }) 
	    .y(function(d) { return yScale4(d[1])}) 
	    .curve(d3.curveMonotoneX);
	
	svg4 = d3.select("#powerchart"+i)
	    .attr("width", width4 + margin4.left + margin4.right + 40)
	    .attr("height", height4 + margin4.top + margin4.bottom)
	    .append("g")
	    .attr("transform", "translate(" + margin4.left + "," + margin4.top + ")");
	
	xAxis4 = svg4.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height4 + ")")
	    .call(d3.axisBottom(xScale4));
	    
	yAxis4 = svg4.append("g")
	    .attr("class", "y axis")
	    .call(d3.axisLeft(yScale4));
	    
	path4 = svg4.append("path")
	    .datum(dataset[3])
	    .attr("class", "line4") 
	    .attr("d", line4); 
	    
	svg4.append("circle").attr("cx",830).attr("cy", 0).attr("r", 6).style("fill", "gray")
	svg4.append("text").attr("x", 840).attr("y", 0).text("power").style("font-size", "15px").attr("alignment-baseline","middle")

    var mouseG4 = svg4.append("g")
        .attr("class", "mouse-over-effects");

    mouseG4.append("path") // this is the black vertical line to follow mouse
        .attr("class", "mouse-line4")
        .style("stroke", "black")
        .style("stroke-width", "1px")
        .style("opacity", "0");

    var lines4 = document.getElementsByClassName('line4');

    var mousePerLine4 = mouseG4.selectAll('.mouse-per-line4')
        .data(dataset[3])
        .enter()
        .append("g")
        .attr("class", "mouse-per-line4");

    mousePerLine4.append("circle")
        .attr("r", 7)
        .style("stroke", "gray")
        .style("fill", "none")
        .style("stroke-width", "1px")
        .style("opacity", "0");

    mousePerLine4.append("text")
        .attr("transform", "translate(10,-5)");

    mouseG4.append('svg:rect') // append a rect to catch mouse movements on canvas
        .attr('width', width4) // can't catch mouse events on a g element
        .attr('height', height4)
        .attr('fill', 'none')
        .attr('pointer-events', 'all')
        .on('mouseout', function() { // on mouse out hide line, circles and text
            d3.select(".mouse-line4")
                .style("opacity", "0");
            d3.select(".mouse-per-line4 circle")
                .style("opacity", "0");
            d3.select(".mouse-per-line4 text")
                .style("opacity", "0");
        })
        .on('mouseover', function() { // on mouse in show line, circles and text
            d3.select(".mouse-line4")
                .style("opacity", "1");
            d3.select(".mouse-per-line4 circle")
                .style("opacity", "1");
            d3.select(".mouse-per-line4 text")
                .style("opacity", "1");
        })
        .on('mousemove', function() { // mouse moving over canvas
            var mouse = d3.mouse(this);
            d3.select(".mouse-line4")
                .attr("d", function() {
                    var d = "M" + mouse[0] + "," + height4;
                    d += " " + mouse[0] + "," + 0;
                    return d;
                });

            d3.selectAll(".mouse-per-line4")
                .attr("transform", function(d, i) {
                    //console.log(width/mouse[0])
                    var xDate = xScale4.invert(mouse[0]),
                        bisect = d3.bisector(function(d) { return d.date; }).right;
                    idx = bisect(d.values, xDate);

                    var beginning = 0,
                        end = lines4[i].getTotalLength(),
                        target = null;

                    while (true){
                        target = Math.floor((beginning + end) / 2);
                        pos = lines4[i].getPointAtLength(target);
                        if ((target === end || target === beginning) && pos.x !== mouse[0]) {
                            break;
                        }
                        if (pos.x > mouse[0])      end = target;
                        else if (pos.x < mouse[0]) beginning = target;
                        else break; //position found
                    }
					/* 
                    d3.select(this).select('text')
                        .text(Math.round(yScale4.invert(pos.y)));
                    */
                    d3.select(this).select('text')
	                    .html(getTime(xScale4.invert(pos.x))+", <br>"+Math.round(yScale4.invert(pos.y)))
	                    .attr("class", "tooltip-date");

                    return "translate(" + mouse[0] + "," + pos.y +")";
                });
        });
    
	timer = setInterval(function() {
		tick(i);
		tick2(i);
		tick3(i);
		tick4(i);
    }, 15000); 
}						


function tick(i) {
    var pushdata = null;
    
    $.ajax({
        url:"<%=cp%>/get/single/gpu_temp",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[i - 1].value;
        },
        error: function(err){
            console.log(err);
        }

    });

    dataset[0].push(pushdata);

    dataset[0].shift();

    var arr = new Array();
    
    for(var j = 0 ; j < dataset[0].length ; j++){
        arr.push(dataset[0][j][1]);
    }
    
    max[0] = Math.max.apply(null, arr);
    min[0] = Math.min.apply(null, arr);
    
    //console.log("min : " + min[0]+", max : " + max[0]);

    $('#gputempmax'+i).text(max[0] + " °C");
    $('#gputempmin'+i).text(min[0] + " °C");

    xScale.domain([moment.unix(dataset[0][0][0]).toDate(), moment.unix(dataset[0][dataset[0].length-1][0]).toDate()]);
    yScale.domain([min[0]-1, max[0]+1]);

    path
        .attr("d", line)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale(moment.unix(dataset[0][0][0]).toDate()) + ")");

    xAxis.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        //.call(d3.axisBottom(xScale))
        //.attr("transform", "translate(" + xScale(moment.unix(dataset1[0][0]).toDate()) + ",0)")  // 왼쪽으로 민다.
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(xScale)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;

    yAxis.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;
}

function tick2(i) {
    var pushdata = null;
    
    $.ajax({
        url:"<%=cp%>/get/single/gpu",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[i - 1].value;
            //pushdata = [data.data.result[0].value[0] , String(data.data.result[0].value[1]/Math.pow(10,9).toFixed(1))];
        },
        error: function(err){
            console.log(err);
        }

    });

    dataset[1].push(pushdata);

    dataset[1].shift();

    var arr = new Array();

    for(var j = 0 ; j < dataset[1].length ; j++){
        arr.push(dataset[1][j][1]);
    }

    max[1] = Math.max.apply(null, arr);
    min[1] = Math.min.apply(null, arr);

    $('#gpumemmax'+i).text(max[1]+" %");
    $('#gpumemmin'+i).text(min[1]+" %");

    xScale2.domain([moment.unix(dataset[1][0][0]).toDate(), moment.unix(dataset[1][dataset[1].length-1][0]).toDate()]);
    yScale2.domain([min[1]-1, max[1]+1]);

    path2
        .attr("d", line2)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale2(moment.unix(dataset[1][0][0]).toDate()) + ")");

    xAxis2.transition() 
        .duration(750)
        .ease(d3.easeLinear)
        .attr("transform", "translate(0," + height2 + ")")
        .call(d3.axisBottom(xScale2))
        .transition(); 

    yAxis2.transition() 
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale2)) 
        .transition();
}

function tick3(i) {
    var pushdata = null;
    
    $.ajax({
        url:"<%=cp%>/get/single/gpu_clock",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[i - 1].value;
        },
        error: function(err){
            console.log(err);
        }

    });

    dataset[2].push(pushdata);

    dataset[2].shift();

    var arr = new Array();

    for(var j = 0 ; j < dataset[2].length ; j++){
        arr.push(dataset[2][j][1]);
    }

    max[2] = Math.max.apply(null, arr);
    min[2] = Math.min.apply(null, arr);

    $('#gpuclockmax'+i).text(max[2] +" Ghz");
    $('#gpuclockmin'+i).text(min[2] +" Ghz");

    xScale3.domain([moment.unix(dataset[2][0][0]).toDate(), moment.unix(dataset[2][dataset[2].length-1][0]).toDate()]);
    yScale3.domain([min[2]-100, max[2]+100]);

    path3
        .attr("d", line3)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale3(moment.unix(dataset[2][0][0]).toDate()) + ")");

    xAxis3.transition() 
        .duration(750)
        .ease(d3.easeLinear)
        .attr("transform", "translate(0," + height3 + ")")
        .call(d3.axisBottom(xScale3)) 
        .transition(); 

    yAxis3.transition()
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale3))
        .transition(); 
}


function tick4(i) {
    var pushdata = null;
    
    $.ajax({
        url:"<%=cp%>/get/single/gpu_power",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[i - 1].value;
            //pushdata = [data.data.result[0].value[0] , String(data.data.result[0].value[1]/Math.pow(10,9).toFixed(1))];
        },
        error: function(err){
            console.log(err);
        }

    });

    dataset[3].push(pushdata);

    dataset[3].shift();

    var arr = new Array();

    for(var j = 0 ; j < dataset[3].length ; j++){
        arr.push(dataset[3][j][1]);
    }

    max[3] = Math.max.apply(null, arr);
    min[3] = Math.min.apply(null, arr);

    $('#gpupowermax'+i).text(Math.round(max[3])+" W");
    $('#gpupowermin'+i).text(Math.round(min[3])+" W");

    xScale4.domain([moment.unix(dataset[3][0][0]).toDate(), moment.unix(dataset[3][dataset[3].length-1][0]).toDate()]);
    yScale4.domain([min[3]-10, max[3]+10]);

    path4
        .attr("d", line4)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale4(moment.unix(dataset[3][0][0]).toDate()) + ")");

    xAxis4.transition() 
        .duration(750)
        .ease(d3.easeLinear)
        .attr("transform", "translate(0," + height4 + ")")
        .call(d3.axisBottom(xScale4))
        .transition(); 

    yAxis4.transition() 
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale4)) 
        .transition();
}

function getTime(d) {
	var time = d;
	
    var yyyy = time.getFullYear();
    var MM = time.getMonth() + 1; //January is 0!
    var dd = time.getDate();
    var hh = time.getHours();
    var mm = time.getMinutes();
    var ss = time.getSeconds();

    if (MM < 10) {
        MM = '0' + MM
    }
    if (dd < 10) {
        dd = '0' + dd
    }

    if (hh < 10) {
        hh = '0' + hh
    }

    if (mm < 10) {
        mm = '0' + mm
    }
    
    if( ss < 10){
    	ss = '0' + ss
    }

    //return yyyy + "-" + MM + "-" + dd + " " + hh + ":" + mm + ":" + ss;
    return hh + ":" + mm + ":" + ss;
};
</script>

</body>
</html>