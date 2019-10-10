var gpu1load = null;
var gpu2load = null;

$(document).ready(function() {

	$('#gaugeDemo1 .gauge-arrow').cmGauge();

	$('#gaugeDemo2 .gauge-arrow').cmGauge();

	$('#gaugeDemo3 .gauge-arrow').cmGauge();
	/*
	 * $('#gaugeDemo3 .gauge-arrow').cmGauge(); $.ajax({ url :
	 * getContextPath()+"/get/single/gpu", type : "POST", dataType : "json",
	 * async : false, data : {}, success : function(data) { for (var i = 1; i <=
	 * data.data.result.length; i++) { var div = document.createElement('div');
	 * div.className = 'row ml-2'; div.innerHTML = '<div class="col">\n' + '
	 * <div class="row">\n' + ' <h4 class="m-0 p-0"><a
	 * href="'+getContextPath()+'/dcp/gpumonitoring" style="color:#000;">GPU '+
	 * i + '</a></h4>\n' + ' </div>\n' + ' <div class="row ml-2">\n' + ' <div
	 * class="col">\n' + ' <p class="font-weight-bold text-secondary mt-3">TEMP</p>\n' + '
	 * <i class="fas fa-3x mt-5 ml-5 gputemp'+ i + '"></i>\n' + ' <a
	 * class="fa-3x mt-3 ml-5 gputemptext'+ i + '"></a>\n' + ' </div>\n' + '\n' + '
	 * <div class="col">\n' + ' <p class="font-weight-bold text-secondary mt-3">LOAD</p>\n' + '
	 * <div class="c100 custom green ml-5 gpumem'+ i + '">\n' + ' <span
	 * class="gpumemtext'+ i + '"></span>\n' + ' <div class="slice">\n' + '
	 * <div class="bar"></div>\n' + ' <div class="fill"></div>\n' + '
	 * </div>\n' + ' </div>\n' + ' </div>\n' + '\n' + ' <div class="col">\n' +'<div
	 * class="row">'
	 *  +'<div class="col">' + '
	 * <p class="font-weight-bold text-secondary mt-3 mb-4">CLOCK SPEED</p>\n' +'</div>' +'</div>' +'<div
	 * class="row text-center">' +'<div class="col">'
	 *  + ' <div class="gauge gauge-big gaugeDemo'+ i + '">\n' + ' <div
	 * class="gauge-arrow" data-percentage="9"\n' + ' style="transform:
	 * rotate(0deg);"></div>\n' + ' </div>\n' + ' <h4 class="mt-3 text-center
	 * text-secondary gpuclocktext'+ i + '"></h4>\n' +'</div>' +'</div>' + '
	 * </div>\n' + '\n' + ' </div>\n' + ' <hr class="m-2 mt-3">';
	 * 
	 * document.getElementById('gpu') .appendChild(div); $('.gaugeDemo' + i + '
	 * .gauge-arrow') .cmGauge();
	 * 
	 * $('.gpumem' + i.toString()) .addClass( "p"+ data.data.result[i -
	 * 1].value[1]); $('.gpumemtext' + i.toString()) .text(data.data.result[i -
	 * 1].value[1]+ "%"); } gpu1load = "p" + data.data.result[0].value[1];
	 * gpu2load = "p" + data.data.result[1].value[1]; }, error : function(err) {
	 * console.log(err); }
	 * 
	 * });
	 */
	update();
	// update
	// $('#gaugeDemo .gauge-arrow').trigger('updateGauge', new
	// Values);

	setInterval(function() {
		update();
	}, 10000);

});

var cpuload = null;
var ramload = null;

