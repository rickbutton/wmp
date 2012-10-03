var pTable;

var data, month, year, period, readOnly;

var colOffset = 4;
var TEST;
$(document).ready(function(){
	data = $("#time_data").data();
	month  = data["month"];
	year   = data["year"];
	period = data["period"];
	readOnly = data["readonly"];
	numDays = data["numdays"];
	clientHash = data["clients"];	
	
	var editOptions;
	if (!readOnly) {
		editOptions = [null, null, null];
		var end = period == 1 ? 15 : new Date(year, month, 0).getDate() - 15;
		for (var i = 0; i < end; i++)
			editOptions.push({type: 'text'});
	} else {
		editOptions = [
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null
		]
	}
	
	pTable = $("#payperiod").dataTable({
		"sWrapper": "form-inline",
		"bPaginate": false,
		"bSort": false,
		"bInfo": false,
		"bFilter": false,
		"fnRowCallback": function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
			var colOffset = 4;
			var rowTotal = 0;
			for (var col = colOffset; col < aData.length - 2; col++) {
				rowTotal += parseInt(aData[col]);
			}
				
				
			client = $("td", nRow)[0];
			if (client.innerHTML.split(":")[0] != "AC") {
				$(client).popover({placement: 'top', trigger: 'hover', title: 'Client', content: client.innerHTML.split(":")[1]});	
				client.innerHTML = client.innerHTML.split(":")[0];
			} else {
				client.innerHTML = "";
			}
				
				
			project = $("td", nRow)[1];
			if (project.innerHTML != "ADMIN_PROJECT") {
				$(project).popover({placement: 'top', trigger: 'hover', title: 'Project', content: project.innerHTML});
				if (project.innerHTML.length >9) {
				 project.innerHTML = project.innerHTML.substring(0,9) + "...";
				}
			}
			
			task = $("td", nRow)[2];
			$(task).popover({placement: 'top', trigger: 'hover', title: 'Task', content: task.innerHTML});
			
			if (task.innerHTML.length >15) {
			 task.innerHTML = task.innerHTML.substring(0,15) + "...";
			}
			
			
			if ($("td", nRow)[1].innerHTML == "ADMIN_PROJECT")
				$("td", nRow)[1].innerHTML = "";
			
			$('td:eq(-1)', nRow).html(rowTotal);
			var colTotals = calculateColTotals(pTable.fnGetData());
			
			$('td:lt(3)', nRow).attr('nowrap','nowrap');

		},
		"fnFooterCallback": function(nRow, aaData, iStart, iEnd, aiDisplay) {
			var colTotals = calculateColTotals(aaData);
			var allTotal = 0;
			for (var i = 0; i < colTotals.length; i++)
				allTotal += colTotals[i];
			
		  var footCells = nRow.getElementsByTagName('th');
		
		  for (var i = 0; i < colTotals.length; i++) {
				footCells[i + 1].innerHTML = colTotals[i];
		  }	
		  var table = document.getElementById("payperiod");

		  var lastRow = table.rows[table.rows.length - 1];
		  var lastCell = lastRow.cells[lastRow.cells.length - 1];
		  lastCell.innerHTML = allTotal;
		
			updateFooterHighlights(colTotals);
		  
		},
		"bProcessing": true,
		"sAjaxSource": '/payperiod/' + [month, year, period].join('/') + '/time_records.json',
		"aoColumnDefs": [
		{ "bVisible":    false, "aTargets": [0]}
		]
	}).makeEditable({
		"aoColumns": editOptions,
		sUpdateURL: function(value, settings) {
			var cell = $("td form").parent();
		  var col = $(cell).parent().children().index($(cell));
			var row = $(cell).parent().parent().children().index($(cell).parent());
			
			if (col < 3) {
				//this probably shouldnt happen
			} else if (col < 18) {
				//is a time record
				var d = $("#payperiod tr:eq(0)").children()[col].innerHTML;
				var taskId = pTable.fnGetData(row)[0];
				
				console.log("updated cell " + (col-4) + ":" + row + " which is day " + d + " with value " + value + " and task id " + taskId);
				$.post('/payperiod/' + [month, year, period].join('/') + '/time_records', { day: d, task_id: taskId, hours: value }, function(data) {
					console.log(data);
				});
			}
			
			
			return value;
		},
		fnOnEditing: function(input) {
			var hours = input.val();
			var cellError = hours + " is not a number between 0 and 24";
			var totalError = "You cannot work more than 24 hours in one day";
			
			if (!isNumber(hours)) {
				alert(cellError);
				return false;
			}
			hours = parseInt(hours);
			
			if (hours < 0 || hours > 24) {
				alert(cellError);
				return false;
			}
		
			var col = $(input).parent().parent().parent().children().index($(input).parent().parent()) - colOffset + 1;
			var row = $(input).parent().parent().parent().parent().children().index($(input).parent().parent().parent());
			
			var colVals = getColVals(col);
			colVals[row] = hours;
			var total = 0;
			for (var i = 0; i < colVals.length; i++)
				total += colVals[i];
			if (total > 24) {
				alert(totalError);
				return false;
			}
			
			return true;
		}
	});
	
	$("#period-one-button").click(function() {
		goToNewPage(month, year, 1);
	});
	$("#period-two-button").click(function() {
		goToNewPage(month, year, 2);
	});
	$("#year-select").change(function() {
		year = parseInt($("#year-select").attr('value'));
		goToNewPage(month, year, period);
	});
	$("#month-select").change(function() {
		month = parseInt($("#month-select").attr('value'));
		goToNewPage(month, year, period);
	});
	
	$("#client-select").change(function() {
		updateProjectSelect();
	});
	updateProjectSelect();
	
	$("#add-project-submit").click(function() {
		id = $("#project-select").attr('value');
		console.log(id);
		$.post('/projects/users/' + id, function(data) {
			$("#add-project-modal").modal('hide');
			window.location.reload();
		});
	});
	//tabbing between cells for the future
    /*$('.ned, .ted').keydown(function(e) {
	  var keyCode = e.keyCode || e.which;
	  arrow = { left: 37, up: 38, right: 39, down: 40 };
	  switch(keyCode) {
		
	  }
	});*/
	
	selectMonth();
	selectYear();

});


