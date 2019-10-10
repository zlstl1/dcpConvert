<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>DCP Converter</title>
  
  	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
	<link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath }/resources/img/titleIcon.png" sizes="128x128"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/main.css">
</head>
<body>

	<!-- Header -->
	<header id="header" class="alt">
		<div class="logo"><a href="${pageContext.request.contextPath}/dcp/login">DCP <span>Converter</span></a></div>
		<a href="#menu">Menu</a>
	</header>

	<!-- Nav -->
	<nav id="menu">
		<ul class="links">
			<c:if test="${!empty user.user_id}">
				<li><a href="${pageContext.request.contextPath}/dcp/${user.user_id}">내 파일</a></li>
				<li><a href="${pageContext.request.contextPath}/dcp/${user.user_id}/history">사용내역</a></li>
				<c:if test="${user.user_admin}">
					<li><a href="${pageContext.request.contextPath}/dcp/${user.user_id}/adminpage">관리자 페이지</a></li>
				</c:if>
				<li><a href="${pageContext.request.contextPath}/dcp/logout">로그아웃</a></li>
			</c:if>
			<c:if test="${empty user.user_id}">
				<li><a href="${google_url}">로그인</a></li>
			</c:if>
		</ul>
	</nav>
	
	<!-- Banner -->
	<section class="banner full">
		<article>
			<img src="${pageContext.request.contextPath}/resources/assets/img/slide01.jpg" alt="" />
			<div class="inner">
				<header>
					<p>동영상 파일로부터 TIFF 포맷의 시퀀스 파일 추출</p>
					<h2>TIFF 시퀀스</h2>
				</header>
			</div>
		</article>
		<article>
			<img src="${pageContext.request.contextPath}/resources/assets/img/slide02.jpg" alt="" />
			<div class="inner">
				<header>
					<p>GPU 가속화를 통한 디지털 시네마 JPEG2000 인코딩</p>
					<h2>GPU 가속화</h2>
				</header>
			</div>
		</article>
		<article>
			<img src="${pageContext.request.contextPath}/resources/assets/img/slide03.jpg"  alt="" />
			<div class="inner">
				<header>
					<p>Interop / SMPTE DCP 제작</p>
					<h2>DCP 표준</h2>
				</header>
			</div>
		</article>
	</section>

	<!-- One -->
	<section id="one" class="wrapper style2">
		<div class="inner">
			<div class="grid-style">

				<div>
					<div class="box">
						<div class="image fit">
							<img src="${pageContext.request.contextPath}/resources/assets/img/card01.jpg" alt="" />
						</div>
						<div class="content">
							<header class="align-center">
								<p>GPU 가속화를 통한 디지털 시네마 JPEG2000 인코딩</p>
								<h2>GPU 가속화</h2>
							</header>
							<p> 연산집약적인 부분을 병렬 처리에 효과적 수천개의 코어를 내장한 그래픽 처리 장치(GPU)에서 수행하고, 이를 CPU에서 스케줄링함으로써 기존의 CPU 인코딩 방식보다 빠른 JPEG2000 인코딩을 수행합니다. </p>
							<!-- <footer class="align-center">
								<a href="#" class="button alt">Learn More</a>
							</footer> -->
						</div>
					</div>
				</div>

				<div>
					<div class="box">
						<div class="image fit">
							<img src="${pageContext.request.contextPath}/resources/assets/img/card02.jpg" alt="" />
						</div>
						<div class="content">
							<header class="align-center">
								<p>Interop / SMPTE DCP 제작</p>
								<h2>DCP 표준</h2>
							</header>
							<p> 프레임 레이트(24/25/30/48/50/60/96), 프레임 사이즈(Scope/Flat), 영상의 색공간(XYZ), 오디오 샘플링 규격(24bpp/48Khz), DCP 전송속도(10~250) 등 Interop / SMPTE 국제규격을 준수하여 DCP를 제작합니다. </p>
							<!-- <footer class="align-center">
								<a href="#" class="button alt">Learn More</a>
							</footer> -->
						</div>
					</div>
				</div>

			</div>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style3">
		<div class="inner">
			<header class="align-center">
				<p>웹 클라우드의 형태로 파일을 업/다운로드 가능하며 변환 및 저장이 가능합니다.</p>
				<h2>클라우드 형태의 서비스</h2>
			</header>
		</div>
	</section>

	<!-- Three -->
		<section id="three" class="wrapper style2">
			<div class="inner">
				<header class="align-center">
					<p class="special">Nam vel ante sit amet libero scelerisque facilisis eleifend vitae urna</p>
					<h2>Morbi maximus justo</h2>
				</header>
				<div class="gallery">
					<div>
						<div class="image fit">
							<a href="#"><img src="${pageContext.request.contextPath}/resources/assets/img/slide01.jpg" alt="" /></a>
						</div>
					</div>
					<div>
						<div class="image fit">
							<a href="#"><img src="${pageContext.request.contextPath}/resources/assets/img/slide02.jpg" alt="" /></a>
						</div>
					</div>
					<div>
						<div class="image fit">
							<a href="#"><img src="${pageContext.request.contextPath}/resources/assets/img/slide03.jpg" alt="" /></a>
						</div>
					</div>
					<div>
						<div class="image fit">
							<a href="#"><img src="${pageContext.request.contextPath}/resources/assets/img/slide03.jpg" alt="" /></a>
						</div>
					</div>
				</div>
			</div>
		</section>


	<!-- Footer -->
	<%@include file="import/footer.jsp" %>
	
	<script src="${pageContext.request.contextPath}/resources/jquery/jQuery3.4.1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/jquery.scrollex.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/skel.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/util.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>
</body>
</html>