indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.playlistEntryTemplate = document.getElementById("playlist-entry-template")
    global.playlists = document.getElementById("playlists")
    global.defaultPlaylist = document.getElementById("default-playlist")
    global.audiorecorder = document.getElementById("audiorecorder")
    global.controls = document.getElementById("controls")
    global.micbutton = document.getElementById("micbutton")
    global.recordButton = document.getElementById("record-button")
    global.stopRecordingButton = document.getElementById("stop-recording-button")
    global.audioselectInput = document.getElementById("audioselect-input")
    global.audioElement = document.getElementById("audio-element")
    global.messagebox = document.getElementById("messagebox")
    return
    
module.exports = indexdomconnect