export name = "audiorecordermodule"
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["audiorecordermodule"]?  then console.log "[audiorecordermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

import micToBuffer from 'mic-to-buffer'

audioCtx = null

toStop = null

############################################################
export initialize = ->
    log "audiorecordermodule.initialize"
    
    return
############################################################
saveBuffer = (audioBuffer) ->
    log "saveBuffer"
    olog audioBuffer
    blob = new Blob([toWav(audioBuffer)]);
    return

handleError = (error) ->
    olog error
    return

onRecordingStart = (stopFun) ->
    toStop = stopFun
    return


############################################################
export startRecording = ->
    log "startRecording"
    if toStop? 
        toStop()
        toStop = null
        return
    
    toStop = true

    options = 
        onEnded: saveBuffer 
        onError: handleError
        onRecordingStart: onRecordingStart 
        addNodes: null

    audioCtx = micToBuffer(options);

    return