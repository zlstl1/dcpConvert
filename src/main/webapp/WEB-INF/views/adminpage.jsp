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
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/circle.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/cmGauge.css">


<link rel="stylesheet" href="<%=cp%>/resources/css/all.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/fontawesome.css">

</head>
<body class="subpage">

	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/import/navbar.jsp" /> --%>
	<%-- <%@include file="import/navbar.jsp" %> --%>
	<jsp:include page="import/navbar.jsp"></jsp:include>

	<!-- One -->
	<section id="One" class="wrapper style3">
		<div class="inner">
			<header class="align-center">
				<p>회원관리 및 자원 모니터링이 가능합니다.</p>
				<h2>관리자 페이지</h2>
			</header>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style2">
		<div class="inner">
			<div class="box">
				<div class="content">
					<div class="row text-left">
						<div class="col">
							<h4>
								<a href="<%=cp%>/dcp/cpumonitoring" style="color: #000;">CPU</a>
							</h4>
							<div class="row ml-2">
								<div class="col">
									<p class="font-weight-bold text-secondary mt-3">LOAD</p>
									<div class="c100 custom green ml-5" id="cpumem">
										<span id="cpumemtext"></span>
										<div class="slice">
											<div class="bar"></div>
											<div class="fill"></div>
										</div>
									</div>
								</div>

								<div class="col">
									<p class="font-weight-bold text-secondary mt-3 mb-4">CLOCK
										SPEED</p>
									<div id="gaugeDemo3" class="gauge gauge-big ml-3">
										<div class="gauge-arrow" data-percentage="98"
											style="transform: rotate(0deg);"></div>
									</div>
									<h4 class="mt-3 text-center text-secondary" id="cpuclocktext"></h4>
								</div>

							</div>
						</div>
						<div class="col-3">
							<h4>
								<a href="<%=cp%>/dcp/rammonitoring" style="color: #000;">RAM</a>
							</h4>
							<div class="row ml-2">
								<div class="col">
									<p class="font-weight-bold text-secondary mt-3">LOAD</p>
									<div class="c100 custom green ml-5" id="rammem">
										<span id="rammemtext"></span>
										<div class="slice">
											<div class="bar"></div>
											<div class="fill"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-3">
							<h4>STORAGE</h4>
							<div class="row h-75">
								<div class="col" style="margin-top: auto; margin-bottom: auto">
									<p class="font-weight-bold text-secondary">C:Drive</p>
									<div class="progress" style="height: 50px;">
										<div class="progress-bar" role="progressbar"
											style="width: 49%;" aria-valuenow="25" aria-valuemin="0"
											aria-valuemax="100" id="memused">
											<h4 id="memusedtext"></h4>
										</div>
									</div>

									<p class="font-weight-bold text-secondary mt-3 text-center">
										Used : <a id="diskused"></a> / Free : <a id="diskfree"></a>
									</p>
								</div>
							</div>
						</div>
					</div>

					<hr class="m-2">

						<div class="row text-left">
							<div class="col">

								<h4 class="m-0 p-0">
									<a href="<%=cp%>/dcp/gpumonitoring1" style="color: #000;">GPU 1</a>
								</h4>

								<div class="row ml-2">
									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">TEMP</p>
												<i class="fas fa-3x mt-5 ml-5 gputemp1"></i> <a
													class="fa-3x mt-3 ml-5 gputemptext1"></a>
											</div>
										</div>

									</div>

									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">LOAD</p>
												<div class="c100 custom green ml-5 gpumem1">
													<span class="gpumemtext1"></span>
													<div class="slice">
														<div class="bar"></div>
														<div class="fill"></div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">CLOCK SPEED</p>

												<div class="row text-center mt-4">
													<div class="col">
														<div class="gauge gauge-big gaugeDemo1">
															<div class="gauge-arrow" data-percentage="9"
																style="transform: rotate(0deg);"></div>
														</div>
													</div>
												</div>
												<h4 class="mt-3 text-center text-secondary gpuclocktext1"></h4>

											</div>

										</div>

									</div>

								</div>

							</div>


						</div>
						
						<hr class="m-2">
						
						<div class="row text-left">
							<div class="col">

								<h4 class="m-0 p-0">
									<a href="<%=cp%>/dcp/gpumonitoring2" style="color: #000;">GPU 2</a>
								</h4>

								<div class="row ml-2">
									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">TEMP</p>
												<i class="fas fa-3x mt-5 ml-5 gputemp2"></i> <a
													class="fa-3x mt-3 ml-5 gputemptext2"></a>
											</div>
										</div>

									</div>

									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">LOAD</p>
												<div class="c100 custom green ml-5 gpumem1">
													<span class="gpumemtext2"></span>
													<div class="slice">
														<div class="bar"></div>
														<div class="fill"></div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">CLOCK SPEED</p>

												<div class="row text-center mt-4">
													<div class="col">
														<div class="gauge gauge-big gaugeDemo2">
															<div class="gauge-arrow" data-percentage="9"
																style="transform: rotate(0deg);"></div>
														</div>
													</div>
												</div>
												<h4 class="mt-3 text-center text-secondary gpuclocktext2"></h4>

											</div>

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
	<script src="<%=cp%>/resources/js/adminpage.js"></script>
	<script src="<%=cp%>/resources/js/cmGauge.js"></script>

	<script src="<%=cp%>/resources/js/fontawesome.js"></script>

</body>
</html>