function selectMonth() {
	$('#month-select option:eq(' + (month-1) + ')').attr('selected', 'selected');
}
function selectYear() {
	$('#year-select option:eq(' + (year-2012) + ')').attr('selected', 'selected');
}

function goToNewPage(month, year, period) {
	window.location.href = '/payperiod/' + [month, year, period].join('/');
}

function updateProjectSelect() {
	if ($("#client-select").children().length != 0) {
		$("#project-select").empty();
		id = $("#client-select").attr('value');
		for (var i = 0; i < clientHash[id].projects.length; i++)
			$("#project-select").append('<option value="' + clientHash[id].projects[i].id + '">' + clientHash[id].projects[i].name +"</option>");
		
	}
}

function updateFooterHighlights(colTotals) {
	//check colTotals
	for (var i = 0; i < colTotals.length; i++) {
		var day_in_week = new Date(year, month - 1, parseInt($("#payperiod thead th:eq(" + (colOffset + i - 1) + ")").html())).getDay();
		if (colTotals[i] < 8 && day_in_week > 0 && day_in_week < 6) {
			$("#payperiod tfoot tr th:eq(" + (i + colOffset - 3) + ")").addClass('error')
		} else {
			$("#payperiod tfoot tr th:eq(" + (i + colOffset - 3) + ")").removeClass('error');
		}
	}
}

function calculateColTotals(aaData) {
	var colTotals = [];
	for (var row = 0; row < aaData.length; row++)
	  for(var col = colOffset; col < aaData[row].length - 2; col++) {
			if (colTotals[col - colOffset] == undefined)
			  colTotals[col - colOffset] = 0;
			colTotals[col - colOffset] += parseInt(aaData[row][col]);
	}
	return colTotals;
}

function getColVals(col) {
	var colVals = [];
	var aaData = pTable.fnGetData();
	for (var row = 0; row < aaData.length; row++)
		colVals[row] = parseInt(aaData[row][col + colOffset]);
		
	return colVals;
}

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}