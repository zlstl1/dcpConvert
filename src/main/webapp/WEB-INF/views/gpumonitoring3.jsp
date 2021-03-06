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
.line, .line4, .line7, .line10, .line13, .line16, .line19, .line22 {
	fill: none;
	stroke: steelblue;
	stroke-width: 1.5px;
}

.line2, .line5, .line8, .line11, .line14, .line17, .line20, .line23 {
	fill: none;
	stroke: orange;
	stroke-width: 1.5px;
}

.line3, .line6, .line9, .line12, .line15, .line18, .line21, .line24 {
	fill: none;
	stroke: green;
	stroke-width: 1.5px;
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
//O 
var now = Math.round(new Date().getTime() / 1000);
var loadDt = new Date();
var time = new Date(Date.parse(loadDt) - 1000 * 60 * 60);
var start = time.getTime() / 1000;

// O
function detail_button(){
    var id = window.event.target.id;
    var detail = id.replace('text', '');

    if($('#'+detail).css("display")=="none"){
        $('#'+detail).css("display","block");
        $('#'+detail+'text').html("상세보기 <i class=\"fa fa-caret-up\" aria-hidden=\"true\"></i>");
    }else{
        $('#'+detail).css("display","none");
        $('#'+detail+'text').html("상세보기 <i class=\"fa fa-caret-down\" aria-hidden=\"true\"></i>");
    }
}

//O
$.ajax({
    url:"<%=cp%>/get/single/gpu",
    type:"POST",
    dataType:"json",
    async:false,
    data:{},
    success:function(data){
		
		var length =  data.data.result.length;
        
        for(var j = 1 ; j <=  length * 3 ; j ++){
        	eval("var dataset"+j+"=null");
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
                '                        <a class="fa-4x mt-3 ml-5 gputemptext'+i+'"></a>\n' +
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
                '                        <div class="gauge gauge-big gauge-green gaugeDemo'+i+'">\n' +
                '                            <div class="gauge-arrow" data-percentage="9"\n' +
                '                                 style="transform: rotate(0deg);"></div>\n' +
                '                        </div>\n' +
                '                        <h5 class="mt-4 text-secondary gpuclocktext'+i+'"></h5>\n' +
                '                    </div>\n' +
                '\n' +
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
                '                </div>\n' +
                '\n' +
                '\n' +
                '            </div>';

            document.getElementById('gpu').appendChild(div);


            //p+data 추가(removeClass)
            var text = $( '.gpumem' + i.toString() ).attr( 'class' );
            var str = text.split(" ");
            

            if(data.data.result[i - 1].value[1]>60){
                $(".gpumem"+ i.toString()).removeClass("green");
                $(".gpumem"+ i.toString()).addClass("orange");
            }else{
                $(".gpumem"+ i.toString()).removeClass("orange");
                $(".gpumem"+ i.toString()).addClass("green");
            }
            
            $('.gpumem' + i.toString()).removeClass(str[str.length-1]);
            $('.gpumem' + i.toString()).addClass("p" + data.data.result[i - 1].value[1]);
            $('.gpumemtext' + i.toString()).text(data.data.result[i - 1].value[1] + "%");

            // 게이지 차트 만들어주기 위함(이거도 개수만큼)
            //이거 선언해줘야 뒤에서 update해도 정상적으로 작동함.
            $('.gaugeDemo'+i+' .gauge-arrow').cmGauge();
        }
        
        if(length==1){

            setInterval(function() {
                tick();
                tick2();
                tick3();
            }, 10000); 
            
        }
        if(length==2){
            setInterval(function() {
                tick();
                tick2();
                tick3();
                tick4();
                tick5();
                tick6();
            }, 10000); 
        }
        
    },
    error: function(err){
        console.log(err);
    }

});

// O 
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

// O 
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

// 여기까지 완료

$.ajax({
    url:"<%=cp%>/get/gpu_temp",
    type:"POST",
    dataType:"json",
    async:false,
    data:{"start":start, "end": now, "step":10},
    success:function(data){
        dataset1 = data.data.result[0].values;

        var arr = new Array();

        for(var i = 0 ; i < dataset1.length ; i++){
            arr.push(data.data.result[0].values[i][1]);
        }

        max1 = Math.max.apply(null, arr);
        min1 = Math.min.apply(null, arr);

        $('#gputempmax1').text(max1 + " °C");
        $('#gputempmin1').text(min1 + " °C");
    },
    error: function(err){
        console.log(err);
    }

});

var margin = {top: 20, right: 20, bottom: 20, left: 40}
    , width = 960 - margin.left - margin.right// Use the window's width
    , height = 250 - margin.top - margin.bottom; // Use the window's height

// 5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale = d3.scaleTime()
    .domain([moment.unix(dataset1[0][0]).toDate(), moment.unix(dataset1[dataset1.length-1][0]).toDate()]) // input
    .range([0, width]); // output

// 6. Y scale will use the randomly generate number
var yScale = d3.scaleLinear()
    .domain([Number(min1)-1, Number(max1)+1]) // input
    .range([height, 0]); // output

// 7. d3's line generator
var line = d3.line()
    .x(function(d, i) { return xScale(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
    .y(function(d) { return yScale(d[1]); }) // set the y values for the line generator
    .curve(d3.curveMonotoneX);// apply smoothing to the line

// 1. Add the SVG to the page and employ #2
var svg = d3.select("#tempchart1")
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
    .datum(dataset1) // 10. Binds data to the line
    .attr("class", "line") // Assign a class for styling
    .attr("d", line); // 11. Calls the line generato

// 범례추가
svg.append("circle").attr("cx",870).attr("cy", 0).attr("r", 6).style("fill", "steelblue")
svg.append("text").attr("x", 880).attr("y", 0).text("temp").style("font-size", "15px").attr("alignment-baseline","middle")


function tick() {

    var pushdata = null;

    $.ajax({
        url:"<%=cp%>/get/single/gpu_temp",
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

    dataset1.push(pushdata);

    // pop the old data point off the front
    dataset1.shift();

    var arr = new Array();

    for(var i = 0 ; i < dataset1.length ; i++){
        arr.push(dataset1[i][1]);
    }

    max1 = Math.max.apply(null, arr);
    min1 = Math.min.apply(null, arr);

    $('#gputempmax1').text(max1 + " °C");
    $('#gputempmin1').text(min1 + " °C");

    // push a new data point onto the back
    xScale.domain([moment.unix(dataset1[0][0]).toDate(), moment.unix(dataset1[dataset1.length-1][0]).toDate()]);
    yScale.domain([Number(min1)-1, Number(max1)+1]);

    path
        .attr("d", line)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale(moment.unix(dataset1[0][0]).toDate()) + ")");

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

$.ajax({
    url:"<%=cp%>/get/gpu",
    type:"POST",
    dataType:"json",
    async:false,
    data:{"start":start, "end": now, "step":10},
    success:function(data){
        dataset2 = data.data.result[0].values;
        
        console.log(dataset2);

        var arr = new Array();

        for(var i = 0 ; i < dataset2.length ; i++){
            arr.push(data.data.result[0].values[i][1]);
        }

        max2 = Math.max.apply(null, arr);
        min2 = Math.min.apply(null, arr);

        $('#gpumemmax1').text(max2 +" %");
        $('#gpumemmin1').text(min2 +" %");
    },
    error: function(err){
        console.log(err);
    }

});

var margin2 = {top: 20, right: 20, bottom: 20, left: 40}
    , width2 = 960 - margin2.left - margin2.right// Use the window's width
    , height2 = 250 - margin2.top - margin2.bottom; // Use the window's height

// 5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale2 = d3.scaleTime()
    .domain([moment.unix(dataset2[0][0]).toDate(), moment.unix(dataset2[dataset2.length-1][0]).toDate()]) // input
    .range([0, width2]); // output
    
// 6. Y scale will use the randomly generate number
var yScale2 = d3.scaleLinear()
    .domain([min2-1, max2+1]) // input
    .range([height2, 0]); // output

// 7. d3's line generator
var line2 = d3.line()
    .x(function(d, i) { return xScale2(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
    .y(function(d) { return yScale2(d[1]); }) 
    .curve(d3.curveMonotoneX);// apply smoothing to the line

// 1. Add the SVG to the page and employ #2
var svg2 = d3.select("#memchart1")
    .attr("width", width2 + margin2.left + margin2.right)
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
svg2.append("circle").attr("cx",840).attr("cy", 0).attr("r", 6).style("fill", "orange")
svg2.append("text").attr("x", 850).attr("y", 0).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")

function tick2() {

    var pushdata = null;

    $.ajax({
        url:"<%=cp%>/get/single/gpu",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[0].value;
            //pushdata = [data.data.result[0].value[0] , String(data.data.result[0].value[1]/Math.pow(10,9).toFixed(1))];
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

    $('#gpumemmax1').text(max2 +" %");
    $('#gpumemmin1').text(min2 +" %");

    // push a new data point onto the back
    xScale2.domain([moment.unix(dataset2[0][0]).toDate(), moment.unix(dataset2[dataset2.length-1][0]).toDate()]);
    //yScale2.domain([(Number(min2)/Math.pow(10,9).toFixed(1))-1,  (Number(max2)/Math.pow(10,9).toFixed(1))+1]);
    yScale2.domain([min2-1, max2+1]);

    path2
        .attr("d", line2)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale2(moment.unix(dataset2[0][0]).toDate()) + ")");

    xAxis2.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        //.call(d3.axisBottom(xScale))
        //.attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ",0)")  // 왼쪽으로 민다.
        .attr("transform", "translate(0," + height2 + ")")
        .call(d3.axisBottom(xScale2)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;

    yAxis2.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale2)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;
}

$.ajax({
    url:"<%=cp%>/get/gpu_clock",
    type:"POST",
    dataType:"json",
    async:false,
    data:{"start":start, "end": now, "step":10},
    success:function(data){
        dataset3 = data.data.result[0].values;

        var arr = new Array();

        for(var i = 0 ; i < dataset3.length ; i++){
            arr.push(data.data.result[0].values[i][1]);
        }

        max3 = Math.max.apply(null, arr);
        min3 = Math.min.apply(null, arr);

        $('#gpuclockmax1').text(max3 + " Ghz");
        $('#gpuclockmin1').text(min3 + " Ghz");
    },
    error: function(err){
        console.log(err);
    }

});

var margin3 = {top: 20, right: 20, bottom: 20, left: 40}
    , width3 = 960 - margin3.left - margin3.right// Use the window's width
    , height3 = 250 - margin3.top - margin3.bottom; // Use the window's height

// 5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale3 = d3.scaleTime()
    .domain([moment.unix(dataset3[0][0]).toDate(), moment.unix(dataset3[dataset3.length-1][0]).toDate()]) // input
    .range([0, width3]); // output

// 6. Y scale will use the randomly generate number
var yScale3 = d3.scaleLinear()
    .domain([min3-10, max3+10]) // input
    .range([height3, 0]); // output

// 7. d3's line generator
var line3 = d3.line()
    .x(function(d, i) { return xScale3(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
    .y(function(d) { return yScale3(d[1])}) // set the y values for the line generator
    .curve(d3.curveMonotoneX);// apply smoothing to the line

// 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number
//var dataset2 = d3.range(n).map(function(d) { return {"y": d3.randomUniform(1)() } });
//console.log(dataset2);

// 1. Add the SVG to the page and employ #2
var svg3 = d3.select("#clockchart1")
    .attr("width", width3 + margin3.left + margin3.right)
    .attr("height", height3 + margin3.top + margin3.bottom)
    .append("g")
    .attr("transform", "translate(" + margin3.left + "," + margin3.top + ")");

// 3. Call the x axis in a group tag
var xAxis3 = svg3.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height3 + ")")
    .call(d3.axisBottom(xScale3)); // Create an axis component with d3.axisBottom

// 4. Call the y axis in a group tag
var yAxis3 = svg3.append("g")
    .attr("class", "y axis")
    .call(d3.axisLeft(yScale3)); // Create an axis component with d3.axisLeft

// 9. Append the path, bind the data, and call the line generator
var path3 = svg3.append("path")
    .datum(dataset3) // 10. Binds data to the line
    .attr("class", "line3") // Assign a class for styling
    .attr("d", line3); // 11. Calls the line generato

// 범례추가
svg3.append("circle").attr("cx",820).attr("cy", 0).attr("r", 6).style("fill", "green")
svg3.append("text").attr("x", 830).attr("y", 0).text("clock speed").style("font-size", "15px").attr("alignment-baseline","middle")

function tick3() {

    var pushdata = null;

    $.ajax({
        url:"<%=cp%>/get/single/gpu_clock",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[0].value;
            //pushdata = [data.data.result[0].value[0] , String(data.data.result[0].value[1]/Math.pow(10,9).toFixed(1))];
        },
        error: function(err){
            console.log(err);
        }

    });

    dataset3.push(pushdata);
    // pop the old data point off the front

    dataset3.shift();

    var arr = new Array();

    for(var i = 0 ; i < dataset3.length ; i++){
        arr.push(dataset3[i][1]);
    }

    max3 = Math.max.apply(null, arr);
    min3 = Math.min.apply(null, arr);

    $('#gpuclockmax1').text(max3 +" Ghz");
    $('#gpuclockmin1').text(min3 +" Ghz");

    // push a new data point onto the back
    xScale3.domain([moment.unix(dataset3[0][0]).toDate(), moment.unix(dataset3[dataset3.length-1][0]).toDate()]);
    //yScale2.domain([(Number(min2)/Math.pow(10,9).toFixed(1))-1,  (Number(max2)/Math.pow(10,9).toFixed(1))+1]);
    yScale3.domain([min3-10, max3+10]);

    path3
        .attr("d", line3)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale3(moment.unix(dataset3[0][0]).toDate()) + ")");

    xAxis3.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        //.call(d3.axisBottom(xScale))
        //.attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ",0)")  // 왼쪽으로 민다.
        .attr("transform", "translate(0," + height3 + ")")
        .call(d3.axisBottom(xScale3)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;

    yAxis3.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale3)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;
}

$.ajax({
    url:"<%=cp%>/get/gpu_temp",
    type:"POST",
    dataType:"json",
    async:false,
    data:{"start":start, "end": now, "step":10},
    success:function(data){
        dataset4 = data.data.result[1].values;

        var arr = new Array();

        for(var i = 0 ; i < dataset4.length ; i++){
            arr.push(data.data.result[1].values[i][1]);
        }

        max4 = Math.max.apply(null, arr);
        min4 = Math.min.apply(null, arr);

        $('#gputempmax2').text(max4 + " °C");
        $('#gputempmin2').text(min4 + " °C");
    },
    error: function(err){
        console.log(err);
    }

});

var margin4 = {top: 20, right: 20, bottom: 20, left: 40}
    , width4 = 960 - margin4.left - margin4.right// Use the window's width
    , height4 = 250 - margin4.top - margin4.bottom; // Use the window's height

// 5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale4 = d3.scaleTime()
    .domain([moment.unix(dataset4[0][0]).toDate(), moment.unix(dataset4[dataset4.length-1][0]).toDate()]) // input
    .range([0, width4]); // output

// 6. Y scale will use the randomly generate number
var yScale4 = d3.scaleLinear()
    .domain([Number(min4)-1, Number(max4)+1]) // input
    .range([height4, 0]); // output

// 7. d3's line generator
var line4 = d3.line()
    .x(function(d, i) { return xScale4(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
    .y(function(d) { return yScale4(d[1]); }) // set the y values for the line generator
    .curve(d3.curveMonotoneX);// apply smoothing to the line

// 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number
//var dataset2 = d3.range(n).map(function(d) { return {"y": d3.randomUniform(1)() } });
//console.log(dataset2);

// 1. Add the SVG to the page and employ #2
var svg4 = d3.select("#tempchart2")
    .attr("width", width4 + margin4.left + margin4.right)
    .attr("height", height4 + margin4.top + margin4.bottom)
    .append("g")
    .attr("transform", "translate(" + margin4.left + "," + margin4.top + ")");

// 3. Call the x axis in a group tag
var xAxis4 = svg4.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height4 + ")")
    .call(d3.axisBottom(xScale4)); // Create an axis component with d3.axisBottom

// 4. Call the y axis in a group tag
var yAxis4 = svg4.append("g")
    .attr("class", "y axis")
    .call(d3.axisLeft(yScale4)); // Create an axis component with d3.axisLeft

// 9. Append the path, bind the data, and call the line generator
var path4 = svg4.append("path")
    .datum(dataset4) // 10. Binds data to the line
    .attr("class", "line4") // Assign a class for styling
    .attr("d", line4); // 11. Calls the line generato

// 범례추가
svg4.append("circle").attr("cx",870).attr("cy", 0).attr("r", 6).style("fill", "steelblue")
svg4.append("text").attr("x", 880).attr("y", 0).text("temp").style("font-size", "15px").attr("alignment-baseline","middle")

function tick4() {

    var pushdata = null;

    $.ajax({
        url:"<%=cp%>/get/single/gpu_temp",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[1].value;
        },
        error: function(err){
            console.log(err);
        }

    });

    dataset4.push(pushdata);

    // pop the old data point off the front
    dataset4.shift();

    var arr = new Array();

    for(var i = 0 ; i < dataset4.length ; i++){
        arr.push(dataset4[i][1]);
    }

    max4 = Math.max.apply(null, arr);
    min4 = Math.min.apply(null, arr);

    $('#gputempmax2').text(max4 + " °C");
    $('#gputempmin2').text(min4 + " °C");

    // push a new data point onto the back
    xScale4.domain([moment.unix(dataset4[0][0]).toDate(), moment.unix(dataset4[dataset4.length-1][0]).toDate()]);
    yScale4.domain([Number(min4)-1, Number(max4)+1]);


    path4
        .attr("d", line4)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale4(moment.unix(dataset4[0][0]).toDate()) + ")");

    xAxis4.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        //.call(d3.axisBottom(xScale))
        //.attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ",0)")  // 왼쪽으로 민다.
        .attr("transform", "translate(0," + height4 + ")")
        .call(d3.axisBottom(xScale4)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;

    yAxis4.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale4)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;
}

$.ajax({
    url:"<%=cp%>/get/gpu",
    type:"POST",
    dataType:"json",
    async:false,
    data:{"start":start, "end": now, "step":10},
    success:function(data){
        dataset5 = data.data.result[1].values;

        var arr = new Array();

        for(var i = 0 ; i < dataset2.length ; i++){
            arr.push(data.data.result[1].values[i][1]);
        }

        max5 = Math.max.apply(null, arr);
        min5 = Math.min.apply(null, arr);

        $('#gpumemmax2').text(max5+" %");
        $('#gpumemmin2').text(min5+" %");
    },
    error: function(err){
        console.log(err);
    }

});

var margin5 = {top: 20, right: 20, bottom: 20, left: 40}
    , width5 = 960 - margin5.left - margin5.right// Use the window's width
    , height5 = 250 - margin5.top - margin5.bottom; // Use the window's height

// 5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale5 = d3.scaleTime()
    .domain([moment.unix(dataset5[0][0]).toDate(), moment.unix(dataset5[dataset5.length-1][0]).toDate()]) // input
    .range([0, width5]); // output

// 6. Y scale will use the randomly generate number
var yScale5 = d3.scaleLinear()
    .domain([min5-1, max5+1]) // input
    .range([height5, 0]); // output

// 7. d3's line generator
var line5 = d3.line()
    .x(function(d, i) { return xScale5(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
    .y(function(d) { return yScale5(d[1]); }) // set the y values for the line generator
    .curve(d3.curveMonotoneX);// apply smoothing to the line

// 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number
//var dataset2 = d3.range(n).map(function(d) { return {"y": d3.randomUniform(1)() } });
//console.log(dataset2);

// 1. Add the SVG to the page and employ #2
var svg5 = d3.select("#memchart2")
    .attr("width", width5 + margin5.left + margin5.right)
    .attr("height", height5 + margin5.top + margin5.bottom)
    .append("g")
    .attr("transform", "translate(" + margin5.left + "," + margin5.top + ")");

// 3. Call the x axis in a group tag
var xAxis5 = svg5.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height5 + ")")
    .call(d3.axisBottom(xScale5)); // Create an axis component with d3.axisBottom

// 4. Call the y axis in a group tag
var yAxis5 = svg5.append("g")
    .attr("class", "y axis")
    .call(d3.axisLeft(yScale5)); // Create an axis component with d3.axisLeft

// 9. Append the path, bind the data, and call the line generator
var path5 = svg5.append("path")
    .datum(dataset5) // 10. Binds data to the line
    .attr("class", "line5") // Assign a class for styling
    .attr("d", line5); // 11. Calls the line generato

// 범례추가
svg5.append("circle").attr("cx",840).attr("cy", 0).attr("r", 6).style("fill", "orange")
svg5.append("text").attr("x", 850).attr("y", 0).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")

function tick5() {

    var pushdata = null;

    $.ajax({
        url:"<%=cp%>/get/single/gpu",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[1].value;
            //pushdata = [data.data.result[0].value[0] , String(data.data.result[0].value[1]/Math.pow(10,9).toFixed(1))];
        },
        error: function(err){
            console.log(err);
        }

    });

    dataset5.push(pushdata);

    // pop the old data point off the front
    dataset5.shift();

    var arr = new Array();

    for(var i = 0 ; i < dataset5.length ; i++){
        arr.push(dataset5[i][1]);
    }

    max5 = Math.max.apply(null, arr);
    min5 = Math.min.apply(null, arr);

    $('#gpumemmax2').text(max5 +" %");
    $('#gpumemmin2').text(min5 +" %");

    // push a new data point onto the back
    xScale5.domain([moment.unix(dataset5[0][0]).toDate(), moment.unix(dataset5[dataset5.length-1][0]).toDate()]);
    //yScale2.domain([(Number(min2)/Math.pow(10,9).toFixed(1))-1,  (Number(max2)/Math.pow(10,9).toFixed(1))+1]);
    yScale5.domain([min5-1, max5+1]);

    path5
        .attr("d", line5)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale5(moment.unix(dataset5[0][0]).toDate()) + ")");

    xAxis5.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        //.call(d3.axisBottom(xScale))
        //.attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ",0)")  // 왼쪽으로 민다.
        .attr("transform", "translate(0," + height5 + ")")
        .call(d3.axisBottom(xScale5)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;

    yAxis5.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale5)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;
}

$.ajax({
    url:"<%=cp%>/get/gpu_clock",
    type:"POST",
    dataType:"json",
    async:false,
    data:{"start":start, "end": now, "step":10},
    success:function(data){
        dataset6 = data.data.result[1].values;

        var arr = new Array();

        for(var i = 0 ; i < dataset6.length ; i++){
            arr.push(data.data.result[1].values[i][1]);
        }

        max6 = Math.max.apply(null, arr);
        min6 = Math.min.apply(null, arr);

        $('#gpuclockmax2').text(max6 + " Ghz");
        $('#gpuclockmin2').text(min6 + " Ghz");
    },
    error: function(err){
        console.log(err);
    }

});

var margin6 = {top: 20, right: 20, bottom: 20, left: 40}
    , width6 = 960 - margin6.left - margin6.right// Use the window's width
    , height6 = 250 - margin6.top - margin6.bottom; // Use the window's height

// 5. X scale will use the index of our data
//var xScale = d3.scaleLinear()
var xScale6 = d3.scaleTime()
    .domain([moment.unix(dataset6[0][0]).toDate(), moment.unix(dataset6[dataset6.length-1][0]).toDate()]) // input
    .range([0, width6]); // output

// 6. Y scale will use the randomly generate number
var yScale6 = d3.scaleLinear()
    .domain([min6-10, max6+10]) // input
    .range([height6, 0]); // output

// 7. d3's line generator
var line6 = d3.line()
    .x(function(d, i) { return xScale6(moment.unix(d[0]).toDate()); }) // set the x values for the line generator
    .y(function(d) { return yScale6(d[1])}) // set the y values for the line generator
    .curve(d3.curveMonotoneX);// apply smoothing to the line

// 8. An array of objects of length N. Each object has key -> value pair, the key being "y" and the value is a random number
//var dataset2 = d3.range(n).map(function(d) { return {"y": d3.randomUniform(1)() } });
//console.log(dataset2);

// 1. Add the SVG to the page and employ #2
var svg6 = d3.select("#clockchart2")
    .attr("width", width6 + margin6.left + margin6.right)
    .attr("height", height6 + margin6.top + margin6.bottom)
    .append("g")
    .attr("transform", "translate(" + margin6.left + "," + margin6.top + ")");

// 3. Call the x axis in a group tag
var xAxis6 = svg6.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height6 + ")")
    .call(d3.axisBottom(xScale6)); // Create an axis component with d3.axisBottom

// 4. Call the y axis in a group tag
var yAxis6 = svg6.append("g")
    .attr("class", "y axis")
    .call(d3.axisLeft(yScale6)); // Create an axis component with d3.axisLeft

// 9. Append the path, bind the data, and call the line generator
var path6 = svg6.append("path")
    .datum(dataset6) // 10. Binds data to the line
    .attr("class", "line6") // Assign a class for styling
    .attr("d", line6); // 11. Calls the line generato

// 범례추가
svg6.append("circle").attr("cx",820).attr("cy", 0).attr("r", 6).style("fill", "green")
svg6.append("text").attr("x", 830).attr("y", 0).text("clock speed").style("font-size", "15px").attr("alignment-baseline","middle")

function tick6() {

    var pushdata = null;

    $.ajax({
        url:"<%=cp%>/get/single/gpu_clock",
        type:"POST",
        dataType:"json",
        async:false,
        data:{},
        success:function(data){
            pushdata = data.data.result[1].value;
            //pushdata = [data.data.result[0].value[0] , String(data.data.result[0].value[1]/Math.pow(10,9).toFixed(1))];
        },
        error: function(err){
            console.log(err);
        }

    });

    dataset6.push(pushdata);

    // pop the old data point off the front
    dataset6.shift();

    var arr = new Array();

    for(var i = 0 ; i < dataset6.length ; i++){
        arr.push(dataset6[i][1]);
    }

    max6 = Math.max.apply(null, arr);
    min6 = Math.min.apply(null, arr);

    $('#gpuclockmax2').text(max6 +" Ghz");
    $('#gpuclockmin2').text(min6 +" Ghz");

    // push a new data point onto the back
    xScale6.domain([moment.unix(dataset6[0][0]).toDate(), moment.unix(dataset6[dataset6.length-1][0]).toDate()]);
    //yScale2.domain([(Number(min2)/Math.pow(10,9).toFixed(1))-1,  (Number(max2)/Math.pow(10,9).toFixed(1))+1]);
    yScale6.domain([min6-10, max6+10]);

    path6
        .attr("d", line6)
        .attr("transform", null)
        .transition()
        .attr("transform", "translate(" + xScale6(moment.unix(dataset6[0][0]).toDate()) + ")");

    xAxis6.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        //.call(d3.axisBottom(xScale))
        //.attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ",0)")  // 왼쪽으로 민다.
        .attr("transform", "translate(0," + height6 + ")")
        .call(d3.axisBottom(xScale6)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;

    yAxis6.transition() // x축 설정, transition화
        .duration(750)
        .ease(d3.easeLinear)
        .call(d3.axisLeft(yScale6)) // Create an axis component with d3.axisBottom
        .transition(); // 변환 start;
}


</script>

</body>
</html>