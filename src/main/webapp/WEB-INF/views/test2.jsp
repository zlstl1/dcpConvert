<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
.line, .line2 {
	fill: none;
    stroke: steelblue;
    stroke-width: 1.5px;
}
   
.line3, .line4 {
	fill: none;
	stroke: orange;
	stroke-width: 1.5px;
}

.line5, .line6 {
	fill: none;
	stroke: green;
	stroke-width: 1.5px;
}

.line7, .line8 {
	fill: none;
	stroke: gray;
	stroke-width: 1.5px;
}

.text8, .text6, .text4, .text2, .tooltip-date {
	font-weight: bold;
	font-size :12px;
}

.zoom, .zoom2, .zoom3, .zoom4{
  fill: none;
  pointer-events: all;
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
				
					<div class="row ml-2">
						<div class="col">
							<c:if test="${type eq 'CPU' || type eq 'RAM'}">
								<p style="color:#000;">MEM LOAD</p>
							</c:if>
							<c:if test="${type eq 'STORAGE'}">
								<p style="color:#000;">C:Drive</p>
							</c:if>
							<c:if test="${fn:contains(type ,'GPU')}">
								<p style="color:#000;">TEMP</p>
							</c:if>
							<div class="row mt-2">
								<div class="col ml-3">
									<svg id="chart1"></svg>
								</div>
								<div class="col-2" style="margin-bottom: auto;margin-top: auto">
									<table class="table text-center table-hover border-bottom">
									<tr>
										<td class="font-weight-bold" scope="col">MAX</td>
										<td scope="col" id="max1"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">min</td>
										<td id="min1"></td>
									</tr>
									<tr>
										<td class="font-weight-bold">avg</td>
										<td id="avg1"></td>
									</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
					
					
					<c:if test="${type eq 'CPU' || fn:contains(type ,'GPU')}">
						<div class="row ml-2">
							<div class="col">
							<c:if test="${fn:contains(type ,'GPU')}">
								<p style="color:#000;">MEM LOAD</p>
								</c:if>
								<c:if test="${type eq 'CPU'}">
								<p style="color:#000;">CLOCK SPEED</p>
								</c:if>
								<div class="row mt-2">
									<div class="col ml-3">
										<svg id="chart2"></svg>
									</div>
									<div class="col-2" style="margin-bottom: auto;margin-top: auto">
										<table class="table text-center table-hover border-bottom">
										<tr>
											<td class="font-weight-bold" scope="col">MAX</td>
											<td scope="col" id="max2"></td>
										</tr>
										<tr>
											<td class="font-weight-bold">min</td>
											<td id="min2"></td>
										</tr>
										<tr>
											<td class="font-weight-bold">avg</td>
											<td id="avg2"></td>
										</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</c:if>
					
					<c:if test="${fn:contains(type ,'GPU')}">
						<div class="row ml-2">
							<div class="col">
								<p style="color:#000;">CLOCK SPEED</p>
								<div class="row mt-2">
									<div class="col ml-3">
										<svg id="chart3"></svg>
									</div>
									<div class="col-2" style="margin-bottom: auto;margin-top: auto">
										<table class="table text-center table-hover border-bottom">
										<tr>
											<td class="font-weight-bold" scope="col">MAX</td>
											<td scope="col" id="max3"></td>
										</tr>
										<tr>
											<td class="font-weight-bold">min</td>
											<td id="min3"></td>
										</tr>
										<tr>
											<td class="font-weight-bold">avg</td>
											<td id="avg3"></td>
										</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
						
						<div class="row ml-2">
							<div class="col">
								<p style="color:#000;">POWER</p>
								<div class="row mt-2">
									<div class="col ml-3">
										<svg id="chart4"></svg>
									</div>
									<div class="col-2" style="margin-bottom: auto;margin-top: auto">
										<table class="table text-center table-hover border-bottom">
										<tr>
											<td class="font-weight-bold" scope="col">MAX</td>
											<td scope="col" id="max4"></td>
										</tr>
										<tr>
											<td class="font-weight-bold">min</td>
											<td id="min4"></td>
										</tr>
										<tr>
											<td class="font-weight-bold">avg</td>
											<td id="avg4"></td>
										</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</c:if>					
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

<script src="https://d3js.org/d3.v4.min.js"></script>

<script>
var type = "<%=type%>";
var disktotal;
var dataset = new Array();

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
	
	if(startday==""||endday==""||starttime==""||endtime==""){
		swal.fire("error","검색범위를 입력해주세요.","error");
		return false;
	}
	
	if(start >= end){
		swal.fire("error","잘못된 검색범위입니다.","error");
		return false;
	}
	
	var day = end - start; 
	
	if(day > 86400){
		swal.fire("error","최대 24시간 범위만 검색가능합니다.","error");
		return false;
	}
	
	if($('#detail').css("display")=="none"){
		$('#detail').css("display","block");
	}

	d3.selectAll("#chart1 > *").remove();
	d3.selectAll("#chart2 > *").remove();

	if(type=="CPU"){
		$.ajax({
			url:"<%=cp%>/get/cpu",
			type:"POST",
			dataType:"json",
			async:false,
			data:{"start":start, "end": end, "step":15},
			success:function(data){
				dataset = data.data.result[0].values;
				
				var arr = new Array();
				
				for(var i = 0 ; i < dataset.length ; i++){
					arr.push(data.data.result[0].values[i][1]);
				}

				max = Math.max.apply(null, arr);
				min = Math.min.apply(null, arr);				
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
	            dataset2 = data.data.result[0].values;
	            
	            var arr = new Array();
	            
	            for(var i = 0 ; i < dataset2.length ; i++){
	                data.data.result[0].values[i][1] = data.data.result[0].values[i][1]/Math.pow(10,9).toFixed(1);
	                arr.push(data.data.result[0].values[i][1]);
	            }
	            
	            max2 = Math.max.apply(null, arr);
	            min2 = Math.min.apply(null, arr);
	        },
	        error: function(err){
	            console.log(err);
	        }
		});
	}else if(type=="RAM"){
		$.ajax({
		    url:"<%=cp%>/get/mem",
		    type:"POST",
		    dataType:"json",
		    async:false,
		    data:{"start":start, "end": end, "step":15},
		    success:function(data){
		        dataset = data.data.result[0].values;
		        
		        var arr = new Array();
		        
		        for(var i = 0 ; i < dataset.length ; i++){
		            arr.push(data.data.result[0].values[i][1]);
		        }
		        
				max = Math.max.apply(null, arr);
				min = Math.min.apply(null, arr);
		    },
		    error: function(err){
		        console.log(err);
		    }
		});
	}else if(type=="STORAGE"){
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
		        	dataset[i] = processing;
		        }
		        
		        var arr = new Array();
		        
		        for(var i = 0 ; i < dataset.length ; i++){ 
		            arr.push(disktotal - data.data.result[0].values[i][1] / Math.pow(10, 9));
		        }
		        
		        max = Math.max.apply(null, arr);
		        min = Math.min.apply(null, arr);
				avg = average(arr);
		
		        $('#memmax').text(Number(max).toFixed(2)+" GB");
		        $('#memmin').text(Number(min).toFixed(2)+" GB");
		        $('#memavg').text(Number(min).toFixed(2)+" GB");
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
		    },
		    error: function(err){
		        console.log(err);
		    }

		});
	}
	
	chart();
}


