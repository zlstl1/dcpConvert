<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String cp = request.getContextPath();
	String type = request.getParameter("type");
	pageContext.setAttribute("type", type) ;
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
<!-- jQuery UI CSS파일  -->
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" /> 
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
<link rel="stylesheet" href="<%=cp%>/webjars/sweetalert2/8.18.1/dist/sweetalert2.min.css">

<style type="text/css">
/* 
.ui-datepicker{ font-size: 12px; width: 200px; }
.ui-datepicker select.ui-datepicker-month{ width:30%; font-size: 11px; }
.ui-datepicker select.ui-datepicker-year{ width:40%; font-size: 11px; }
 */
 .line {
	fill: none;
    stroke: steelblue;
    stroke-width: 1.5px;
}
   
.line2 {
 	fill: none;
  	stroke: orange;
  	stroke-width: 1.5px;
}

.line3 {
 	fill: none;
  	stroke: green;
  	stroke-width: 1.5px;
}

.line4 {
 	fill: none;
  	stroke: gray;
  	stroke-width: 1.5px;
}

.text5, .text4, .text3, .text2, .tooltip-date {
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
			<c:if test="${type eq 'STORAGE'}">
				<p>시간별  <%=type%> 사용량 모니터링이 가능합니다.</p>
			</c:if>
			<c:if test="${type ne 'STORAGE'}">
				<p>시간별  <%=type%> 자원 모니터링이 가능합니다.</p>
			</c:if>
			<h2><%=type%> 모니터링</h2>
		</header>
	</div>
</section>

<!-- Two -->
<section id="two" class="wrapper style2">
	<div class="inner">
		<div class="box">
		
			<div class="content">
				<div class="row ml-5">
					<div class="col">
						<input type="text" id="datepicker1" placeholder="Start Day">
					</div>
					<div class="col">
						<input type="text" id="startTime" class="timepicker" placeholder="Start Time">
					</div>
					<div class="col-1 text-center">
					~
					</div>
					<div class="col">
						<input type="text"  id="datepicker2" placeholder="End Day">
					</div>
					<div class="col">
						<input type="text" id="endTime" class="timepicker" placeholder="End Time">
					</div>
					<div class="col">
						<button class="btn btn-dark w-50" onclick="detail();">확인</button>
					</div>
				</div>
				
				<hr class="mt-4 mb-4">
				
				<div id="detail" style="display:none">
				
					<div class="row ml-2" id="temp">
						<div class="col">
							<p style="color:#000;">TEMP</p>
							<div class="row mt-2">
								<div class="col ml-3">
									<svg class="ml-3" id="tempchart"></svg>
								</div>
								<div class="col-2" style="margin-bottom: auto;margin-top: auto">
									<table class="table text-center table-hover border-bottom">
									<tr>
										<td class="font-weight-bold" scope="col">MAX</td>
										<td scope="col" id="tempmax"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">min</td>
										<td id="tempmin"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">avg</td>
										<td id="tempavg"></td>
									</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row ml-2" id="mem">
						<div class="col">
							<p style="color:#000;" id="memtext">MEM LOAD</p>
							<div class="row mt-2">
								<div class="col ml-3">
									<svg class="ml-3" id="memchart"></svg>
								</div>
								<div class="col-2" style="margin-bottom: auto;margin-top: auto">
									<table class="table text-center table-hover border-bottom">
									<tr>
										<td class="font-weight-bold" scope="col">MAX</td>
										<td scope="col" id="memmax"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">min</td>
										<td id="memmin"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">avg</td>
										<td id="memavg"></td>
									</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row ml-2" id="clock">
						<div class="col">
							<p style="color:#000;">CLOCK SPEED</p>
							<div class="row mt-2">
								<div class="col ml-3">
									<svg class="ml-3" id="clockchart"></svg>
								</div>
								<div class="col-2" style="margin-bottom: auto;margin-top: auto">
									<table class="table text-center table-hover border-bottom">
									<tr>
										<td class="font-weight-bold" scope="col">MAX</td>
										<td scope="col" id="clockmax"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">min</td>
										<td id="clockmin"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">avg</td>
										<td id="clockavg"></td>
									</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row ml-2" id="power">
						<div class="col">
							<p style="color:#000;">POWER</p>
							<div class="row mt-2">
								<div class="col ml-3">
									<svg class="ml-3" id="powerchart"></svg>
								</div>
								<div class="col-2" style="margin-bottom: auto;margin-top: auto">
									<table class="table text-center table-hover border-bottom">
									<tr>
										<td class="font-weight-bold" scope="col">MAX</td>
										<td scope="col" id="powermax"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">min</td>
										<td id="powermin"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">avg</td>
										<td id="poweravg"></td>
									</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
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

<!-- jQuery 기본 js파일 -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>  
<!-- jQuery UI 라이브러리 js파일 -->
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>  

<script src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
<script src="<%=cp%>/webjars/sweetalert2/8.18.1/dist/sweetalert2.min.js"></script>

<script type="text/javascript">

var type = "<%=type%>";
var dataset2 = new Array();

$.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
});

