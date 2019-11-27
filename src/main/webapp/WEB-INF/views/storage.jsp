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

<style type="text/css">
/* Style the lines by removing the fill and applying a stroke */
.line {
	fill: none;
	stroke: steelblue;
	stroke-width: 1.5px;
}

.text2, .tooltip-date {
	font-weight: bold;
	font-size :12px;
}
</style>
</head>
<body class="subpage">

	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/import/navbar.jsp" /> --%>
	<%-- <%@include file="import/navbar.jsp" %> --%>
	<jsp:include page="import/navbar.jsp"></jsp:include>

	<!-- One -->
	<section id="One" class="wrapper style3">
		<div class="inner">
			<header class="align-center">
				<p>실시간 STORAGE 사용량 모니터링이 가능합니다.</p>
				<h2>STORAGE 모니터링</h2>
			</header>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style2">
		<div class="inner">
			<div class="box">
				<div class="content">

					<div class="row">
						<div class="col">
							<p class="font-weight-bold text-secondary">C:Drive</p>
							<div class="progress" style="height: 50px;">
								<div class="progress-bar" role="progressbar" style="width: 49%;"
									aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"
									id="memused">
									<h4 id="memusedtext"></h4>
								</div>
							</div>
							<p class="font-weight-bold text-secondary mt-3 text-right">
								Used : <a id="diskused"></a> / Free : <a id="diskfree"></a>
							</p>
						</div>
					</div>

					<div class="row text-right mt-3">
						<div class="col">
							<a href="#" style="color: black;" onclick="detail();"
								id="detailtext">상세보기 <i class="fa fa-caret-down"
								aria-hidden="true"></i></a>
						</div>
					</div>

					<hr>

					<div id="detail" style="display: none">
	
						<div class="row">
							<div class="col text-right">
								<a href="<%=cp%>/dcp/${user.user_id}/chart?type=STORAGE" style="color:gray; font-size:15px;">시간별 사용량 <i class="fa fa-arrow-right"></i></a>
							</div>
						</div>
						
						<div class="row ml-2">
							<div class="col">
								<p style="color:#000;">C:Drive</p>
								<div class="row mt-2">
									<div class="col ml-3">
										<svg class="ml-3" id="chart"></svg>
									</div>
									<div class="col-2"
										style="margin-bottom: auto; margin-top: auto">
										<table class="table text-center table-hover border-bottom">
											<tr>
												<td class="font-weight-bold" scope="col">MAX</td>
												<td scope="col" id="memmax"></td>
											</tr>
											<tr>
												<td class="font-weight-bold">min</td>
												<td id="memmin"></td>
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

	<script type="text/javascript">
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
        url:"<%=cp%>/get/single/disksize",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){		            
            var free = data.data.result[0].value[1] / Math.pow(10, 9);
			var used = disktotal - free;

			$("#diskused").text(used.toFixed(2) + " GB");
			$("#diskfree").text(free.toFixed(2) + " GB");

			var percent = used / disktotal * 100;

			$('#memusedtext').text(Math.round(percent) + "%");
			$('#memused').width(Math.round(percent) + '%');
        },
        error: function(err){
            console.log(err);
        }

    });
	
	$(document).ready(function() {
		setInterval(function() {
			tick();
		}, 15000);
	});
		
	function detail(){
	    if($('#detail').css("display")=="none"){
	        $('#detail').css("display","block");
	        $('#detailtext').html("상세보기 <i class=\"fa fa-caret-up\" aria-hidden=\"true\"></i>");
	    }else{
	        $('#detail').css("display","none");
	        $('#detailtext').html("상세보기 <i class=\"fa fa-caret-down\" aria-hidden=\"true\"></i>");
	    }
	}
	
	var now = Math.round(new Date().getTime() / 1000);
	
	var loadDt = new Date();
	var time = new Date(Date.parse(loadDt) - 1000 * 60 * 60);
	var start = time.getTime() / 1000;
	
	var dataset = new Array();
	var max,min = null;
	
	$.ajax({
	    url:"<%=cp%>/get/disksize",
	    type:"POST",
	    dataType:"json",
	    async:false,
	    data:{"start":start, "end": now, "step":15},
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
	
	        $('#memmax').text(Number(max).toFixed(2)+" GB");
	        $('#memmin').text(Number(min).toFixed(2)+" GB");
	    },
	    error: function(err){
	        console.log(err);
	    }
	
	});
	
	var margin = {top: 20, right: 20, bottom: 20, left: 40}
	    , width = 940 - margin.left - margin.right// Use the window's width
	    , height = 250 - margin.top - margin.bottom; // Use the window's height
	
	// The number of datapoints
	var n = dataset.length;
	
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
	    .y(function(d) { return yScale(d[1]); }) 
	    .curve(d3.curveMonotoneX);// apply smoothing to the line
	
	// 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number
	//var dataset2 = d3.range(n).map(function(d) { return {"y": d3.randomUniform(1)() } });
	//console.log(dataset2);
	
	// 1. Add the SVG to the page and employ #2
	var svg = d3.select("#chart")
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
	    .attr("d", line); // 11. Calls the line generator
	
	// 범례추가
	svg.append("circle").attr("cx",840).attr("cy", 0).attr("r", 6).style("fill", "steelblue")
	svg.append("text").attr("x", 850).attr("y", 0).text("disk").style("font-size", "15px").attr("alignment-baseline","middle")
	
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
    
	function tick() {
	    var pushdata = null;
	    
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
	        url:"<%=cp%>/get/single/disksize",
	        type:"POST",
	        dataType:"json",
	        async:false,
	        data:{},
	        success:function(data){	     
		        var time = data.data.result[0].value[0];
		        var val = disktotal - data.data.result[0].value[1] / Math.pow(10, 9);
		        pushdata = [time,val];
	            
	            var free = data.data.result[0].value[1] / Math.pow(10, 9);
				var used = disktotal - free;
	
				$("#diskused").text(used.toFixed(2) + " GB");
				$("#diskfree").text(free.toFixed(2) + " GB");
	
				var percent = used / disktotal * 100;
	
				$('#memusedtext').text(Math.round(percent) + "%");
				$('#memused').width(Math.round(percent) + '%');
	        },
	        error: function(err){
	            console.log(err);
	        }
	
	    });
	
	    // push a new data point onto the back
	    dataset.push(pushdata);
	
	    // pop the old data point off the front
	    dataset.shift();
	
	    var arr = new Array();
		    for(var i = 0 ; i < dataset.length ; i++){
	        arr.push(dataset[i][1]);
	    }
	    max = Math.max.apply(null, arr);
	    min = Math.min.apply(null, arr);
	    
	    xScale.domain([moment.unix(dataset[0][0]).toDate(), moment.unix(dataset[dataset.length-1][0]).toDate()]);
	    yScale.domain([Number(min)-1, Number(max)+1]);
		
	    path // 기본 변환행렬 초기화
	        .attr("d", line)
	        .attr("transform", null)
	        .transition()
	        .attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ")");
	
	    xAxis.transition() // x축 설정, transition화
	        .duration(750)
	        .ease(d3.easeLinear)
	        .attr("transform", "translate(0," + height + ")")
	        .call(d3.axisBottom(xScale)) // Create an axis component with d3.axisBottom
	        .transition(); // 변환 start;
	
	    yAxis.transition() // x축 설정, transition화
	        .duration(750)
	        .ease(d3.easeLinear)
	        .call(d3.axisLeft(yScale)) // Create an axis component with d3.axisBottom
	        .transition(); // 변환 start;
	        
        $('#memmax').text(Number(max).toFixed(2)+" GB");
        $('#memmin').text(Number(min).toFixed(2)+" GB");
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