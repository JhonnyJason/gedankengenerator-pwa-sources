############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["controlsmodule"]?  then console.log "[controlsmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
micOn = false
audioRecord = null

############################################################
export initialize = ->
    log "controlsmodule.initialize"
    audioRecord = allModules.audiorecordermodule
    recordButton.addEventListener("click", recordButtonClicked)
    stopRecordingButton.addEventListener("click", stopRecordingButtonClicked)
    micbutton.addEventListener("click", micButtonClicked)
    #Implement or Remove :-)
    return

############################################################
recordButtonClicked = ->
    log "recordButtonClicked"
    audioRecord.startRecording()
    return

stopRecordingButtonClicked = ->
    log "stopRecordingButtonClicked"
    audioRecord.stopRecording()
    return



############################################################
micButtonClicked = ->
    log "micButtonClicked" 
    if micOn
        audioRecord.destroyMic()
    else
        audioRecord.createMic()
    return

############################################################
#region exposedFunctions
export micOff = ->
    log "controlsmodule.micToOff"
    micbutton.classList.remove("on")
    micOn = false
    return

export micOn = ->
    micbutton.classList.add("on")
    recordButton.classList.add("active")
    micOn = true
    return

export setStateRecording = ->
    log ".setStateRecording"
    stopRecordingButton.classList.add("active")
    recordButton.classList.add("recording")
    return

export unsetStateRecording = ->
    log "unsetStateRecording"
    stopRecordingButton.classList.remove("active")
    recordButton.classList.remove("recording")
    return

#endregion