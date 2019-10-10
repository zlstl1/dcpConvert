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

<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/assets/css/main.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/bootstrap.css">

<!-- 김규아 추가 -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/circle.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/cmGauge.css">


<link rel="stylesheet" href="<%=cp%>/resources/css/all.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/fontawesome.css">
    
    
<style type="text/css">
        /* Style the lines by removing the fill and applying a stroke */
        .line {
            fill: none;
            stroke: steelblue;
            stroke-width: 1.5px;
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
				<p>실시간 RAM 자원 모니터링이 가능합니다.</p>
				<h2>RAM 모니터링</h2>
			</header>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style2">
		<div class="inner">
			<div class="box">
				<div class="content">


				<div class="row ml-2">
                        <div class="col">
                            <h5>MEM LOAD</h5>
                            <div class="row mt-2">
                                <div class="col ml-3">
                                    <svg class="ml-3" id="chart"></svg>
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
                                    </table>
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

	<script
		src="${pageContext.request.contextPath}/resources/jquery/jQuery3.4.1.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/jquery.scrollex.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/skel.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/util.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>
	<script src="<%=cp%>/resources/js/cmGauge.js"></script>
	
	<script src="<%=cp%>/resources/js/fontawesome.js"></script>
	
	
<script src="<%=cp%>/resources/js/d3.min.js"></script>
<script src="<%=cp%>/resources/js/moment.js"></script>

<script type="text/javascript">
   
$(document).ready(function(){
    setInterval(function() {
        tick();
    }, 10000);

});

var now = Math.round(new Date().getTime() / 1000);

var loadDt = new Date();
var time = new Date(Date.parse(loadDt) - 1000 * 60 * 60);
var start = time.getTime() / 1000;

var dataset = null;
var max,min = null;

$.ajax({
    url:"<%=cp%>/get/mem",
    type:"POST",
    dataType:"json",
    async:false,
    data:{"start":start, "end": now, "step":10},
    success:function(data){
        dataset = data.data.result[0].values;

        var arr = new Array();

        for(var i = 0 ; i < dataset.length ; i++){
            arr.push(data.data.result[0].values[i][1]);
        }

        max = Math.max.apply(null, arr);
        min = Math.min.apply(null, arr);

        $('#memmax').text(Number(max).toFixed(2)+" %");
        $('#memmin').text(Number(min).toFixed(2)+" %");
    },
    error: function(err){
        console.log(err);
    }

});

var margin = {top: 20, right: 20, bottom: 20, left: 40}
    , width = 960 - margin.left - margin.right// Use the window's width
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
    .y(function(d) { return yScale(d[1]); }) // set the y values for the line generator
    .curve(d3.curveMonotoneX);// apply smoothing to the line

// 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number
//var dataset2 = d3.range(n).map(function(d) { return {"y": d3.randomUniform(1)() } });
//console.log(dataset2);

// 1. Add the SVG to the page and employ #2
var svg = d3.select("#chart")
    .attr("width", width + margin.left + margin.right)
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
svg.append("text").attr("x", 850).attr("y", 0).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")

function tick() {
    var pushdata = null;

    $.ajax({
        url:"<%=cp%>/get/single/mem",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[0].value;
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

    // redraw the line, and slide it to the left

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

    $('#memmax').text(Number(max).toFixed(2)+" %");
    $('#memmin').text(Number(min).toFixed(2)+" %");
}


</script>

</body>
</html>