$('.timepicker').timepicker({
    timeFormat: 'h:mm p',
    interval: 30,
    minTime: '9',
    maxTime: '6:00pm',
    startTime: '9:00',
    dynamic: false,
    dropdown: true,
    scrollbar: true
});

$(function() {
	 $("#datepicker1").datepicker({
		 onClose : function( selectedDate ) {  // 날짜를 설정 후 달력이 닫힐 때 실행
			 if( selectedDate != "" ) {// yyy의 minDate를 xxx의 날짜로 설정
				 $('#datepicker2').datepicker("option", "minDate",  $('#datepicker1').val());
			 }
		 }
	 });
    $('#datepicker1').datepicker("option", "maxDate", new Date());
    $("#datepicker2").datepicker();
    
    $('#datepicker2').datepicker("option", "minDate", $('#datepicker1').val());
    $('#datepicker2').datepicker("option", "maxDate", new Date());
});

function detail(){
	var startday = $("#datepicker1").val();
	var endday = $("#datepicker2").val();
	var starttime = $("#startTime").val();
	var endtime = $("#endTime").val();
		
	var start = time(startday,starttime).getTime() / 1000;
	var end = time(endday,endtime).getTime() / 1000;
	
	if(start>=end){
		swal.fire("error","잘못된 검색범위입니다.","error");
		return false;
	}

	if($('#detail').css("display")=="none"){
		$('#detail').css("display","block");
	}
	
	d3.selectAll("#tempchart > *").remove();
	d3.selectAll("#memchart > *").remove();
	d3.selectAll("#clockchart > *").remove(); 
	d3.selectAll("#powerchart > *").remove(); 
	
	if(type=="CPU"){
		
		$('#temp').css("display","none");
		$('#power').css("display","none");
		 
		$.ajax({
			url:"<%=cp%>/get/cpu",
			type:"POST",
			dataType:"json",
			async:false,
			data:{"start":start, "end": end, "step":15},
			success:function(data){
				dataset2 = data.data.result[0].values;
				var arr = new Array();
				
				for(var i = 0 ; i < dataset2.length ; i++){
					arr.push(data.data.result[0].values[i][1]);
				}

				max2 = Math.max.apply(null, arr);
				min2 = Math.min.apply(null, arr);
				avg2 = average(arr);
				
				$('#memmax').text(Number(max2).toFixed(2)+" %");
				$('#memmin').text(Number(min2).toFixed(2)+" %");
				$('#memavg').text(Number(avg2).toFixed(2)+" %");
				
				},
		        error: function(err){
		            console.log(err);
		        }
		    });
		
		
		$.ajax({
	        url:"<%=cp%>/get/cpuClock",
	        type:"POST",
	        dataType:"json",
	        async:false,
	        data:{"start":start, "end": end, "step":15},
	        success:function(data){
	            dataset3 = data.data.result[0].values;
	            var arr = new Array();

	            for(var i = 0 ; i < dataset3.length ; i++){
	                data.data.result[0].values[i][1] = data.data.result[0].values[i][1]/Math.pow(10,9).toFixed(1);
	                arr.push(data.data.result[0].values[i][1]);
	            }
	            
	            max3 = Math.max.apply(null, arr);
	            min3 = Math.min.apply(null, arr);
				avg3 = average(arr);

	            $('#clockmax').text(max3.toFixed(1)+" Ghz");
	            $('#clockmin').text(min3.toFixed(1)+" Ghz");
	            $('#clockavg').text(avg3.toFixed(1)+" Ghz");
	        },
	        error: function(err){
	            console.log(err);
	        }
		});
	        
	}else if(type=="RAM"){
		
		$('#temp').css("display","none");
		$('#power').css("display","none");
		$('#clock').css("display","none");
		
		$.ajax({
		    url:"<%=cp%>/get/mem",
		    type:"POST",
		    dataType:"json",
		    async:false,
		    data:{"start":start, "end": end, "step":15},
		    success:function(data){
		        dataset2 = data.data.result[0].values;

		        var arr = new Array();

		        for(var i = 0 ; i < dataset2.length ; i++){
		            arr.push(data.data.result[0].values[i][1]);
		        }
		        
				max2 = Math.max.apply(null, arr);
				min2 = Math.min.apply(null, arr);
				avg2 = average(arr);
				
				$('#memmax').text(Number(max2).toFixed(2)+" %");
				$('#memmin').text(Number(min2).toFixed(2)+" %");
				$('#memavg').text(Number(avg2).toFixed(2)+" %");
		    },
		    error: function(err){
		        console.log(err);
		    }

		});

		
	}else if(type=="STORAGE"){
		
		$('#temp').css("display","none");
		$('#power').css("display","none");
		$('#clock').css("display","none");
		$('#memtext').text("C:Drive");
		
		var disktotal;
		
		$.ajax({
			url : "<%=cp%>/get/single/disksizetotal",
			type : "POST",
			dataType : "json",
			async : false,
			data : {},
			success : function(data) {
				var total = data.data.result[0].value[1] / Math.pow(10, 9);
				disktotal = total;
			},
			error : function(err) {
				console.log(err);
			}
		});
		
		$.ajax({
		    url:"<%=cp%>/get/disksize",
		    type:"POST",
		    dataType:"json",
		    async:false,
		    data:{"start":start, "end": end, "step":15},
		    success:function(data){
		    	
		    	var length = Object.keys(data.data.result[0].values).length;
		    	
		        var processing = null;
		        		        
		        for(var i = 0 ; i < length ; i++){
		        	var time = data.data.result[0].values[i][0];
		        	var val = disktotal - data.data.result[0].values[i][1]/ Math.pow(10, 9);
		        	processing = [time,val];
		        	dataset2[i] = processing;
		        }
		        
		        var arr = new Array();
		        
		        for(var i = 0 ; i < dataset2.length ; i++){ 
		            arr.push(disktotal - data.data.result[0].values[i][1] / Math.pow(10, 9));
		        }
		        		        
		        max2 = Math.max.apply(null, arr);
		        min2 = Math.min.apply(null, arr);
				avg2 = average(arr);
		
		        $('#memmax').text(Number(max2).toFixed(2)+" GB");
		        $('#memmin').text(Number(min2).toFixed(2)+" GB");
				$('#memavg').text(Number(avg2).toFixed(2)+" GB");
		    },
		    error: function(err){
		        console.log(err);
		    }
		
		});
		
	}else{
		var lastChar = type.substr(type.length - 1); 
		
		var i = lastChar-1;
		
		$.ajax({
		    url:"<%=cp%>/get/gpu_temp",
		    type:"POST",
		    dataType:"json",
		    async:false,
		    data:{"start":start, "end": end, "step":15},
		    success:function(data){
		        dataset = data.data.result[i].values;
		        
		        var arr = new Array();

		        for(var j = 0 ; j < dataset.length ; j++){
		            arr.push(data.data.result[i].values[j][1]);
		        }

		        max = Math.max.apply(null, arr);
		        min = Math.min.apply(null, arr);
				avg = average(arr);
		        
		        $('#tempmax').text(max+" °C");
		        $('#tempmin').text(min+" °C");
				$('#tempavg').text(Math.round(avg)+" °C");
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
		    data:{"start":start, "end": end, "step":15},
		    success:function(data){
		    	dataset2 = data.data.result[i].values;

		        var arr = new Array();

		        for(var j = 0 ; j < dataset2.length ; j++){
		            arr.push(data.data.result[i].values[j][1]);
		        }

		        max2 = Math.max.apply(null, arr);
	            min2 = Math.min.apply(null, arr);
				avg2 = average(arr);

	            $('#memmax').text(max2+" %");
	            $('#memmin').text(min2+" %");
	            $('#memavg').text(Math.round(avg2)+" %");
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
		    data:{"start":start, "end": end, "step":15},
		    success:function(data){
		    	dataset3 = data.data.result[i].values;

		        var arr = new Array();

		        for(var j = 0 ; j < dataset3.length ; j++){
		            arr.push(data.data.result[i].values[j][1]);
		        }

		        max3 = Math.max.apply(null, arr);
	            min3 = Math.min.apply(null, arr);
				avg3 = average(arr);

	            $('#clockmax').text(max3+" Ghz");
	            $('#clockmin').text(min3+" Ghz");
	            $('#clockavg').text(Math.round(avg3)+" Ghz");
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
		    data:{"start":start, "end": end, "step":15},
		    success:function(data){
		    	dataset4 = data.data.result[i].values;

		        var arr = new Array();

		        for(var j = 0 ; j < dataset4.length ; j++){
		            arr.push(data.data.result[i].values[j][1]);
		        }

		        max4 = Math.max.apply(null, arr);
		        min4 = Math.min.apply(null, arr);
				avg4 = average(arr);

		        $('#powermax').text(Math.round(max4) + " W");
		        $('#powermin').text(Math.round(min4) + " W");
		        $('#poweravg').text(Math.round(avg4) + " W");
		    },
		    error: function(err){
		        console.log(err);
		    }

		});
	}
	chart()
}

function time(day, time){
	
	var timetype = time.substr(time.length - 2);
	
	if(timetype == "AM"){
		time = time.slice(0,-3);
	}else if(timetype == "PM"){
		time = time.slice(0,-3);
		var str = time.split(":");
		if(str[0]!=12){
			time = Number(str[0])+12+":"+str[1];
		}
	}

	var date = new Date(day+" "+time);
	
	return date;
}

function average(array) {
	var sum = 0.0;
	
	for (var i = 0; i < array.length; i++)
	    sum += Number(array[i]);
	
	return sum / array.length;
}


function chart(){

	
	
	var margin2 = {top: 20, right: 20, bottom: 20, left: 40}
    , width2 = 940 - margin2.left - margin2.right// Use the window's width
    , height2 = 250 - margin2.top - margin2.bottom; // Use the window's height

// 5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale2 = d3.scaleTime()
    .domain([moment.unix(dataset2[0][0]).toDate(), moment.unix(dataset2[dataset2.length-1][0]).toDate()]) // input
    .range([0, width2]); // output

// 6. Y scale will use the randomly generate number
var yScale2 = d3.scaleLinear()
    .domain([Number(min2)-1, Number(max2)+1]) // input
    .range([height2, 0]); // output

// 7. d3's line generator
var line2 = d3.line()
    .x(function(d, i) { return xScale2(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
    .y(function(d) { return yScale2(d[1]); }) // set the y values for the line generator
    .curve(d3.curveMonotoneX);// apply smoothing to the line

// 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number
//var dataset2 = d3.range(n).map(function(d) { return {"y": d3.randomUniform(1)() } });
//console.log(dataset2);

// 1. Add the SVG to the page and employ #2
var svg2 = d3.select("#memchart")
    .attr("width", width2 + margin2.left + margin2.right + 60)
    .attr("height", height2 + margin2.top + margin2.bottom)
    .append("g")
    .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");

// 3. Call the x axis in a group tag
var xAxis2 = svg2.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height2 + ")")
    .call(d3.axisBottom(xScale2)); // Create an axis component with d3.axisBottom

// 4. Call the y axis in a group tag
var yAxis2 = svg2.append("g")
    .attr("class", "y axis")
    .call(d3.axisLeft(yScale2)); // Create an axis component with d3.axisLeft

// 9. Append the path, bind the data, and call the line generator
var path2 = svg2.append("path")
    .datum(dataset2) // 10. Binds data to the line
    .attr("class", "line2") // Assign a class for styling
    .attr("d", line2); // 11. Calls the line generato

// 범례추가
svg2.append("circle").attr("cx",820).attr("cy",0).attr("r", 6).style("fill", "orange")
if(type=="STORAGE"){
	svg2.append("text").attr("x", 830).attr("y", 0).text("disk").style("font-size", "15px").attr("alignment-baseline","middle")
}else{
	svg2.append("text").attr("x", 830).attr("y", 0).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")
}

var mouseG2 = svg2.append("g")
    .attr("class", "mouse-over-effects");

mouseG2.append("path") // this is the black vertical line to follow mouse
    .attr("class", "mouse-line2")
    .style("stroke", "black")
    .style("stroke-width", "1px")
    .style("opacity", "0");

var lines2 = document.getElementsByClassName('line2');

var mousePerLine2 = mouseG2.selectAll('.mouse-per-line2')
    .data(dataset2)
    .enter()
    .append("g")
    .attr("class", "mouse-per-line2");

mousePerLine2.append("circle")
    .attr("r", 5)
    .style("stroke", "orange")
    .style("fill", "none")
    .style("stroke-width", "1px")
    .style("opacity", "0");

mousePerLine2.append("text")
    .attr("transform", "translate(10,-20)");

mousePerLine2.append("text")
		.attr("transform", "translate(10,-5)")
		.attr("class", "text3");

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
        d3.select(".text3")
    		.style("opacity", "0");
    })
    .on('mouseover', function() { // on mouse in show line, circles and text
        d3.select(".mouse-line2")
            .style("opacity", "1");
        d3.select(".mouse-per-line2 circle")
            .style("opacity", "1");
        d3.select(".mouse-per-line2 text")
            .style("opacity", "1");
        d3.select(".text3")
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
                    .text(yScale2.invert(pos.y).toFixed(2));
                 */
                d3.select(this).select('text')
                    .html(getTime(xScale2.invert(pos.x))+", ")
                    .attr("class", "tooltip-date");

                 d3.select(this).select('.text3')
                    .html(yScale2.invert(pos.y).toFixed(2))
                    .attr("class", "text3");
                 
                return "translate(" + mouse[0] + "," + pos.y +")";
            });
    });
    
var margin3 = {top: 20, right: 20, bottom: 20, left: 40}
, width3 = 940 - margin3.left - margin3.right// Use the window's width
, height3 = 250 - margin3.top - margin3.bottom; // Use the window's height

//5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale3 = d3.scaleTime()
.domain([moment.unix(dataset3[0][0]).toDate(), moment.unix(dataset3[dataset3.length-1][0]).toDate()]) // input
.range([0, width3]); // output

//6. Y scale will use the randomly generate number
var yScale3 = d3.scaleLinear()
.domain([Number(min3)-1, Number(max3)+1]) // input
.range([height3, 0]); // output

//7. d3's line generator
var line3 = d3.line()
.x(function(d, i) { return xScale3(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
.y(function(d) { return yScale3(d[1]); }) // set the y values for the line generator
.curve(d3.curveMonotoneX);// apply smoothing to the line

//1. Add the SVG to the page and employ #2
var svg3 = d3.select("#clockchart")
.attr("width", width3 + margin3.left + margin3.right + 60)
.attr("height", height3 + margin3.top + margin3.bottom)
.append("g")
.attr("transform", "translate(" + margin3.left + "," + margin3.top + ")");

//3. Call the x axis in a group tag
var xAxis3 = svg3.append("g")
.attr("class", "x axis")
.attr("transform", "translate(0," + height3 + ")")
.call(d3.axisBottom(xScale3)); // Create an axis component with d3.axisBottom

//4. Call the y axis in a group tag
var yAxis3 = svg3.append("g")
.attr("class", "y axis")
.call(d3.axisLeft(yScale3)); // Create an axis component with d3.axisLeft

//9. Append the path, bind the data, and call the line generator
var path3 = svg3.append("path")
.datum(dataset3) // 10. Binds data to the line
.attr("class", "line3") // Assign a class for styling
.attr("d", line3); // 11. Calls the line generato

//범례추가
svg3.append("circle").attr("cx",820).attr("cy",0).attr("r", 6).style("fill", "green")
svg3.append("text").attr("x", 830).attr("y", 0).text("clock speed").style("font-size", "15px").attr("alignment-baseline","middle")

var mouseG3 = svg3.append("g")
.attr("class", "mouse-over-effects");

mouseG3.append("path") // this is the black vertical line to follow mouse
.attr("class", "mouse-line3")
.style("stroke", "black")
.style("stroke-width", "1px")
.style("opacity", "0");

var lines3 = document.getElementsByClassName('line3');

var mousePerLine3 = mouseG3.selectAll('.mouse-per-line3')
.data(dataset3)
.enter()
.append("g")
.attr("class", "mouse-per-line3");

mousePerLine3.append("circle")
.attr("r", 5)
.style("stroke", "green")
.style("fill", "none")
.style("stroke-width", "1px")
.style("opacity", "0");

mousePerLine3.append("text")
.attr("transform", "translate(10,-20)");

mousePerLine3.append("text")
	.attr("transform", "translate(10,-5)")
	.attr("class", "text4");

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
    d3.select(".text4")
		.style("opacity", "0");
})
.on('mouseover', function() { // on mouse in show line, circles and text
    d3.select(".mouse-line3")
        .style("opacity", "1");
    d3.select(".mouse-per-line3 circle")
        .style("opacity", "1");
    d3.select(".mouse-per-line3 text")
        .style("opacity", "1");
    d3.select(".text4")
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
                .text(yScale2.invert(pos.y).toFixed(2));
             */
            d3.select(this).select('text')
                .html(getTime(xScale3.invert(pos.x))+", ")
                .attr("class", "tooltip-date");

             d3.select(this).select('.text4')
                .html(yScale3.invert(pos.y).toFixed(2))
                .attr("class", "text4");
             
            return "translate(" + mouse[0] + "," + pos.y +")";
        });
});

var margin4 = {top: 20, right: 20, bottom: 20, left: 40}
, width4 = 940 - margin4.left - margin4.right// Use the window's width
, height4 = 250 - margin4.top - margin4.bottom; // Use the window's height

//5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale4 = d3.scaleTime()
.domain([moment.unix(dataset4[0][0]).toDate(), moment.unix(dataset4[dataset4.length-1][0]).toDate()]) // input
.range([0, width4]); // output

//6. Y scale will use the randomly generate number
var yScale4 = d3.scaleLinear()
.domain([Number(min4)-10, Number(max4)+10]) // input
.range([height4, 0]); // output

//7. d3's line generator
var line4 = d3.line()
.x(function(d, i) { return xScale4(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
.y(function(d) { return yScale4(d[1]); }) // set the y values for the line generator
.curve(d3.curveMonotoneX);// apply smoothing to the line

//1. Add the SVG to the page and employ #2
var svg4 = d3.select("#powerchart")
.attr("width", width4 + margin4.left + margin4.right + 60)
.attr("height", height4 + margin4.top + margin4.bottom)
.append("g")
.attr("transform", "translate(" + margin4.left + "," + margin4.top + ")");

//3. Call the x axis in a group tag
var xAxis4 = svg4.append("g") 
.attr("class", "x axis")
.attr("transform", "translate(0," + height4 + ")")
.call(d3.axisBottom(xScale4)); // Create an axis component with d3.axisBottom

//4. Call the y axis in a group tag
var yAxis4 = svg4.append("g")
.attr("class", "y axis")
.call(d3.axisLeft(yScale4)); // Create an axis component with d3.axisLeft

//9. Append the path, bind the data, and call the line generator
var path4 = svg4.append("path")
.datum(dataset4) // 10. Binds data to the line
.attr("class", "line4") // Assign a class for styling
.attr("d", line4); // 11. Calls the line generato

//범례추가
svg4.append("circle").attr("cx",820).attr("cy",0).attr("r", 6).style("fill", "gray")
svg4.append("text").attr("x", 830).attr("y", 0).text("power").style("font-size", "15px").attr("alignment-baseline","middle")

var mouseG4 = svg4.append("g")
.attr("class", "mouse-over-effects");

mouseG4.append("path") // this is the black vertical line to follow mouse
.attr("class", "mouse-line4")
.style("stroke", "black")
.style("stroke-width", "1px")
.style("opacity", "0");

var lines4 = document.getElementsByClassName('line4');

var mousePerLine4 = mouseG4.selectAll('.mouse-per-line4')
.data(dataset4)
.enter()
.append("g")
.attr("class", "mouse-per-line4");

mousePerLine4.append("circle")
.attr("r", 5)
.style("stroke", "gray")
.style("fill", "none")
.style("stroke-width", "1px")
.style("opacity", "0");

mousePerLine4.append("text")
.attr("transform", "translate(10,-20)");

mousePerLine4.append("text")
	.attr("transform", "translate(10,-5)")
	.attr("class", "text5");

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
    d3.select(".text5")
		.style("opacity", "0");
})
.on('mouseover', function() { // on mouse in show line, circles and text
    d3.select(".mouse-line4")
        .style("opacity", "1");
    d3.select(".mouse-per-line4 circle")
        .style("opacity", "1");
    d3.select(".mouse-per-line4 text")
        .style("opacity", "1");
    d3.select(".text5")
		.style("opacity", "1");
})
.on('mousemove', function() { // mouse moving over canvas
    var mouse = d3.mouse(this);
    d3.select(".mouse-line4")
        .attr("d", function() {
            var d = "M" + mouse[0] + "," + height3;
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
                .text(yScale2.invert(pos.y).toFixed(2));
             */
            d3.select(this).select('text')
                .html(getTime(xScale4.invert(pos.x))+", ")
                .attr("class", "tooltip-date");

             d3.select(this).select('.text5')
                .html(yScale4.invert(pos.y).toFixed(2))
                .attr("class", "text5");
             
            return "translate(" + mouse[0] + "," + pos.y +")";
        });
});


var margin = {top: 20, right: 20, bottom: 20, left: 40}
, width = 940 - margin.left - margin.right// Use the window's width
, height = 250 - margin.top - margin.bottom; // Use the window's height

// 5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale = d3.scaleTime()
.domain([moment.unix(dataset[0][0]).toDate(), moment.unix(dataset[dataset.length-1][0]).toDate()]) // input
.range([0, width]); // output

// 6. Y scale will use the randomly generate number
var yScale = d3.scaleLinear()
.domain([Number(min)-1, Number(max)+1]) // input
.range([height, 0]); // output

// 7. d3's line generator
var line = d3.line()
.x(function(d, i) { return xScale(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
.y(function(d) { return yScale(d[1]); }) // set the y values for the line generator
.curve(d3.curveMonotoneX);// apply smoothing to the line

// 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number
//var dataset2 = d3.range(n).map(function(d) { return {"y": d3.randomUniform(1)() } });
//console.log(dataset2);

// 1. Add the SVG to the page and employ #2
var svg = d3.select("#tempchart")
.attr("width", width + margin.left + margin.right + 60)
.attr("height", height + margin.top + margin.bottom)
.append("g")
.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// 3. Call the x axis in a group tag
var xAxis = svg.append("g")
.attr("class", "x axis")
.attr("transform", "translate(0," + height + ")")
.call(d3.axisBottom(xScale)); // Create an axis component with d3.axisBottom

// 4. Call the y axis in a group tag
var yAxis = svg.append("g")
.attr("class", "y axis")
.call(d3.axisLeft(yScale)); // Create an axis component with d3.axisLeft

// 9. Append the path, bind the data, and call the line generator
var path = svg.append("path")
.datum(dataset) // 10. Binds data to the line
.attr("class", "line") // Assign a class for styling
.attr("d", line); // 11. Calls the line generato

// 범례추가
svg.append("circle").attr("cx",840).attr("cy", 0).attr("r", 6).style("fill", "steelblue")
svg.append("text").attr("x", 850).attr("y", 0).text("temp").style("font-size", "15px").attr("alignment-baseline","middle")

var mouseG = svg.append("g")
.attr("class", "mouse-over-effects");

mouseG.append("path") // this is the black vertical line to follow mouse
.attr("class", "mouse-line")
.style("stroke", "black")
.style("stroke-width", "1px")
.style("opacity", "0");

var lines = document.getElementsByClassName('line');

var mousePerLine = mouseG.selectAll('.mouse-per-line')
.data(dataset)
.enter()
.append("g")
.attr("class", "mouse-per-line");

mousePerLine.append("circle")
.attr("r", 5)
.style("stroke", "steelblue")
.style("fill", "none")
.style("stroke-width", "1px")
.style("opacity", "0");

mousePerLine.append("text")
.attr("transform", "translate(10,-20)");

mousePerLine.append("text")
	.attr("transform", "translate(10,-5)")
	.attr("class", "text2");

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
    d3.select(".text2")
		.style("opacity", "0");
})
.on('mouseover', function() { // on mouse in show line, circles and text
    d3.select(".mouse-line")
        .style("opacity", "1");
    d3.select(".mouse-per-line circle")
        .style("opacity", "1");
    d3.select(".mouse-per-line text")
        .style("opacity", "1");
    d3.select(".text2")
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
                .text(yScale.invert(pos.y).toFixed(2));
			 */
			 
			 d3.select(this).select('text')
                .html(getTime(xScale.invert(pos.x))+", ")
                .attr("class", "tooltip-date");
			 
			 d3.select(this).select('.text2')
                .html(yScale.invert(pos.y).toFixed(2))
                .attr("class", "text2");
			 
            return "translate(" + mouse[0] + "," + pos.y +")";
        });
});  

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