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
            <a class="font-weight-normal text-secondary">&nbsp;가입대기회원</a>
        </div>

        <hr>

        <div class="col-12">
            <div class="float-right">
                <button class="btn btn-outline-success" onclick="check_accept();">선택 승인</button>
                <button class="btn btn-outline-danger" onclick="check_reject();">선택 거절</button>
            </div>
        </div>

        <div class="col">
            <table class="table table-bordered text-center" id="waitingTable">
                <thead class="thead-dark">
                <tr>
                    <th scope="col"><input type="checkbox" class="mt-1" id="checkall"></th>
                    <th scope="col">아이디</th>
                    <th scope="col">이름</th>
                    <th scope="col">이메일</th>
                    <th scope="col">가입신청일</th>
                    <th scope="col">관리</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><input type="checkbox" class="mt-1" name="chk"></td>
                    <td>user3</td>
                    <td>유저3</td>
                    <td>user3@naver.com</td>
                    <td>2019-09-19 15:35:00</td>
                    <td class="p-0 m-0"><button class="btn btn-outline-dark mt-1" onclick="accept();">승인</button> <button class="btn btn-outline-dark mt-1" onclick="reject();">거절</button></td>
                </tr>
                </tbody>
            </table>
        </div>

    </div>

</div>


</body>
<script type="text/javascript">
    $(document).ready(function(){
        //최상단 체크박스 클릭
        $("#checkall").click(function(){
            //클릭되었으면
            if($("#checkall").prop("checked")){
                //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
                $("input[name=chk]").prop("checked",true);
                //클릭이 안되있으면
            }else{
                //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
                $("input[name=chk]").prop("checked",false);
            }
        })
    })

    var table = $("#waitingTable").DataTable({
        // 표시 건수기능
        lengthChange: false,
        // 검색 기능
        searching: true,
        // 정렬 기능
        ordering: false,
        // 정보 표시
        info: false,
        // 페이징 기능
        paging: true,
        order: [],
        //표시건수
        displayLength: 20
    });

    function accept(){

        swal({
            title: "가입신청을 승인하시겠습니까?",
            text: "승인하시면 가입 대기 회원에서 사라지며, 회원 리스트에서 관리하실 수 있습니다. 취소하시려면 \"Cancle\" 버튼을 눌러주세요.",
            type: "info",
            showCancelButton: true,
            allowEscapeKey: false,
            allowOutsideClick: false,
        }).then(function (result) {

            if (result.dismiss === "cancel") { // 취소면 그냥 나감
                return false;
            }

            //기능추가(승인)

        });

    }

    function reject(){

        swal({
            title: "가입신청을 거절하시겠습니까?",
            text: "거절하시면 가입 대기 회원에서 사라지며, 재승인 하실 수 없습니다. 취소하시려면 \"Cancle\" 버튼을 눌러주세요.",
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

    function check_accept(){

    }

    function check_reject(){


    }
</script>
</html>
