$(document).ready(function() {
	initBrowserWarning();
	initDnD();
  initEditor();
});

function initBrowserWarning() {
	var isChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
	var isFirefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1;
	
	if(!isChrome && !isFirefox)
		$("#browser-warning").fadeIn(125);
}

function initDnD() {
	// Add drag handling to target elements
	$("html").bind("dragenter", onDragEnter);
	document.getElementById("drop-box-overlay").addEventListener("dragleave", onDragLeave, false);
	document.getElementById("drop-box-overlay").addEventListener("dragover", noopHandler, false);
	
	// Add drop handling
	document.getElementById("drop-box-overlay").addEventListener("drop", onDrop, false);
}

function initEditor() {
}

function noopHandler(evt) {
	evt.stopPropagation();
	evt.preventDefault();
}

function onDragEnter(evt) {
	$("#drop-box-overlay").show();
	$("#drop-box-prompt").show();
	return false;
}

function onDragLeave(evt) {
  $("#drop-box-overlay").fadeOut(125);
  $("#drop-box-prompt").fadeOut(125);
}

function onDrop(evt) {
	// Consume the event.
	noopHandler(evt);
	
	// Hide overlay
	$("#drop-box-overlay").fadeOut(0);
	$("#drop-box-prompt").fadeOut(0);
	
	// Get the dropped files.
	var files = evt.dataTransfer.files;
	
	// If anything is wrong with the dropped files, exit.
	if(typeof files == "undefined" || files.length == 0)
		return;
	
	// Process each of the dropped files individually
	//for(var i = 0, length = files.length; i < length; i++) {
		uploadFile(files[0], length);
	//}
}

function uploadFile(file, totalFiles) {
	var reader = new FileReader();
	
	// Handle errors that might occur while reading the file (before upload).
	reader.onerror = function(evt) {
		var message;
		
		// REF: http://www.w3.org/TR/FileAPI/#ErrorDescriptions
		switch(evt.target.error.code) {
			case 1:
				message = file.name + " not found.";
				break;
				
			case 2:
				message = file.name + " has changed on disk, please re-try.";
				break;
				
			case 3:
				messsage = "Upload cancelled.";
				break;
				
			case 4:
				message = "Cannot read " + file.name + ".";
				break;
				
			case 5:
				message = "File too large for browser to upload.";
				break;
		}
		
		$("#upload-status-text").html(message);
	}
	
	// When the file is done loading, POST to the server.
	reader.onloadend = function(evt){
		var data = evt.currentTarget.result;
		var buffer = $("#fileBuffer");
		buffer.attr("value", data);
    //SyntaxHighlighter.all();
	};

	// Start reading the image off disk into a Data URI format.
	reader.readAsText(file);
}

