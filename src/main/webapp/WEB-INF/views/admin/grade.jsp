<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2019-09-18
  Time: 오후 12:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <jsp:include page="sidebar.jsp"></jsp:include>
</head>
<body>

<div class="row" style="margin-left:250px">
    <div class="col h-100">

        <div class="row m-3">
            <a class="font-weight-bold text-secondary">회원관리 > </a>
            <a class="font-weight-normal text-secondary">&nbsp;회원등급관리</a>
        </div>

        <hr>

        <div class="col">

            <button class="btn btn-outline-dark float-right mb-3">관리 등급 추가</button>

            <table class="table table-bordered text-center">
                <thead class="thead-dark">
                <tr>
                    <th scope="col">우선순위</th>
                    <th scope="col">등급명</th>
                    <th scope="col">회원수</th>
                    <th scope="col">생성일자</th>
                    <th scope="col">관리</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>1</td>
                    <td>관리자</td>
                    <td>2</td>
                    <td>2019-09-18 11:57:00</td>
                    <td><button class="btn btn-outline-dark" onclick="update();"><i class="fas fa-wrench"></i></button> <button class="btn btn-outline-dark" onclick="del();"><i class="far fa-trash-alt"></i></button></td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>회원</td>
                    <td>89</td>
                    <td>2019-09-18 12:00:00</td>
                    <td><button class="btn btn-outline-dark" onclick="update();"><i class="fas fa-wrench"></i></button> <button class="btn btn-outline-dark" onclick="del();"><i class="far fa-trash-alt"></i></button></td>
                </tr>
                <tr>
                    <td>99</td>
                    <td>default</td>
                    <td>30</td>
                    <td>2019-09-17 16:27:00</td>
                    <td></td>
                </tr>
                </tbody>
            </table>
        </div>

    </div>

</div>


</body>
<script type="text/javascript">
    function update(){

    }

    function del(){
        swal({
            title: "해당 등급을 삭제하시겠습니까?",
            text: "확인하시면 해당 등급이 삭제되며, 포함된 회원은 default 등급으로 변경됩니다. 취소하시려면 \"Cancle\" 버튼을 눌러주세요.",
            type: "warning",
            showCancelButton: true,
            allowEscapeKey: false,
            allowOutsideClick: false,
        }).then(function (result) {

            if (result.dismiss === "cancel") { // 취소면 그냥 나감
                return false;
            }

            //기능추가(거절)

        });
    }
</script>
</html>
