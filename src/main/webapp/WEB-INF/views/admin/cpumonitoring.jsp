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
    </style>
</head>
<body>

<div class="row" style="margin-left:250px">
    <div class="col h-100">

        <div class="row m-3">
            <a class="font-weight-bold text-secondary">자원관리 > </a>
            <a class="font-weight-normal text-secondary">&nbsp;CPU 모니터링</a>
        </div>

        <hr>

        <div class="row">
            <div class="col">
                <div class="row ml-2">
                    <div class="col w-100">
                        <div class="row">
                            <div class="col">
                                <h5 class="font-weight-bold text-secondary mt-3">LOAD</h5>
                                <div class="c100 custom green ml-5 cpumem">
                                    <span class="cpumemtext"></span>
                                    <div class="slice">
                                        <div class="bar"></div>
                                        <div class="fill"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col">
                                <h5 class="font-weight-bold text-secondary mt-3 mb-4">CLOCK SPEED</h5>
                                <div class="gauge gauge-big gauge-green gaugeDemo1">
                                    <div class="gauge-arrow" data-percentage="98"
                                         style="transform: rotate(0deg);"></div>
                                </div>
                                <h2 class="mt-3 ml-5 text-secondary cpuclocktext"></h2>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <a href="#" style="color: black;margin-left: 92%" onclick="detail();" id="cpudetailtext">상세보기 <i class="fa fa-caret-down" aria-hidden="true"></i></a>
                </div>

                <hr class="m-2 mt-3 mb-3">

                <div style="display: none" id="cpudetail">
                    <div class="row ml-2">
                        <div class="col">
                            <h5>MEM LOAD</h5>
                            <div class="row mt-2">
                                <div class="col-2">
                                    <div class="col mt-5">
                                        <div class="c100 custom green ml-5 cpumem">
                                            <span class="cpumemtext"></span>
                                            <div class="slice">
                                                <div class="bar"></div>
                                                <div class="fill"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col ml-3">
                                    <svg class="ml-3" id="memchart"></svg>
                                </div>
                                <div class="col-2 mr-5" style="margin-bottom: auto;margin-top: auto">
                                    <table class="table text-center table-hover border-bottom">
                                        <tr>
                                            <td class="h5 font-weight-bold" scope="col">최고</td>
                                            <td class="font-weight-bold" scope="col" id="cpumemmax"></td>
                                        </tr>
                                        <tr>
                                            <td class="h5 font-weight-bold">최저</th>
                                            <td class="font-weight-bold" id="cpumemmin"></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <br>

                    <div class="row ml-2 mt-2">
                        <div class="col">
                            <h5>CLOCK SPEED</h5>
                            <div class="row">
                                <div class="col-2 mt-5">
                                    <div class="gauge gauge-big gauge-green gaugeDemo1">
                                        <div class="gauge-arrow" data-percentage="98"
                                             style="transform: rotate(0deg);"></div>
                                    </div>
                                    <h2 class="mt-3 ml-5 text-secondary cpuclocktext"></h2>
                                </div>
                                <div class="col ml-3">
                                    <svg class="ml-3" id="clockchart"></svg>
                                </div>
                                <div class="col-2 mr-5" style="margin-bottom: auto;margin-top: auto">
                                    <table class="table text-center table-hover border-bottom">
                                        <tr>
                                            <td class="h5 font-weight-bold" scope="col">최고</td>
                                            <td class="font-weight-bold" scope="col" id="cpuclockmax"></td>
                                        </tr>
                                        <tr>
                                            <td class="h5 font-weight-bold">최저</th>
                                            <td class="font-weight-bold" id="cpuclockmin"></td>
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
</div>


