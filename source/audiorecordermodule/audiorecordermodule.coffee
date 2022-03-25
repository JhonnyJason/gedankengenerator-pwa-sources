############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["audiorecordermodule"]?  then console.log "[audiorecordermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
# import lame from 'lamejs'
audioStore = null
controls = null
state = null

############################################################
ctx = null
micRecorder = null

dataChunks = []

############################################################
startable = true
stoppable = false

############################################################
export initialize = ->
    log "audiorecordermodule.initialize"
    audioStore = allModules.audiostoremodule
    controls = allModules.controlsmodule
    state = allModules.statemodule
    
    ctx = new window.AudioContext()

    micIsAllowed = state.get("micIsAllowed")
    if micIsAllowed? then createMic()
    return

############################################################
export createMic = ->
    log "audiorecordermodule.createMic"
    options = 
        audioBitsPerSecond:128000
        mimeType:'audio/webm'

    micGain = ctx.createGain()
    micFilter = ctx.createBiquadFilter()
    # micConvolver = ctx.createConvolver()

    constraints = {audio: true}
    try
        stream = await navigator.mediaDevices.getUserMedia(constraints)
        micRecorder = new MediaRecorder(stream, options)
        micRecorder.ondataavailable = onMicData
        micRecorder.onstop = onRecordingEnded
        state.save("micIsAllowed", true)
        controls.micOn()
    catch err
        log('Error on getUserMedia: ' + err)
        state.save("micIsAllowed", false)
        controls.micOff()
    return

export destroyMic = ->
    log "audiorecorder.destroyMic"
    log "TODO: remove microphone stream."
    return

onRecordingEnded = (evt) ->
    log "onRecordingEnded"
    audioBlob = new Blob(dataChunks, {type: micRecorder.mimeType});
    audioStore.add(audioBlob)

    stoppable = false
    startable = true
    return

onMicData = (evt) ->
    log "onMicData"
    dataChunks.push(evt.data)
    return


############################################################
export startRecording = ->
    log "audiorecordermodule.startRecording"
    return unless startable
    startable = false
    stoppable = true
    dataChunks = []
    micRecorder.start()
    controls.setStateRecording()
    return

export stopRecording = ->
    log "audiorecordermodule.stopRecording"
    return unless stoppable
    stoppable = false
    startable = false
    micRecorder.stop()
    controls.unsetStateRecording()
    return

