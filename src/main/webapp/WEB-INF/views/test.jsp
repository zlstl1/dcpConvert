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
.line {
	fill: none;
    stroke: steelblue;
    stroke-width: 1.5px;
}
   
.line2 {
	fill: none;
    stroke: steelblue;
    stroke-width: 1.5px;
}

.text5, .text4, .text3, .text2, .tooltip-date {
	font-weight: bold;
	font-size :12px;
}

.zoom {
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
				
					<div class="row ml-2" id="temp">
						<div class="col">
							<c:if test="${type eq 'STORAGE'}">
							<p style="color:#000;">C:Drive</p>
							</c:if>
							<c:if test="${type ne 'STORAGE'}">
							<p style="color:#000;">MEM LOAD</p>
							</c:if>
							<div class="row mt-2">
								<div class="col ml-3">
									<svg id="chart"></svg>
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

var dataset = new Array();

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

	d3.selectAll("#chart > *").remove();

	if(type=="STORAGE"){
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
	}
	
	if(type=="RAM"){
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
				avg = average(arr);
				
				$('#memmax').text(Number(max).toFixed(2)+" %");
				$('#memmin').text(Number(min).toFixed(2)+" %");
				$('#memavg').text(Number(avg).toFixed(2)+" %");
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

	var svg = d3.select("#chart")
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
			
	if("<%=type%>"=="STORAGE"){
		svg.append("text").attr("x", 870).attr("y", 10).text("disk").style("font-size", "15px").attr("alignment-baseline","middle")
	}
	
	if("<%=type%>"=="RAM"){
		svg.append("text").attr("x", 870).attr("y", 10).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")
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

		if("<%=type%>"=="STORAGE"){
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
					
			        $('#memmax').text(Number(max).toFixed(2)+" GB");
			        $('#memmin').text(Number(min).toFixed(2)+" GB");
			        $('#memavg').text(Number(min).toFixed(2)+" GB");
			    },
			    error: function(err){
			        console.log(err);
			    }
			});
		}
		
		if("<%=type%>"=="RAM"){
			$.ajax({
			    url:"<%=cp%>/get/mem",
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
			
			        var max = Math.max.apply(null, arr);
			        var min = Math.min.apply(null, arr);
					var avg = average(arr);
			        
			        $('#memmax').text(Number(max).toFixed(2)+" %");
			        $('#memmin').text(Number(min).toFixed(2)+" %");
					$('#memavg').text(Number(avg).toFixed(2)+" %");
			    },
			    error: function(err){
			        console.log(err);
			    }
			});
		}
				
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

	function type(d) {
		d.Date = parseDate(d.Date);
		d.Air_Temp = +d.Air_Temp;
		
		return d;
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