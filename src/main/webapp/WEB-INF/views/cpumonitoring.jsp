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
   
.line2 {
 	fill: none;
  	stroke: orange;
  	stroke-width: 1.5px;
}

.text3, .text2, .tooltip-date {
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
				<p>실시간 CPU 자원 모니터링이 가능합니다.</p>
				<h2>CPU 모니터링</h2>
			</header>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style2">
		<div class="inner">
			<div class="box">
				<div class="content">

				<div class="row text-center">
					<div class="col">
						<p class="font-weight-bold text-secondary mt-3 text-left">LOAD</p>
						<div class="c100 custom green" style="margin-left:30%" id="cpumem">
							<span id="cpumemtext"></span>
							<div class="slice">
								<div class="fill"></div>
							</div>
						</div>
					</div>
					
					<div class="col">
									<p class="font-weight-bold text-secondary mt-3 mb-4 text-left">CLOCK
										SPEED</p>
									<div id="gaugeDemo3" class="gauge gauge-big ml-3">
										<div class="gauge-arrow" data-percentage="98"
											style="transform: rotate(0deg);"></div>
									</div>
									<h4 class="mt-3 text-center text-secondary" id="cpuclocktext"></h4>
								</div>
					</div>
					
					<div class="row text-right mt-3">
						<div class="col">
							<a href="#"style="color: black;" onclick="detail();" id="detailtext">상세보기 <i class="fa fa-caret-down" aria-hidden="true"></i></a>
						</div>
	                </div>
	
	                <hr>
				
				
				
				
				<div id="detail" style="display:none">
					<div class="row ml-2">
	                        <div class="col">
	                            <p style="color:#000;">MEM LOAD</p>
	                            <div class="row mt-2">
	                                <div class="col ml-3">
	                                    <svg class="ml-3" id="memchart"></svg>
	                                </div>
	                                <div class="col-2" style="margin-bottom: auto;margin-top: auto">
	                                    <table class="table text-center table-hover border-bottom">
	                                        <tr>
	                                            <td class="font-weight-bold" scope="col">MAX</td>
	                                            <td scope="col" id="cpumemmax"></td>
	                                        </tr>
	                                        <tr>
	                                            <td class="font-weight-bold">min</td>
	                                            <td id="cpumemmin"></td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                    
	                    
	                    <div class="row ml-2 mt-5">
	                        <div class="col">
	                            <p style="color:#000;">CLOCK SPEED</p>
	                            <div class="row">
	                                <div class="col ml-3">
	                                    <svg class="ml-3" id="clockchart"></svg>
	                                </div>
	                                <div class="col-2" style="margin-bottom: auto;margin-top: auto">
	                                    <table class="table text-center table-hover border-bottom">
	                                        <tr>
	                                            <td class="font-weight-bold" scope="col">MAX</td>
	                                            <td scope="col" id="cpuclockmax"></td>
	                                        </tr>
	                                        <tr>
	                                            <td class="font-weight-bold">min</td>
	                                            <td id="cpuclockmin"></td>
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
$('#gaugeDemo3 .gauge-arrow').cmGauge();

$(document).ready(function(){
	setInterval(function() {
		tick(); 
		tick2(); 
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

var dataset = null;
var max = null,min = null;

$.ajax({
	url:"<%=cp%>/get/cpu",
	type:"POST",
	dataType:"json",
	async:false,
	data:{"start":start, "end": now, "step":15},
	success:function(data){
		dataset = data.data.result[0].values;
		var arr = new Array();
		
		for(var i = 0 ; i < dataset.length ; i++){
			arr.push(data.data.result[0].values[i][1]);
		}

		max = Math.max.apply(null, arr);
		min = Math.min.apply(null, arr);
		
		$('#cpumemmax').text(Number(max).toFixed(2)+" %");
		$('#cpumemmin').text(Number(min).toFixed(2)+" %");
		
		},
        error: function(err){
            console.log(err);
        }
    });
    
    var cpuload = null;
    
    $.ajax({
		url : "<%=cp%>/get/single/cpu",
		type : "POST",
		dataType : "json",
		data : {},
		success : function(data) {
			var mem = Math.round(data.data.result[0].value[1]);

			$("#cpumem").removeClass(cpuload);
			$("#cpumem").addClass("p" + mem);

			cpuload = "p" + mem;

			if (mem > 60) {
				$("#cpumem").removeClass("green");
				$("#cpumem").addClass("orange");
			} else {
				$("#cpumem").removeClass("orange");
				$("#cpumem").addClass("green");
			}

			$("#cpumemtext").text(mem + "%");

		},
		error : function(err) {
			console.log(err);
		}

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
    var svg = d3.select("#memchart")
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
    svg.append("text").attr("x", 850).attr("y", 0).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")
 
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
        .attr("r", 7)
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

        $.ajax({
            url:"<%=cp%>/get/single/cpu",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){
                pushdata = data.data.result[0].value;
                
                var mem = Math.round(data.data.result[0].value[1]);

    			$("#cpumem").removeClass(cpuload);
    			$("#cpumem").addClass("p" + mem);

    			cpuload = "p" + mem;

    			if (mem > 60) {
    				$("#cpumem").removeClass("green");
    				$("#cpumem").addClass("orange");
    			} else {
    				$("#cpumem").removeClass("orange");
    				$("#cpumem").addClass("green");
    			}

    			$("#cpumemtext").text(mem + "%");
    			
            },
            error: function(err){
                console.log(err);
            }

        });

        dataset.push(pushdata);

        dataset.shift();

        var arr = new Array();

        for(var i = 0 ; i < dataset.length ; i++){
            arr.push(dataset[i][1]);
        }

        max = Math.max.apply(null, arr);
        min = Math.min.apply(null, arr);

        xScale.domain([moment.unix(dataset[0][0]).toDate(), moment.unix(dataset[dataset.length-1][0]).toDate()]);
        yScale.domain([Number(min)-1, Number(max)+1]);

        path
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

        $('#cpumemmax').text(Number(max).toFixed(2)+" %");
        $('#cpumemmin').text(Number(min).toFixed(2)+" %");

    }


    var dataset2 = null;
    var max2 = null,min2 = null;

    $.ajax({
        url:"<%=cp%>/get/cpuClock",
        type:"POST",
        dataType:"json",
        async:false,
        data:{"start":start, "end": now, "step":15},
        success:function(data){
            var arr = new Array();

            var length = data.data.result[0].values.length;
            
            for(var i = 0 ; i < length ; i++){
                data.data.result[0].values[i][1] = data.data.result[0].values[i][1]/Math.pow(10,9).toFixed(1);
                arr.push(data.data.result[0].values[i][1]);
            }

            dataset2 = data.data.result[0].values;
            
            max2 = Math.max.apply(null, arr);
            min2 = Math.min.apply(null, arr);

            $('#cpuclockmax').text(max2.toFixed(1)+" Ghz");
            $('#cpuclockmin').text(min2.toFixed(1)+" Ghz");
        },
        error: function(err){
            console.log(err);
        }

    });
    
	$.ajax({
		url : "<%=cp%>/get/single/cpuClock",
		type : "POST",
		dataType : "json",
		data : {},
		success : function(data) {
			// 2.0 ~ 3.4
			var clock = (data.data.result[0].value[1] / Math.pow(10, 9))
					.toFixed(1);
			var mhz = clock - 2.0;
			var percent = Math.round(mhz / 3.4 * 100);

			$('#gaugeDemo3 .gauge-arrow').trigger('updateGauge', percent);

			$('#cpuclocktext').text(clock + " Ghz");
		},
		error : function(err) {
			console.log(err);
		}

	});

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
    var svg2 = d3.select("#clockchart")
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
    svg2.append("text").attr("x", 830).attr("y", 0).text("clock speed").style("font-size", "15px").attr("alignment-baseline","middle")
   
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
        .attr("r", 7)
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
                    var xDate = xScale.invert(mouse[0]),
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
    
    function tick2() {

        var pushdata = null;

        $.ajax({
            url:"<%=cp%>/get/single/cpuClock",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){
                pushdata = [data.data.result[0].value[0],data.data.result[0].value[1]/Math.pow(10,9).toFixed(1)];
                
                var clock = (data.data.result[0].value[1] / Math.pow(10, 9)).toFixed(1);
				var mhz = clock - 2.0;
				var percent = Math.round(mhz / 3.4 * 100);
		
				$('#gaugeDemo3 .gauge-arrow').trigger('updateGauge', percent);
		
				$('#cpuclocktext').text(clock + " Ghz");
    			
            },
            error: function(err){
                console.log(err);
            }

        });

        dataset2.push(pushdata);

        // pop the old data point off the front
        dataset2.shift();

        var arr = new Array();

        for(var i = 0 ; i < dataset2.length ; i++){
            arr.push(dataset2[i][1]);
        }

        max2 = Math.max.apply(null, arr);
        min2 = Math.min.apply(null, arr);

        // push a new data point onto the back
        xScale2.domain([moment.unix(dataset2[0][0]).toDate(), moment.unix(dataset2[dataset2.length-1][0]).toDate()]);
        yScale2.domain([Number(min2)-1, Number(max2)+1]);

        path2
            .attr("d", line2)
            .attr("transform", null)
            .transition()
            .attr("transform", "translate(" + xScale2(moment.unix(dataset[0][0]).toDate()) + ")");

        xAxis2.transition() // x축 설정, transition화
            .duration(750)
            .ease(d3.easeLinear)
            .attr("transform", "translate(0," + height2 + ")")
            .call(d3.axisBottom(xScale2)) // Create an axis component with d3.axisBottom
            .transition(); // 변환 start;

        yAxis2.transition() // x축 설정, transition화
            .duration(750)
            .ease(d3.easeLinear)
            .call(d3.axisLeft(yScale2)) // Create an axis component with d3.axisBottom
            .transition(); // 변환 start;

        $('#cpuclockmax').text(max2.toFixed(1)+" Ghz");
        $('#cpuclockmin').text(min2.toFixed(1)+" Ghz");

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