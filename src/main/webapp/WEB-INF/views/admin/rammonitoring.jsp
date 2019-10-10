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
            stroke-width: 1.5;
        }
        .overlay {
            fill: none;
            pointer-events: all;
        }

        /* Style the dots by assigning a fill and stroke */
        .dot {
            fill: steelblue;
        }

        .focus circle {
            fill: none;
            stroke: steelblue;
        }

        .toolTip {
            position: absolute;
            border: 1px solid;
            border-radius: 4px 4px 4px 4px;
            background: rgba(0, 0, 0, 0.8);
            color : white;
            padding: 5px;
            text-align: center;
            font-size: 12px;
            min-width: 30px;
        }

    </style>

</head>
<body>

<div class="row" style="margin-left:250px">
    <div class="col h-100">

        <div class="row m-3">
            <a class="font-weight-bold text-secondary">자원관리 > </a>
            <a class="font-weight-normal text-secondary">&nbsp;RAM 모니터링</a>
        </div>

        <hr>

        <div class="row">
            <div class="col">
                <div class="row ml-2">
                    <div class="col w-100">
                        <div class="row">
                            <div class="col">
                                <h5 class="font-weight-bold text-secondary mt-3">LOAD</h5>
                                <div class="c100 custom green ml-5 rammem">
                                    <span class="rammemtext"></span>
                                    <div class="slice">
                                        <div class="bar"></div>
                                        <div class="fill"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <a href="#" style="color: black;margin-left: 92%" onclick="detail();" id="memdetailtext">상세보기 <i class="fa fa-caret-down" aria-hidden="true"></i></a>
                </div>

                <hr class="m-2 mt-3 mb-3">

                <div style="display: none" id="memdetail">
                    <div class="row ml-2">
                        <div class="col">
                            <h5>MEM LOAD</h5>
                            <div class="row mt-2">
                                <div class="col-2">
                                    <div class="col mt-5">
                                        <div class="c100 custom green ml-5 rammem">
                                            <span class="rammemtext"></span>
                                            <div class="slice">
                                                <div class="bar"></div>
                                                <div class="fill"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col ml-3">
                                    <svg class="ml-3" id="chart"></svg>
                                </div>
                                <div class="col-2 mr-5" style="margin-bottom: auto;margin-top: auto">
                                    <table class="table text-center table-hover border-bottom">
                                        <tr>
                                            <td class="h5 font-weight-bold" scope="col">최고</td>
                                            <td class="font-weight-bold" scope="col" id="memmax">89</td>
                                        </tr>
                                        <tr>
                                            <td class="h5 font-weight-bold">최저</th>
                                            <td class="font-weight-bold" id="memmin">15</td>
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

    $(document).ready(function(){
        update();

        setInterval(function() {
            update();
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
/* 
    var div = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);
 */
    // 범례추가
    svg.append("circle").attr("cx",840).attr("cy", 0).attr("r", 6).style("fill", "steelblue")
    svg.append("text").attr("x", 850).attr("y", 0).text("memory").style("font-size", "15px").attr("alignment-baseline","middle")
/* 
        // 12. Appends a circle for each datapoint
        var dot = svg.selectAll(".dot")
            .data(dataset)
            .enter().append("circle") // Uses the enter().append() method
            .attr("class", "dot") // Assign a class for styling
            .attr("cx", function(d, i) { return xScale(moment.unix(d[0]).toDate()) })
            .attr("cy", function(d) { return yScale(d[1]) })
            .attr("r", 1)
            .on("mouseover", function(d) {
                //console.log(d);
                //d3.select(this).transition().duration('50').attr('r', 5);
                div.transition()
                    .duration(200)
                    .style("opacity", .9);
                div.html(formatDate(new Date(d[0]*1000)) + "<br/>"  + Number(d[1]).toFixed(2))
                    .style("left", (d3.event.pageX) + "px")
                    .style("top", (d3.event.pageY - 28) + "px")

                console.log(pos.y)
            }).on("mouseout", function(){
                //d3.select(this).transition().duration('50').attr('r', 3);
                    div.transition()
                        .duration(500)
                        .style("opacity", 0);
            });
 */
    var ramload = null;

    function update(){
        $.ajax({
            url:"<%=cp%>/get/single/mem",
            type:"POST",
            dataType:"json",
            async:false,
            data:{},
            success:function(data){
                var mem = Math.round(data.data.result[0].value[1]);

                $(".rammem").removeClass(ramload);
                $(".rammem").addClass("p"+mem);

                ramload = "p"+mem;

                if(mem>60){
                    $(".rammem").removeClass("green");
                    $(".rammem").addClass("orange");
                }else{
                    $(".rammem").removeClass("orange");
                    $(".rammem").addClass("green");
                }

                $(".rammemtext").text(mem+"%");
            },
            error: function(err){
                console.log(err);
            }

        });
    }

    function detail(){
        if($('#memdetail').css("display")=="none"){
            $('#memdetail').css("display","block");
            $('#memdetailtext').html("상세보기 <i class=\"fa fa-caret-up\" aria-hidden=\"true\"></i>");
        }else{
            $('#memdetail').css("display","none");
            $('#memdetailtext').html("상세보기 <i class=\"fa fa-caret-down\" aria-hidden=\"true\"></i>");
        }
    }

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

        xScale.domain([moment.unix(dataset[0][0]).toDate(), moment.unix(dataset[dataset.length-1][0]).toDate()]);
        yScale.domain([Number(min)-1, Number(max)+1]);

        // redraw the line, and slide it to the left

        /*
        path
            .attr("d", line)
            .attr("transform", null)
            .transition()
            .duration(500)
            .attr("transform", "translate(" + xScale(moment.unix(dataset[0][0]).toDate()) + ",0)");
        */

        path // 기본 변환행렬 초기화
            .attr("d", line)
            .attr("transform", null); // 선을 다시 그린다.

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

        // pop the old data point off the front
        dataset.shift();
    }

    // tooltip 추가시 추가
    function formatDate(date) {
        var m = date.getMonth()+1;
        var d = date.getDate();
        var h = date.getHours();
        var i = date.getMinutes();
        var s = date.getSeconds();
        //return date.getFullYear()+'/'+(m>9?m:'0'+m)+'/'+(d>9?d:'0'+d)+' '+(h>9?h:'0'+h)+':'+(i>9?i:'0'+i)+':'+(s>9?s:'0'+s);
        return (h>9?h:'0'+h)+'시 '+(i>9?i:'0'+i)+'분 '+(s>9?s:'0'+s)+'초';
    }

</script>
</html>
