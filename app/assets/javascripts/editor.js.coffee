initBrowserWarning = ->
  isChrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1
  isFirefox = navigator.userAgent.toLowerCase().indexOf("firefox") > -1
  $("#browser-warning").fadeIn 125  if not isChrome and not isFirefox

initDnD = ->
  $("html").bind "dragenter", onDragEnter
  document.getElementById("drop-box-overlay").addEventListener "dragleave", onDragLeave, false
  document.getElementById("drop-box-overlay").addEventListener "dragover", noopHandler, false
  document.getElementById("drop-box-overlay").addEventListener "drop", onDrop, false

initEditor = ->
noopHandler = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()

onDragEnter = (evt) ->
  $("#drop-box-overlay").show()
  $("#drop-box-prompt").show()
  false

onDragLeave = (evt) ->
  $("#drop-box-overlay").fadeOut 125
  $("#drop-box-prompt").fadeOut 125

onDrop = (evt) ->
  noopHandler evt
  $("#drop-box-overlay").fadeOut 0
  $("#drop-box-prompt").fadeOut 0
  files = evt.dataTransfer.files
  return  if typeof files == "undefined" or files.length == 0
  uploadFile files[0], length
  $("#upload-status-text").html files[0].name

uploadFile = (file, totalFiles) ->
  reader = new FileReader()
  reader.onerror = (evt) ->
    switch evt.target.error.code
      when 1
        message = file.name + " not found."
      when 2
        message = file.name + " has changed on disk, please re-try."
      when 3
        messsage = "Upload cancelled."
      when 4
        message = "Cannot read " + file.name + "."
      when 5
        message = "File too large for browser to upload."
    $("#upload-status-text").html message
  
  reader.onloadend = (evt) ->
    data = evt.currentTarget.result
    buffer = $("#fileBuffer")
    buffer.attr "value", data
  
  reader.readAsText file

$(document).ready ->
  initBrowserWarning()
  initDnD()
  initEditor()