function chart(){	
	var margin = {top: 20, right: 20, bottom: 110, left: 40},
	margin2 = {top: 280, right: 20, bottom: 30, left: 40},
    width = 940 - margin.left - margin.right,
    height = 350 - margin.top - margin.bottom,
    height2 = 350 - margin2.top - margin2.bottom;

	var svg = d3.select("#chart1")
	.attr("width", width + margin.left + margin.right + 60)
	.attr("height", height + margin.top + margin.bottom)
	.append("g")
	
	var x = d3.scaleTime().range([0, width]),
	    x2 = d3.scaleTime().range([0, width]),
	    y = d3.scaleLinear().range([height, 0]),
	    y2 = d3.scaleLinear().range([height2, 0]);

	var xAxis = d3.axisBottom(x),
	    xAxis2 = d3.axisBottom(x2),
	    yAxis = d3.axisLeft(y);

	var brush = d3.brushX()
	    .extent([[0, 0], [width, height2]])
	    .on("brush end", brushed);

	var zoom = d3.zoom()
	    .scaleExtent([1, Infinity])
	    .translateExtent([[0, 0], [width, height]])
	    .extent([[0, 0], [width, height]])
	    .on("zoom", zoomed);
	
	var line = d3.line()
	    .x(function(d, i) { return x(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return y(d[1]); }) // set the y values for the line generator

	var line2 = d3.line()
		.x(function(d, i) { return x2(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return y2(d[1]); }) // set the y values for the line generator

	var clip = svg.append("defs").append("svg:clipPath")
	    .attr("id", "clip")
	    .append("svg:rect")
	    .attr("width", width)
	    .attr("height", height)
	    .attr("x", 0)
	    .attr("y", 0); 
	
	var Line_chart = svg.append("g")
	    .attr("class", "focus")
	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
	    .attr("clip-path", "url(#clip)");
	
	var focus = svg.append("g")
	    .attr("class", "focus")
	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	
	var context = svg.append("g")
	    .attr("class", "context")
	    .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");
	
	// 범례추가
	svg.append("circle").attr("cx",860).attr("cy", 10).attr("r", 6).style("fill", "steelblue")

	if("<%=type%>"=="CPU" || "<%=type%>"=="RAM"){
		svg.append("text").attr("x", 870).attr("y", 10).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")
	}else if("<%=type%>"=="STORAGE"){
		svg.append("text").attr("x", 870).attr("y", 10).text("disk").style("font-size", "15px").attr("alignment-baseline","middle")
	}else{
		svg.append("text").attr("x", 870).attr("y", 10).text("temp").style("font-size", "15px").attr("alignment-baseline","middle")
	}
	
	d3.json(dataset , function (json) {
		
		x.domain([moment.unix(dataset[0][0]).toDate(), moment.unix(dataset[dataset.length-1][0]).toDate()]);
		y.domain([Number(min)-1, Number(max)+1]);
		x2.domain(x.domain());
		y2.domain(y.domain());
		
		focus.append("g")
			.attr("class", "axis axis--x")
	        .attr("transform", "translate(0," + height + ")")
	        .call(xAxis);
	
	    focus.append("g")
	        .attr("class", "axis axis--y")
	        .call(yAxis);
	
	    Line_chart.append("path")
	        .datum(dataset)
	        .attr("class", "line")
	        .attr("d", line);
	
	    context.append("path")
	        .datum(dataset)
	        .attr("class", "line2")
	        .attr("d", line2);
	    
	    context.append("g")
	    	.attr("class", "axis axis--x")
	      	.attr("transform", "translate(0," + height2 + ")")
	      	.call(xAxis2);
	
	    context.append("g")
	    	.attr("class", "brush")
	      	.call(brush)
	      	.call(brush.move, x.range());
	    
	    svg.append("rect")
	    	.attr("class", "zoom")
	      	.attr("width", width)
	      	.attr("height", height)
	     	.attr("transform", "translate(" + margin.left + "," + margin.top + ")")
	      	.call(zoom);
	    
		var mouseG = svg.append("g")
			.attr("class", "mouse-over-effects")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")");
		
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
					var xDate = x.invert(mouse[0]),
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
					
					d3.select(this).select('text')
						.html(getTime(x.invert(pos.x))+", ")
						.attr("class", "tooltip-date");
					
					d3.select(this).select('.text2')
						.html(y.invert(pos.y).toFixed(2))
						.attr("class", "text2");
						 
		           return "translate(" + mouse[0] + "," + pos.y +")";
		   });
		});  
	});

	function brushed() {
		if (d3.event.sourceEvent && d3.event.sourceEvent.type === "zoom") return; // ignore brush-by-zoom
		var s = d3.event.selection || x2.range();

		var zoomstart = s.map(x2.invert, x2)[0].getTime()/1000;
		var zoomend = s.map(x2.invert, x2)[1].getTime()/1000;
		
		if("<%=type%>"=="CPU"){
			$.ajax({
				url:"<%=cp%>/get/cpu",
				type:"POST",
				dataType:"json",
				async:false,
				data:{"start":zoomstart, "end": zoomend, "step":15},
				success:function(data){
			        var dataset = data.data.result[0].values;
			        
					var arr = new Array();
					
					for(var i = 0 ; i < dataset.length ; i++){
						arr.push(data.data.result[0].values[i][1]);
					}

					max = Math.max.apply(null, arr);
					min = Math.min.apply(null, arr);
					avg = average(arr);
					
			        $('#max1').text(Number(max).toFixed(2)+" GB");
			        $('#min1').text(Number(min).toFixed(2)+" GB");
			        $('#avg1').text(Number(avg).toFixed(2)+" GB");
			        					
					},
			        error: function(err){
			            console.log(err);
			        }
			    });
		}else if("<%=type%>"=="RAM"){
			$.ajax({
			    url:"<%=cp%>/get/mem",
			    type:"POST",
			    dataType:"json",
			    async:false,
			    data:{"start":zoomstart, "end": zoomend, "step":15},
			    success:function(data){
			        dataset = data.data.result[0].values;
			        
			        var arr = new Array();
			        
			        for(var i = 0 ; i < dataset.length ; i++){
			            arr.push(data.data.result[0].values[i][1]);
			        }
			        
					max = Math.max.apply(null, arr);
					min = Math.min.apply(null, arr);
					avg = average(arr);
					
			        $('#max1').text(Number(max).toFixed(2)+" %");
			        $('#min1').text(Number(min).toFixed(2)+" %");
			        $('#avg1').text(Number(avg).toFixed(2)+" %");
			    },
			    error: function(err){
			        console.log(err);
			    }
			});
		}else if("<%=type%>"=="STORAGE"){
			$.ajax({
			    url:"<%=cp%>/get/disksize",
			    type:"POST",
			    dataType:"json",
			    async:false,
			    data:{"start":zoomstart, "end": zoomend, "step":15},
			    success:function(data){
			    	
			    	var storage = new Array();
			    	
			    	var length = Object.keys(data.data.result[0].values).length;
			    	
			        var processing = null;
			        
			        for(var i = 0 ; i < length ; i++){
			        	var time = data.data.result[0].values[i][0];
			        	var val = disktotal - data.data.result[0].values[i][1]/ Math.pow(10, 9);
			        	processing = [time,val];
			        	storage[i] = processing;
			        }

			        var arr = new Array();
			        
			        for(var i = 0 ; i < storage.length ; i++){ 
			            arr.push(disktotal - data.data.result[0].values[i][1] / Math.pow(10, 9));
			        }
			        
			        max = Math.max.apply(null, arr);
			        min = Math.min.apply(null, arr);
					avg = average(arr);
					
			        $('#max1').text(Number(max).toFixed(2)+" GB");
			        $('#min1').text(Number(min).toFixed(2)+" GB");
			        $('#avg1').text(Number(min).toFixed(2)+" GB");
			    },
			    error: function(err){
			        console.log(err);
			    }
			});
		}else{
			var str = "<%=type%>";
			var lastChar = str.substr(str.length - 1); 
			
			var i = lastChar-1;
			
			$.ajax({
			    url:"<%=cp%>/get/gpu_temp",
			    type:"POST",
			    dataType:"json",
			    async:false,
			    data:{"start":zoomstart, "end": zoomend, "step":15},
			    success:function(data){
			        dataset = data.data.result[i].values;
			        
			        var arr = new Array();

			        for(var j = 0 ; j < dataset.length ; j++){
			            arr.push(data.data.result[i].values[j][1]);
			        }

			        max = Math.max.apply(null, arr);
			        min = Math.min.apply(null, arr);
					avg = average(arr);
			        
			        $('#max1').text(max+" °C");
			        $('#min1').text(min+" °C");
					$('#avg1').text(Math.round(avg)+" °C");
			    },
			    error: function(err){
			        console.log(err);
			    }

			});
		}
		
		var zoomstart = s.map(x2.invert, x2)[0].getTime()/1000;
		var zoomend = s.map(x2.invert, x2)[1].getTime()/1000;		
		x.domain(s.map(x2.invert, x2));
		Line_chart.select(".line").attr("d", line);
		focus.select(".axis--x").call(xAxis);
		svg.select(".zoom").call(zoom.transform, d3.zoomIdentity
				.scale(width / (s[1] - s[0]))
				.translate(-s[0], 0));
	}

	function zoomed() {
		if (d3.event.sourceEvent && d3.event.sourceEvent.type === "brush") return; // ignore zoom-by-brush
		var t = d3.event.transform;
		x.domain(t.rescaleX(x2).domain());
		Line_chart.select(".line").attr("d", line);
		focus.select(".axis--x").call(xAxis);
		context.select(".brush").call(brush.move, x.range().map(t.invertX, t));
	}
	
	var margin3 = {top: 20, right: 20, bottom: 110, left: 40},
		margin4 = {top: 280, right: 20, bottom: 30, left: 40},
	    width3 = 940 - margin3.left - margin3.right,
	    height3 = 350 - margin3.top - margin3.bottom,
	    height4 = 350 - margin4.top - margin4.bottom;

	var svg2 = d3.select("#chart2")
		.attr("width", width3 + margin3.left + margin3.right + 60)
		.attr("height", height3 + margin3.top + margin3.bottom)
		.append("g")
		
	var x3 = d3.scaleTime().range([0, width3]),
	    x4 = d3.scaleTime().range([0, width3]),
	    y3 = d3.scaleLinear().range([height3, 0]),
	    y4 = d3.scaleLinear().range([height4, 0]);

	var xAxis3 = d3.axisBottom(x3),
	    xAxis4 = d3.axisBottom(x4),
	    yAxis3 = d3.axisLeft(y3);

	var brush2 = d3.brushX()
	    .extent([[0, 0], [width3, height4]])
	    .on("brush end", brushed2);

	var zoom2 = d3.zoom()
	    .scaleExtent([1, Infinity])
	    .translateExtent([[0, 0], [width3, height3]])
	    .extent([[0, 0], [width3, height3]])
	    .on("zoom", zoomed2);
	
	var line3 = d3.line()
	    .x(function(d, i) { return x3(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return y3(d[1]); }) // set the y values for the line generator

	var line4 = d3.line()
		.x(function(d, i) { return x4(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return y4(d[1]); }) // set the y values for the line generator

	var clip2 = svg2.append("defs").append("svg2:clipPath")
	    .attr("id", "clip2")
	    .append("svg:rect")
	    .attr("width", width3)
	    .attr("height", height3)
	    .attr("x", 0)
	    .attr("y", 0); 
	
	var Line_chart2 = svg2.append("g")
	    .attr("class", "focus2")
	    .attr("transform", "translate(" + margin3.left + "," + margin3.top + ")")
	    .attr("clip-path", "url(#clip2)");
	
	var focus2 = svg2.append("g")
	    .attr("class", "focus2")
	    .attr("transform", "translate(" + margin3.left + "," + margin3.top + ")");
	
	var context2 = svg2.append("g")
	    .attr("class", "context2")
	    .attr("transform", "translate(" + margin4.left + "," + margin4.top + ")");
	
	// 범례추가
	svg2.append("circle").attr("cx",860).attr("cy", 10).attr("r", 6).style("fill", "orange")

	if("<%=type%>"=="CPU"){
		svg2.append("text").attr("x", 870).attr("y", 10).text("clock speed").style("font-size", "15px").attr("alignment-baseline","middle")
	}else {
		svg2.append("text").attr("x", 870).attr("y", 10).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")
	}
	
	d3.json(dataset2 , function (json) {
		
		x3.domain([moment.unix(dataset2[0][0]).toDate(), moment.unix(dataset2[dataset2.length-1][0]).toDate()]);
		y3.domain([Number(min2)-1, Number(max2)+1]);
		x4.domain(x3.domain());
		y4.domain(y3.domain());
		
		focus2.append("g")
			.attr("class", "axis axis--x")
	        .attr("transform", "translate(0," + height3 + ")")
	        .call(xAxis3);
	
	    focus2.append("g")
	        .attr("class", "axis axis--y")
	        .call(yAxis3);
	
	    Line_chart2.append("path")
	        .datum(dataset2)
	        .attr("class", "line3")
	        .attr("d", line3);
	
	    context2.append("path")
	        .datum(dataset2)
	        .attr("class", "line4")
	        .attr("d", line4);
	    
	    context2.append("g")
	    	.attr("class", "axis axis--x")
	      	.attr("transform", "translate(0," + height4 + ")")
	      	.call(xAxis4);
	
	    context2.append("g")
	    	.attr("class", "brush")
	      	.call(brush2)
	      	.call(brush2.move, x3.range());
	    
	    svg2.append("rect")
	    	.attr("class", "zoom")
	      	.attr("width", width3)
	      	.attr("height", height3)
	     	.attr("transform", "translate(" + margin3.left + "," + margin3.top + ")")
	      	.call(zoom2);
	
	    var mouseG2 = svg2.append("g")
			.attr("class", "mouse-over-effects")
			.attr("transform", "translate(" + margin3.left + "," + margin3.top + ")");
		
		mouseG2.append("path") // this is the black vertical line to follow mouse
			.attr("class", "mouse-line2")
		  	.style("stroke", "black")
		  	.style("stroke-width", "1px")
		  	.style("opacity", "0");
		
		var lines2 = document.getElementsByClassName('line3');
		
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
			.attr("class", "text4");
		
		mouseG2.append('svg:rect') // append a rect to catch mouse movements on canvas
			.attr('width', width3) // can't catch mouse events on a g element
			.attr('height', height3)
			.attr('fill', 'none')
			.attr('pointer-events', 'all')
			.on('mouseout', function() { // on mouse out hide line, circles and text
			d3.select(".mouse-line2")
				.style("opacity", "0");
			d3.select(".mouse-per-line2 circle")
				.style("opacity", "0");
			d3.select(".mouse-per-line2 text")
				.style("opacity", "0");
			d3.select(".text4")
		  		.style("opacity", "0");
		  })
		  .on('mouseover', function() { // on mouse in show line, circles and text
			d3.select(".mouse-line2")
				.style("opacity", "1");
			d3.select(".mouse-per-line2 circle")
				.style("opacity", "1");
			d3.select(".mouse-per-line2 text")
				.style("opacity", "1");
			d3.select(".text4")
				.style("opacity", "1");
		  })
		  .on('mousemove', function() { // mouse moving over canvas
			var mouse = d3.mouse(this);
			d3.select(".mouse-line2")
	          .attr("d", function() {
	              var d = "M" + mouse[0] + "," + height3;
	              d += " " + mouse[0] + "," + 0;
	              return d;
	        });
			
			d3.selectAll(".mouse-per-line2")
				.attr("transform", function(d, i) {
					var xDate = x.invert(mouse[0]),
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
					
					d3.select(this).select('text')
						.html(getTime(x3.invert(pos.x))+", ")
						.attr("class", "tooltip-date");
					
					d3.select(this).select('.text4')
						.html(y3.invert(pos.y).toFixed(2))
						.attr("class", "text4");
											 
		           return "translate(" + mouse[0] + "," + pos.y +")";
				});
	   });
	});    

	function brushed2() {
		if (d3.event.sourceEvent && d3.event.sourceEvent.type === "zoom") return; // ignore brush-by-zoom
		var s = d3.event.selection || x4.range();

		var zoomstart = s.map(x4.invert, x4)[0].getTime()/1000;
		var zoomend = s.map(x4.invert, x4)[1].getTime()/1000;
		
		if("<%=type%>"=="CPU"){
			$.ajax({
		        url:"<%=cp%>/get/cpuClock",
		        type:"POST",
		        dataType:"json",
		        async:false,
		        data:{"start":zoomstart, "end": zoomend, "step":15},
		        success:function(data){
		            dataset2 = data.data.result[0].values;
		            
		            var arr = new Array();
		            
		            for(var i = 0 ; i < dataset2.length ; i++){
		                data.data.result[0].values[i][1] = data.data.result[0].values[i][1]/Math.pow(10,9).toFixed(1);
		                arr.push(data.data.result[0].values[i][1]);
		            }
		            
		            max2 = Math.max.apply(null, arr);
		            min2 = Math.min.apply(null, arr);
					avg2 = average(arr);
					
			        $('#max2').text(Number(max2).toFixed(2)+" GB");
			        $('#min2').text(Number(min2).toFixed(2)+" GB");
			        $('#avg2').text(Number(avg2).toFixed(2)+" GB");
		        },
		        error: function(err){
		            console.log(err);
		        }
			});
		}else{
			var str = "<%=type%>";
			var lastChar = str.substr(str.length - 1); 
			
			var i = lastChar-1;
			
			$.ajax({
			    url:"<%=cp%>/get/gpu",
			    type:"POST",
			    dataType:"json",
			    async:false,
			    data:{"start":zoomstart, "end": zoomend, "step":15},
			    success:function(data){
			    	dataset2 = data.data.result[i].values;

			        var arr = new Array();

			        for(var j = 0 ; j < dataset2.length ; j++){
			            arr.push(data.data.result[i].values[j][1]);
			        }

			        max2 = Math.max.apply(null, arr);
		            min2 = Math.min.apply(null, arr);
					avg2 = average(arr);
			        
			        $('#max2').text(max2+" %");
			        $('#min2').text(min2+" %");
					$('#avg2').text(Math.round(avg2)+" %");
			    },
			    error: function(err){
			        console.log(err);
			    }

			});
		}
		x3.domain(s.map(x4.invert, x4));
		Line_chart2.select(".line3").attr("d", line3);
		focus2.select(".axis--x").call(xAxis3);
		svg2.select(".zoom2").call(zoom2.transform, d3.zoomIdentity
				.scale(width3 / (s[1] - s[0]))
				.translate(-s[0], 0));
	}

	function zoomed2() {
		if (d3.event.sourceEvent && d3.event.sourceEvent.type === "brush") return; // ignore zoom-by-brush
		var t = d3.event.transform;
		x3.domain(t.rescaleX(x4).domain());
		Line_chart2.select(".line3").attr("d", line3);
		focus2.select(".axis--x").call(xAxis3);
		context2.select(".brush2").call(brush2.move, x3.range().map(t.invertX, t));
	}
	
	var margin5 = {top: 20, right: 20, bottom: 110, left: 40},
		margin6 = {top: 280, right: 20, bottom: 30, left: 40},
	    width5 = 940 - margin5.left - margin5.right,
	    height5 = 350 - margin5.top - margin5.bottom,
	    height6 = 350 - margin6.top - margin6.bottom;
	
	var svg3 = d3.select("#chart3")
		.attr("width", width5 + margin5.left + margin5.right + 60)
		.attr("height", height5 + margin5.top + margin5.bottom)
		.append("g")
		
	var x5 = d3.scaleTime().range([0, width5]),
	    x6 = d3.scaleTime().range([0, width5]),
	    y5 = d3.scaleLinear().range([height5, 0]),
	    y6 = d3.scaleLinear().range([height6, 0]);
	
	var xAxis5 = d3.axisBottom(x5),
	    xAxis6 = d3.axisBottom(x6),
	    yAxis5 = d3.axisLeft(y5);
	
	var brush3 = d3.brushX()
	    .extent([[0, 0], [width5, height6]])
	    .on("brush end", brushed3);
	
	var zoom3 = d3.zoom()
	    .scaleExtent([1, Infinity])
	    .translateExtent([[0, 0], [width5, height5]])
	    .extent([[0, 0], [width5, height5]])
	    .on("zoom", zoomed3);
	
	var line5 = d3.line()
	    .x(function(d, i) { return x5(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return y5(d[1]); }) // set the y values for the line generator
	
	var line6 = d3.line()
		.x(function(d, i) { return x6(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return y6(d[1]); }) // set the y values for the line generator
	
	var clip3 = svg3.append("defs").append("svg3:clipPath")
	    .attr("id", "clip3")
	    .append("svg:rect")
	    .attr("width", width5)
	    .attr("height", height5)
	    .attr("x", 0)
	    .attr("y", 0); 
	
	var Line_chart3 = svg3.append("g")
	    .attr("class", "focus3")
	    .attr("transform", "translate(" + margin5.left + "," + margin5.top + ")")
	    .attr("clip-path", "url(#clip3)");
	
	var focus3 = svg3.append("g")
	    .attr("class", "focus3")
	    .attr("transform", "translate(" + margin5.left + "," + margin5.top + ")");
	
	var context3 = svg3.append("g")
	    .attr("class", "context3")
	    .attr("transform", "translate(" + margin6.left + "," + margin6.top + ")");
	
	// 범례추가
	svg3.append("circle").attr("cx",860).attr("cy", 10).attr("r", 6).style("fill", "green")
	svg3.append("text").attr("x", 870).attr("y", 10).text("clock speed").style("font-size", "15px").attr("alignment-baseline","middle")
	
	d3.json(dataset3 , function (json) {
		
		x5.domain([moment.unix(dataset3[0][0]).toDate(), moment.unix(dataset3[dataset3.length-1][0]).toDate()]);
		y5.domain([Number(min3)-1, Number(max3)+1]);
		x6.domain(x5.domain());
		y6.domain(y5.domain());
		
		focus3.append("g")
			.attr("class", "axis axis--x")
	        .attr("transform", "translate(0," + height5 + ")")
	        .call(xAxis5);
	
	    focus3.append("g")
	        .attr("class", "axis axis--y")
	        .call(yAxis5);
	
	    Line_chart3.append("path")
	        .datum(dataset3)
	        .attr("class", "line5")
	        .attr("d", line5);
	
	    context3.append("path")
	        .datum(dataset3)
	        .attr("class", "line6")
	        .attr("d", line6);
	    
	    context3.append("g")
	    	.attr("class", "axis axis--x")
	      	.attr("transform", "translate(0," + height6 + ")")
	      	.call(xAxis6);
	
	    context3.append("g")
	    	.attr("class", "brush")
	      	.call(brush3)
	      	.call(brush3.move, x5.range());
	    
	    svg3.append("rect")
	    	.attr("class", "zoom")
	      	.attr("width", width5)
	      	.attr("height", height5)
	     	.attr("transform", "translate(" + margin5.left + "," + margin5.top + ")")
	      	.call(zoom3);
	
	    var mouseG3 = svg3.append("g")
			.attr("class", "mouse-over-effects")
			.attr("transform", "translate(" + margin5.left + "," + margin5.top + ")");
		
		mouseG3.append("path") // this is the black vertical line to follow mouse
			.attr("class", "mouse-line3")
		  	.style("stroke", "black")
		  	.style("stroke-width", "1px")
		  	.style("opacity", "0");
		
		var lines3 = document.getElementsByClassName('line5');
		
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
			.attr("class", "text6");
		
		mouseG3.append('svg:rect') // append a rect to catch mouse movements on canvas
			.attr('width', width5) // can't catch mouse events on a g element
			.attr('height', height5)
			.attr('fill', 'none')
			.attr('pointer-events', 'all')
			.on('mouseout', function() { // on mouse out hide line, circles and text
			d3.select(".mouse-line3")
				.style("opacity", "0");
			d3.select(".mouse-per-line3 circle")
				.style("opacity", "0");
			d3.select(".mouse-per-line3 text")
				.style("opacity", "0");
			d3.select(".text6")
		  		.style("opacity", "0");
		  })
		  .on('mouseover', function() { // on mouse in show line, circles and text
			d3.select(".mouse-line3")
				.style("opacity", "1");
			d3.select(".mouse-per-line3 circle")
				.style("opacity", "1");
			d3.select(".mouse-per-line3 text")
				.style("opacity", "1");
			d3.select(".text6")
				.style("opacity", "1");
		  })
		  .on('mousemove', function() { // mouse moving over canvas
			var mouse = d3.mouse(this);
			d3.select(".mouse-line3")
	          .attr("d", function() {
	              var d = "M" + mouse[0] + "," + height5;
	              d += " " + mouse[0] + "," + 0;
	              return d;
	        });
			
			d3.selectAll(".mouse-per-line3")
				.attr("transform", function(d, i) {
					var xDate = x.invert(mouse[0]),
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
					
					d3.select(this).select('text')
						.html(getTime(x5.invert(pos.x))+", ")
						.attr("class", "tooltip-date");
					
					d3.select(this).select('.text6')
						.html(y5.invert(pos.y).toFixed(2))
						.attr("class", "text6");
											 
		           return "translate(" + mouse[0] + "," + pos.y +")";
				});
	   });
	});    
	
	function brushed3() {
		if (d3.event.sourceEvent && d3.event.sourceEvent.type === "zoom") return; // ignore brush-by-zoom
		var s = d3.event.selection || x6.range();
	
		var zoomstart = s.map(x6.invert, x6)[0].getTime()/1000;
		var zoomend = s.map(x6.invert, x6)[1].getTime()/1000;
		
		var str = "<%=type%>";
		var lastChar = str.substr(str.length - 1); 
			
		var i = lastChar-1;
			
		$.ajax({
		    url:"<%=cp%>/get/gpu_clock",
		    type:"POST",
			dataType:"json",
			async:false,
		    data:{"start":zoomstart, "end": zoomend, "step":15},
		    success:function(data){
		    	dataset3 = data.data.result[i].values;	
			    
		    	var arr = new Array();
	
			    for(var j = 0 ; j < dataset3.length ; j++){
		            arr.push(data.data.result[i].values[j][1]);
		        }
			    
			    max3 = Math.max.apply(null, arr);
		        min3 = Math.min.apply(null, arr);
		        avg3 = average(arr);
			        
		     	$('#max3').text(max3+" Ghz");
	        	$('#min3').text(min3+" Ghz");
	        	$('#avg3').text(Math.round(avg3)+" Ghz");
			},
			error: function(err){
				console.log(err);	
			}
		});
			
		x5.domain(s.map(x6.invert, x6));
		Line_chart3.select(".line5").attr("d", line5);
		focus3.select(".axis--x").call(xAxis5);
		svg3.select(".zoom3").call(zoom3.transform, d3.zoomIdentity
				.scale(width5 / (s[1] - s[0]))
				.translate(-s[0], 0));
	}
	
	function zoomed3() {
		if (d3.event.sourceEvent && d3.event.sourceEvent.type === "brush") return; // ignore zoom-by-brush
		var t = d3.event.transform;
		x5.domain(t.rescaleX(x6).domain());
		Line_chart3.select(".line5").attr("d", line5);
		focus3.select(".axis--x").call(xAxis5);
		context3.select(".brush3").call(brush3.move, x5.range().map(t.invertX, t));
	}
	
	var margin7 = {top: 20, right: 20, bottom: 110, left: 40},
		margin8 = {top: 280, right: 20, bottom: 30, left: 40},
	    width7 = 940 - margin7.left - margin7.right,
	    height7 = 350 - margin7.top - margin7.bottom,
	    height8 = 350 - margin8.top - margin8.bottom;
	
	var svg4 = d3.select("#chart4")
		.attr("width", width7 + margin7.left + margin7.right + 60)
		.attr("height", height7 + margin7.top + margin7.bottom)
		.append("g")
		
	var x7 = d3.scaleTime().range([0, width7]),
	    x8 = d3.scaleTime().range([0, width7]),
	    y7 = d3.scaleLinear().range([height7, 0]),
	    y8 = d3.scaleLinear().range([height8, 0]);
	
	var xAxis7 = d3.axisBottom(x7),
	    xAxis8 = d3.axisBottom(x8),
	    yAxis7 = d3.axisLeft(y7);
		
	var brush4 = d3.brushX()
	    .extent([[0, 0], [width7, height8]])
	    .on("brush end", brushed4);
	
	var zoom4 = d3.zoom()
	    .scaleExtent([1, Infinity])
	    .translateExtent([[0, 0], [width7, height7]])
	    .extent([[0, 0], [width7, height7]])
	    .on("zoom", zoomed4);
	
	var line7 = d3.line()
	    .x(function(d, i) { return x7(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return y7(d[1]); }) // set the y values for the line generator
	
	var line8 = d3.line()
		.x(function(d, i) { return x8(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
	    .y(function(d) { return y8(d[1]); }) // set the y values for the line generator
	
	var clip4 = svg4.append("defs").append("svg4:clipPath")
	    .attr("id", "clip4")
	    .append("svg:rect")
	    .attr("width", width7)
	    .attr("height", height7)
	    .attr("x", 0)
	    .attr("y", 0); 

	var Line_chart4 = svg4.append("g")
	    .attr("class", "focus4")
	    .attr("transform", "translate(" + margin7.left + "," + margin7.top + ")")
	    .attr("clip-path", "url(#clip4)");
	
	var focus4 = svg4.append("g")
	    .attr("class", "focus4")
	    .attr("transform", "translate(" + margin7.left + "," + margin7.top + ")");
	
	var context4 = svg4.append("g")
	    .attr("class", "context4")
	    .attr("transform", "translate(" + margin8.left + "," + margin8.top + ")");
	
	// 범례추가
	svg4.append("circle").attr("cx",860).attr("cy", 10).attr("r", 6).style("fill", "gray")
	svg4.append("text").attr("x", 870).attr("y", 10).text("power").style("font-size", "15px").attr("alignment-baseline","middle")
	
	d3.json(dataset4 , function (json) {
		
		x7.domain([moment.unix(dataset4[0][0]).toDate(), moment.unix(dataset4[dataset4.length-1][0]).toDate()]);
		y7.domain([Number(min4)-1, Number(max4)+1]);
		x8.domain(x7.domain());
		y8.domain(y7.domain());

		focus4.append("g")
			.attr("class", "axis axis--x")
	        .attr("transform", "translate(0," + height7 + ")")
	        .call(xAxis7);
	
	    focus4.append("g")
	        .attr("class", "axis axis--y")
	        .call(yAxis7);
	
	    Line_chart4.append("path")
	        .datum(dataset4)
	        .attr("class", "line7")
	        .attr("d", line7);
	    
	    context4.append("path")
	        .datum(dataset4)
	        .attr("class", "line8")
	        .attr("d", line8);
	    
	    context4.append("g")
	    	.attr("class", "axis axis--x")
	      	.attr("transform", "translate(0," + height8 + ")")
	      	.call(xAxis8);
	    
	    context4.append("g")
	    	.attr("class", "brush")
	      	.call(brush4)
	      	.call(brush4.move, x7.range());
	   
	    svg4.append("rect")
	    	.attr("class", "zoom")
	      	.attr("width", width7)
	      	.attr("height", height7)
	     	.attr("transform", "translate(" + margin7.left + "," + margin7.top + ")")
	      	.call(zoom4);
	
	    var mouseG4 = svg4.append("g")
			.attr("class", "mouse-over-effects")
			.attr("transform", "translate(" + margin7.left + "," + margin7.top + ")");

		mouseG4.append("path") // this is the black vertical line to follow mouse
			.attr("class", "mouse-line4")
		  	.style("stroke", "black")
		  	.style("stroke-width", "1px")
		  	.style("opacity", "0");
		
		var lines4 = document.getElementsByClassName('line7');
		
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
			.attr("class", "text8");
		
		mouseG4.append('svg:rect') // append a rect to catch mouse movements on canvas
			.attr('width', width7) // can't catch mouse events on a g element
			.attr('height', height7)
			.attr('fill', 'none')
			.attr('pointer-events', 'all')
			.on('mouseout', function() { // on mouse out hide line, circles and text
			d3.select(".mouse-line4")
				.style("opacity", "0");
			d3.select(".mouse-per-line4 circle")
				.style("opacity", "0");
			d3.select(".mouse-per-line4 text")
				.style("opacity", "0");
			d3.select(".text8")
		  		.style("opacity", "0");
		  })
		  .on('mouseover', function() { // on mouse in show line, circles and text
			d3.select(".mouse-line4")
				.style("opacity", "1");
			d3.select(".mouse-per-line4 circle")
				.style("opacity", "1");
			d3.select(".mouse-per-line4 text")
				.style("opacity", "1");
			d3.select(".text8")
				.style("opacity", "1");
		  })
		  .on('mousemove', function() { // mouse moving over canvas
			var mouse = d3.mouse(this);
			d3.select(".mouse-line4")
	          .attr("d", function() {
	              var d = "M" + mouse[0] + "," + height7;
	              d += " " + mouse[0] + "," + 0;
	              return d;
	        });
			
			d3.selectAll(".mouse-per-line4")
				.attr("transform", function(d, i) {
					var xDate = x.invert(mouse[0]),
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
					
					d3.select(this).select('text')
						.html(getTime(x7.invert(pos.x))+", ")
						.attr("class", "tooltip-date");
					
					d3.select(this).select('.text8')
						.html(y7.invert(pos.y).toFixed(2))
						.attr("class", "text8");
											 
		           return "translate(" + mouse[0] + "," + pos.y +")";
				});
	   });
	});    
	
	function brushed4() {
		if (d3.event.sourceEvent && d3.event.sourceEvent.type === "zoom") return; // ignore brush-by-zoom
		var s = d3.event.selection || x8.range();
	
		var zoomstart = s.map(x8.invert, x8)[0].getTime()/1000;
		var zoomend = s.map(x8.invert, x8)[1].getTime()/1000;
		
		var str = "<%=type%>";
		var lastChar = str.substr(str.length - 1); 
			
		var i = lastChar-1;
			
		$.ajax({
		    url:"<%=cp%>/get/gpu_power",
		    type:"POST",
			dataType:"json",
			async:false,
		    data:{"start":zoomstart, "end": zoomend, "step":15},
		    success:function(data){
		    	dataset4 = data.data.result[i].values;	
			    
		    	var arr = new Array();
	
			    for(var j = 0 ; j < dataset4.length ; j++){
		            arr.push(data.data.result[i].values[j][1]);
		        }
			    
			    max4 = Math.max.apply(null, arr);
		        min4 = Math.min.apply(null, arr);
		        avg4 = average(arr);
			        
		     	$('#max4').text(Math.round(max4)+" W");
	        	$('#min4').text(Math.round(min4)+" W");
	        	$('#avg4').text(Math.round(avg4)+" W");
			},
			error: function(err){
				console.log(err);	
			}
		});
			
		x7.domain(s.map(x8.invert, x8));
		Line_chart4.select(".line7").attr("d", line7);
		focus4.select(".axis--x").call(xAxis7);
		svg4.select(".zoom4").call(zoom4.transform, d3.zoomIdentity
				.scale(width7 / (s[1] - s[0]))
				.translate(-s[0], 0));
	}
	
	function zoomed4() {
		if (d3.event.sourceEvent && d3.event.sourceEvent.type === "brush") return; // ignore zoom-by-brush
		var t = d3.event.transform;
		x7.domain(t.rescaleX(x8).domain());
		Line_chart4.select(".line7").attr("d", line7);
		focus4.select(".axis--x").call(xAxis7);
		context4.select(".brush4").call(brush4.move, x7.range().map(t.invertX, t));
	}
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
}
</script>

</body>
</html>