</body>
<script type="text/javascript">
    $('.gaugeDemo1 .gauge-arrow').cmGauge();

    $(document).ready(function(){
        update();

        setInterval(function() {
            update();
            tick();
            tick2();
        }, 10000);

    });

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
        data:{"start":start, "end": now, "step":10},
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

    var margin = {top: 20, right: 20, bottom: 20, left: 40}
        , width = 960 - margin.left - margin.right// Use the window's width
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
        .attr("d", line); // 11. Calls the line generato

    // 범례추가
    svg.append("circle").attr("cx",840).attr("cy", 0).attr("r", 6).style("fill", "steelblue")
    svg.append("text").attr("x", 850).attr("y", 0).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")

    //tooltip 추가


    function detail(){
        if($('#cpudetail').css("display")=="none"){
            $('#cpudetail').css("display","block");
            $('#cpudetailtext').html("상세보기 <i class=\"fa fa-caret-up\" aria-hidden=\"true\"></i>");
        }else{
            $('#cpudetail').css("display","none");
            $('#cpudetailtext').html("상세보기 <i class=\"fa fa-caret-down\" aria-hidden=\"true\"></i>");
        }
    }

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
            //.call(d3.axisBottom(xScale))
            //.attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ",0)")  // 왼쪽으로 민다.
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
    //tooltip 추가시 추가
/*
    function formatDate(date) {
        var m = date.getMonth()+1;
        var d = date.getDate();
        var h = date.getHours();
        var i = date.getMinutes();
        var s = date.getSeconds();
        //return date.getFullYear()+'/'+(m>9?m:'0'+m)+'/'+(d>9?d:'0'+d)+' '+(h>9?h:'0'+h)+':'+(i>9?i:'0'+i)+':'+(s>9?s:'0'+s);
        return (d>9?d:'0'+d)+'일 '+(h>9?h:'0'+h)+'시 '+(i>9?i:'0'+i)+'분';
    }
*/





    var dataset2 = null;
    var max2 = null,min2 = null;

    $.ajax({
        url:"<%=cp%>/get/cpuClock",
        type:"POST",
        dataType:"json",
        async:false,
        data:{"start":start, "end": now, "step":10},
        success:function(data){
            var arr = new Array();

            for(var i = 0 ; i < dataset.length ; i++){
                data.data.result[0].values[i][1] = data.data.result[0].values[i][1]/Math.pow(10,9).toFixed(1);
                arr.push(data.data.result[0].values[i][1]);
            }

            dataset2 = data.data.result[0].values;

            max2 = Math.max.apply(null, arr);
            min2 = Math.min.apply(null, arr);

            $('#cpuclockmax').text(max2.toFixed(1)+" %");
            $('#cpuclockmin').text(min2.toFixed(1)+" %");
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
    svg2.append("circle").attr("cx",820).attr("cy",0).attr("r", 6).style("fill", "orange")
    svg2.append("text").attr("x", 830).attr("y", 0).text("clock speed").style("font-size", "15px").attr("alignment-baseline","middle")

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
            .attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ")");

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

        $('#cpuclockmax').text(max2.toFixed(1)+" %");
        $('#cpuclockmin').text(min2.toFixed(1)+" %");

    }

    var cpuload = null;
    function update(){
        $.ajax({
            url:"<%=cp%>/get/single/cpu",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){
                var mem = Math.round(data.data.result[0].value[1]);

                $(".cpumem").removeClass(cpuload);
                $(".cpumem").addClass("p"+mem);

                cpuload = "p"+mem;

                if(mem>60){
                    $(".cpumem").removeClass("green");
                    $(".cpumem").addClass("orange");
                }else{
                    $(".cpumem").removeClass("orange");
                    $(".cpumem").addClass("green");
                }

                $(".cpumemtext").text(mem+"%");
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
                var ghz = clock - 2.0;
                var percent = Math.round(ghz / 3.4 * 100);

                $('.gaugeDemo1 .gauge-arrow').trigger('updateGauge', percent);
                $('.cpuclocktext').text(clock + " Ghz");
            },
            error: function(err){
                console.log(err);
            }

        });
    }

</script>
</html>
