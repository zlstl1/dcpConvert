<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2019-06-11
  Time: 오후 4:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String cp = request.getContextPath();
%>
<html>
<head>
	<link rel="stylesheet" href="<%=cp%>/resources/css/bootstrap.css">
    <link rel="stylesheet" href="<%=cp%>/resources/css/datatables.css">
    <link rel="stylesheet" href="<%=cp%>/resources/css/circle.css">
    <link rel="stylesheet" href="<%=cp%>/resources/css/cmGauge.css">
    
    <link rel="stylesheet" href="../webjars/font-awesome/5.8.1/css/fontawesome.css">
    <link rel="stylesheet" href="../webjars/font-awesome/5.8.1/css/all.css">
      
    <link rel="stylesheet" href="../webjars/sweetalert2/dist/sweetalert2.css">
    

    
    <title>dashboard</title>
</head>
<style>
    body{
        background-color: white;
    }

    #page-wrapper {
        padding-left: 250px;
    }

    #sidebar-wrapper {
        position: fixed;
        width: 250px;
        height: 100%;
        margin-left: -250px;
        background: #000;
        overflow-x: hidden;
        overflow-y: auto;
    }

    .sidebar-nav {
        width: 250px;
        margin: 0;
        padding: 0;
        list-style: none;
    }

    .sidebar-nav li {
        text-indent: 1.5em;
        line-height: 2.8em;
    }

    .sidebar-nav li a {
        display: block;
        text-decoration: none;
        color: #999;
    }

    .sidebar-nav li a:hover {
        color: #fff;
        background: rgba(255, 255, 255, 0.2);
    }

    .sidebar-nav > .sidebar-brand {
        font-size: 1.3em;
        line-height: 3em;
    }

    .dropmenu{
        border:none;
        border:0px;
        margin:0px;
        padding:0px;
        width: 100%;
    }

    .dropmenu ul{
        background: #6c757d;
        list-style: none;
        margin:0;
        padding:0;
    }

    .dropmenu li{
        float:left;
        padding:0px;
    }

    .dropmenu li a{
        background: #6c757d;
        color: #000;
        display: block;
        line-height: 50px;
        margin:0px;
        padding:0px;
        text-align: center;
        text-decoration: none;
    }

    .dropmenu li a:hover, .dropmenu ul li:hover a{
        background: #6c757d;
        color : #000000;
        text-decoration: none;
    }

    .dropmenu li ul{
        background: #6c757d;
        display: none;
        height: auto;
        border: 0px;
        position: absolute;
        width: 100px;
        z-index: 1;
    }

    .dropmenu li:hover ul{
        display: block;
    }

    .dropmenu li li {
        background: #6c757d;
        display: block;
        float: none;
        margin: 0px;
        padding: 0px;
    }

    .dropmenu li:hover li a{
        background: none;
    }

    .dropmenu li ul a {
        display: block;
        height: 50px;
        font-size: 14px;
        margin: 0px;
        padding: 0px 10px 0px 10px;
        text-align: left;
    }

    .dropmenu li ul a:hover, .dropmenu li ul li:hover a{
        background: gray;
        border:0px;
        color: #000;
        text-decoration: none;
    }

    .dropmenu p{
        clear:left;
    }

</style>
<body style="overflow-x:hidden; overflow-y:auto;">

<div id="page-wrapper">
    <!-- 사이드바 -->
    <div id="sidebar-wrapper">
        <ul class="sidebar-nav">
            <li class="sidebar-brand">
                <a class="text-white" href="<%=cp%>/dcp/dashboard">Dashboard Template</a>
            </li>
            <li><a href="">자원관리</a>
                <ul>
                    <li><a href="<%=cp%>/dcp/cpumonitoring">CPU 모니터링</a></li>
                    <li><a href="<%=cp%>/dcp/gpumonitoring">GPU 모니터링</a></li>
                    <li><a href="<%=cp%>/dcp/rammonitoring">RAM 모니터링</a></li>
                </ul>
            </li>


            <li><a href="">회원관리</a>
                <ul>
                    <li><a href="<%=cp%>/dcp/userlist">회원리스트</a></li>
                    <li><a href="<%=cp%>/dcp/waiting">가입대기회원</a></li>
                    <li><a href="<%=cp%>/dcp/grade">회원등급관리</a></li>
                </ul>
            </li>

        </ul>
    </div>

    <div class="row bg-secondary p-3 text-right">
        <%--
                <div class="col pr-3 pt-1" style="margin-bottom: auto; margin-top: auto;">
                    <i class="far fa-bell fa-lg mb-2"></i>
                </div>
                <div class="col-0 p-0 mr-5">

                    <button class="btn btn-secondary dropdown-toggle" type="button" style="color: black">
                            <i class="far fa-user-circle fa-lg"></i> Admin</i>
                        </button>
                    <div id="hidden_li" class="bg-secondary">
                        <ul style="padding: 0px; text-align: left">
                            <li><a class="dropdown-item" href="#">my page</a></li>
                            <li><a class="dropdown-item" href="#">logout</a></li>
                        </ul>
                    </div>
                </div>
        --%>

        <div class="dropmenu">
            <div class="row">
                <div class="col pr-3 pt-1" style="margin-bottom: auto; margin-top: auto;">
                    <a href="#" style="color: black"><i class="far fa-bell fa-lg mb-2"></i></a>
                </div>

                <div class="col-0 p-0 mr-5">
                    <ul>
                        <li><i class="far fa-user-circle fa-lg" id="current"></i> Admin <i class="fa fa-caret-down" aria-hidden="true"></i>
                            <ul>
                                <li><a class="dropdown-item" href="#">my page</a></li>
                                <hr class="m-0">
                                <li><a class="dropdown-item" href="#">logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="<%=cp%>/resources/jquery/jQuery3.4.1.js"></script>
<script src="<%=cp%>/resources/js/bootstrap.bundle.js"></script>
<script src="<%=cp%>/resources/js/datatables.min.js"></script>
<script src="<%=cp%>/resources/js/moment.js"></script>
<script src="<%=cp%>/resources/js/cmGauge.js"></script>
<script src="<%=cp%>/resources/js/d3.min.js"></script>
<script src="../webjars/font-awesome/5.8.1/js/fontawesome.js"></script>

<script src="../webjars/sweetalert2/dist/sweetalert2.min.js"></script>

</body>
</html>
