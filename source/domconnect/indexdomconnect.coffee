indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.audiorecorder = document.getElementById("audiorecorder")
    global.recordButton = document.getElementById("record-button")
    global.audioselectInput = document.getElementById("audioselect-input")
    global.hiddenAudioElement = document.getElementById("hidden-audio-element")
    global.messagebox = document.getElementById("messagebox")
    return
    
module.exports = indexdomconnect