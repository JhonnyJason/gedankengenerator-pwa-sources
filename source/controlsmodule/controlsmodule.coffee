export name = "controlsmodule"
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
    micbutton.addEventListener("click", micButtonClicked)
    #Implement or Remove :-)
    return

############################################################
recordButtonClicked = ->
    log "recordButtonClicked"
    audioRecord.stopRecording()
    audioRecord.startRecording()
    return
    
############################################################
micButtonClicked = ->
    log "micButtonClicked" 
    if micOn
        micbutton.classList.remove("on")
        audio.destroyMic()
        micOn = false
    else
        micbutton.classList.add("on")
        audioRecord.createMic()
        micOn = true
    return

export micToOff = ->
    log "controlsmodule.micToOff"
