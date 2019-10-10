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
            <a class="font-weight-normal text-secondary">&nbsp;회원리스트</a>
        </div>

        <hr>

        <div class="col">
            <table class="table table-bordered text-center" id="userTable">
                <thead class="thead-dark">
                <tr>
                    <th scope="col">아이디</th>
                    <th scope="col">이름</th>
                    <th scope="col">등급</th>
                    <th scope="col">이메일</th>
                    <th scope="col">가입승인일</th>
                    <th scope="col">최근 접속일</th>
                    <th scope="col">상태</th>
                    <th scope="col">관리</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>user1</td>
                    <td>유저1</td>
                    <td>관리자</td>
                    <td>user@naver.com</td>
                    <td>2019-09-18 13:35:00</td>
                    <td>2019-09-18 18:03:00</td>
                    <td>승인</td>
                    <td><button class="btn btn-outline-dark"><i class="fas fa-wrench"></i></button> <button class="btn btn-outline-dark" onclick="userdel()"><i class="far fa-trash-alt"></i></button></td>
                </tr>
                <tr>
                    <td>user2</td>
                    <td>유저2</td>
                    <td>회원</td>
                    <td>user2@naver.com</td>
                    <td>2019-09-19 09:35:00</td>
                    <td>2019-09-19 15:03:00</td>
                    <td>승인</td>
                    <td><button class="btn btn-outline-dark"><i class="fas fa-wrench"></i></button> <button class="btn btn-outline-dark" onclick="userdel()"><i class="far fa-trash-alt"></i></button></td>
                </tr>
                <tr>
                    <td>user3</td>
                    <td>유저3</td>
                    <td>회원</td>
                    <td>user3@naver.com</td>
                    <td>2019-09-19 15:35:00</td>
                    <td></td>
                    <td>미승인</td>
                    <td><button class="btn btn-outline-dark"><i class="fas fa-wrench"></i></button> <button class="btn btn-outline-dark" onclick="userdel()"><i class="far fa-trash-alt"></i></button></td>
                </tr>
                </tbody>
            </table>
        </div>

    </div>

</div>


</body>
<script type="text/javascript">
    var table = $("#userTable").DataTable({
        // 표시 건수기능
        lengthChange: false,
        // 검색 기능
        searching: true,
        // 정렬 기능
        ordering: true,
        // 정보 표시
        info: false,
        // 페이징 기능
        paging: true,
        order: [],
        //표시건수
        displayLength: 20,
    });

    function userdel(){

        swal({
            title: "회원을 삭제하시겠습니까?",
            text: "삭제하시면 해당 회원은 탈퇴 처리 되며, 관련된 모든 정보가 사라집니다. 삭제하시겠습니까?",
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
