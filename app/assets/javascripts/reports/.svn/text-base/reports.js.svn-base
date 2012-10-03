var month, year, period, report;
report = "cons";

$(document).ready(function(){
	data = $("#time_data").data();
	month  = data["month"];
	year   = data["year"];
	period = data["period"];

	
	$("#period-one-button").click(function() {
		period = 1;
	});
	$("#period-two-button").click(function() {
		period = 2;
	});
	$("#month-select").change(function() {
		month = parseInt($("#month-select").attr('value'));
	});
	$("#year-select").change(function() {
		year = parseInt($("#year-select").attr("vaue"));
	});
	
	$("#cons-button").click(function() {
		goToNewPage(month, year, period, "consultant", $("#cons-select").attr('value'));
	});
	$("#clients-button").click(function() {
		goToNewPage(month, year, period, "client", $("#clients-select").attr('value'));
	});
	
	selectMonth();
	selectYear();
	selectPeriod();
});


function selectMonth() {
	$('#month-select option:eq(' + (month-1) + ')').attr('selected', 'selected');
}
function selectYear() {
	$('#year-select option:eq(' + (year - 2012) + ')').attr('selected', 'selected');
}
function selectPeriod() {
	if (period == 1) {
		$("#period-one-button").addClass("active")
		$("#period-two-button").removeClass("active")
	} else if (period == 2) {
		$("#period-two-button").addClass("active")
		$("#period-one-button").removeClass("active")
	}
}


function goToNewPage(month, year, period, report, id) {
	window.location.href = '/reports/' + [report, id, month, year, period].join('/');
}