function update() {

	$.ajax({
		url : getContextPath() + "/get/single/gpu",
		type : "POST",
		dataType : "json",
		async : false,
		data : {},
		success : function(data) {
			
			for (var i = 1; i <= data.data.result.length; i++) {
				$('.gaugeDemo' + i + ' .gauge-arrow').cmGauge();

				$('.gpumem' + i.toString()).addClass("p" + data.data.result[i - 1].value[1]);
				$('.gpumemtext' + i.toString()).text(data.data.result[i - 1].value[1] + "%");
			}
			
			gpu1load = "p" + data.data.result[0].value[1];
			gpu2load = "p" + data.data.result[1].value[1];
		},
		error : function(err) {
			console.log(err);
		}

	});

	$.ajax({
		url : getContextPath() + "/get/single/cpu",
		type : "POST",
		dataType : "json",
		data : {},
		success : function(data) {
			var mem = Math.round(data.data.result[0].value[1]);

			$("#cpumem").removeClass(cpuload);
			$("#cpumem").addClass("p" + mem);

			cpuload = "p" + mem;

			if (mem > 60) {
				$("#cpumem").removeClass("green");
				$("#cpumem").addClass("orange");
			} else {
				$("#cpumem").removeClass("orange");
				$("#cpumem").addClass("green");
			}

			$("#cpumemtext").text(mem + "%");

		},
		error : function(err) {
			console.log(err);
		}

	});

	$.ajax({
		url : getContextPath() + "/get/single/cpuClock",
		type : "POST",
		dataType : "json",
		data : {},
		success : function(data) {
			// 2.0 ~ 3.4
			var clock = (data.data.result[0].value[1] / Math.pow(10, 9))
					.toFixed(1);
			var mhz = clock - 2.0;
			var percent = Math.round(mhz / 3.4 * 100);

			$('#gaugeDemo3 .gauge-arrow').trigger('updateGauge', percent);

			$('#cpuclocktext').text(clock + " Ghz");
		},
		error : function(err) {
			console.log(err);
		}

	});

	$.ajax({
		url : getContextPath() + "/get/single/mem",
		type : "POST",
		dataType : "json",
		data : {},
		success : function(data) {
			var mem = Math.round(data.data.result[0].value[1]);

			$("#rammem").removeClass(ramload);
			$("#rammem").addClass("p" + mem);

			ramload = "p" + mem;

			if (mem > 60) {
				$("#rammem").removeClass("green");
				$("#rammem").addClass("orange");
			} else {
				$("#rammem").removeClass("orange");
				$("#rammem").addClass("green");
			}

			$("#rammemtext").text(mem + "%");
		},
		error : function(err) {
			console.log(err);
		}

	});

	var disktotal;
	$.ajax({
		url : getContextPath() + "/get/single/disksizetotal",
		type : "POST",
		dataType : "json",
		async : false,
		data : {},
		success : function(data) {
			var total = data.data.result[0].value[1] / Math.pow(10, 9);
			disktotal = total;
		},
		error : function(err) {
			console.log(err);
		}

	});

	$.ajax({
		url : getContextPath() + "/get/single/disksize",
		type : "POST",
		dataType : "json",
		async : false,
		data : {},
		success : function(data) {
			var used = data.data.result[0].value[1] / Math.pow(10, 9);
			var free = disktotal - used;

			$("#diskused").text(used.toFixed(2) + " GB");
			$("#diskfree").text(free.toFixed(2) + " GB");

			var percent = used / disktotal * 100;

			$('#memusedtext').text(Math.round(percent) + "%");
			$('#memused').width(Math.round(percent) + '%');
		},
		error : function(err) {
			console.log(err);
		}

	});

	$
			.ajax({
				url : getContextPath() + "/get/single/gpu_temp",
				type : "POST",
				dataType : "json",
				async : false,
				data : {},
				success : function(data) {
					for (var i = 1; i <= data.data.result.length; i++) {
						$('.gputemp' + i.toString()).removeClass(
								"fa-thermometer-empty")
						$('.gputemp' + i.toString()).removeClass(
								"fa-thermometer-quarter");
						$('.gputemp' + i.toString()).removeClass(
								"fa-thermometer-half");
						$('.gputemp' + i.toString()).removeClass(
								"fa-thermometer-three-quarters");
						$('.gputemp' + i.toString()).removeClass(
								"fa-thermometer-full");
						$('.gputemp' + i.toString()).css({
							'color' : ''
						});
						if (Math.round(data.data.result[i - 1].value[1]) < 10) {
							$('.gputemp' + i.toString()).addClass(
									"fa-thermometer-empty");
						} else if (Math.round(data.data.result[i - 1].value[1]) >= 10
								&& Math.round(data.data.result[i - 1].value[1]) < 40) {
							$('.gputemp' + i.toString()).addClass(
									"fa-thermometer-quarter");
						} else if (Math.round(data.data.result[i - 1].value[1]) >= 40
								&& Math.round(data.data.result[i - 1].value[1]) < 60) {
							$('.gputemp' + i.toString()).addClass(
									"fa-thermometer-half");
						} else if (Math.round(data.data.result[i - 1].value[1]) >= 60
								&& Math.round(data.data.result[i - 1].value[1]) < 90) {
							$('.gputemp' + i.toString()).addClass(
									"fa-thermometer-three-quarters");
							$('.gputemp' + i.toString()).css("color", "orange");
						} else if (Math.round(data.data.result[i - 1].value[1]) >= 90) {
							$('.gputemp' + i.toString()).addClass(
									"fa-thermometer-full");
							$('.gputemp' + i.toString()).css("color", "red");
						}
						$('.gputemptext' + i.toString()).text(
								Math.round(data.data.result[i - 1].value[1])
										+ "°C");
					}

				},
				error : function(err) {
					console.log(err);
				}

			});

	$.ajax({
		url : getContextPath() + "/get/single/gpu",
		type : "POST",
		dataType : "json",
		async : false,
		data : {},
		success : function(data) {
			// p+data 추가(removeClass)
			$(".gpumem1").removeClass(gpu1load);
			$(".gpumem2").removeClass(gpu2load);

			for (var i = 1; i <= data.data.result.length; i++) {
				$('.gpumem' + i.toString()).addClass(
						"p" + data.data.result[i - 1].value[1]);
				$('.gpumemtext' + i.toString()).text(
						data.data.result[i - 1].value[1] + "%");

				if (data.data.result[i - 1].value[1] > 60) {
					$(".gpumem" + i.toString()).removeClass("green");
					$(".gpumem" + i.toString()).addClass("orange");
				} else {
					$(".gpumem" + i.toString()).removeClass("orange");
					$(".gpumem" + i.toString()).addClass("green");
				}

			}
		},
		error : function(err) {
			console.log(err);
		}
	});

	$.ajax({
		url : getContextPath() + "/get/single/gpu_clock",
		type : "POST",
		dataType : "json",
		async : false,
		data : {},
		success : function(data) {
			// 0-2000 Mhz
			for (var i = 1; i <= data.data.result.length; i++) {
				$('.gaugeDemo' + i.toString() + " .gauge-arrow").trigger(
						'updateGauge',
						data.data.result[i - 1].value[1] / 2000 * 100);
				$('.gpuclocktext' + i.toString()).text(
						data.data.result[i - 1].value[1] + " Ghz");
			}
		},
		error : function(err) {
			console.log(err);
		}

	});
}

function getContextPath() {
	var offset = location.href.indexOf(location.host) + location.host.length;
	var ctxPath = location.href.substring(offset, location.href.indexOf('/',
			offset + 1));
	return ctxPath;
}
