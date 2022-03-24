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

############################################################
import lame from 'lamejs'

ctx = null
micRecorder = null

dataChunks = []

mic = null 
micGain = null
micFilter = null
micConvolver = null

startable = true
stoppable = false

############################################################
export initialize = ->
    log "audiorecordermodule.initialize"
    ctx = new window.AudioContext()
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
        # mic = ctx.createMediaStreamSource(stream)
        # mic.connect(micFilter)
        # micFilter.connect(micGain)
        # micConvolver.connect(micGain)
    catch err
        log('Error on getUserMedia: ' + err)
    return

export destroyMic = ->
    log "audiorecorder.destroyMic"
    log "TODO"
    return

onRecordingEnded = (evt) ->
    log "onRecordingEnded"
    audioBlob = new Blob(dataChunks);
    dataURL = URL.createObjectURL(audioBlob)
    hiddenAudioElement.src = dataURL

    stoppable = false
    startable = true

    # console.log("data available after MediaRecorder.stop() called.");

    # var clipName = prompt('Enter a name for your sound clip');

    # var clipContainer = document.createElement('article');
    # var clipLabel = document.createElement('p');
    # var audio = document.createElement('audio');
    # var deleteButton = document.createElement('button');

    # clipContainer.classList.add('clip');
    # audio.setAttribute('controls', '');
    # deleteButton.innerHTML = "Delete";
    # clipLabel.innerHTML = clipName;

    # clipContainer.appendChild(audio);
    # clipContainer.appendChild(clipLabel);
    # clipContainer.appendChild(deleteButton);
    # soundClips.appendChild(clipContainer);

    # audio.controls = true;
    # var blob = new Blob(chunks, { 'type' : 'audio/ogg; codecs=opus' });
    # chunks = [];
    # var audioURL = URL.createObjectURL(blob);
    # audio.src = audioURL;
    # console.log("recorder stopped");

    # deleteButton.onclick = function(e) {
    # evtTgt = e.target;
    # evtTgt.parentNode.parentNode.removeChild(evtTgt.parentNode);
    # } 

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
    dataChunks.length = 0
    micRecorder.start()

    # mediaRecorder.start();
    # console.log(mediaRecorder.state);
    # console.log("recorder started");
    # record.style.background = "red";
    # record.style.color = "black";

    # log "startRecording"
    # if toStop? 
    #     toStop()
    #     toStop = null
    #     return
    
    # toStop = true

    # options = 
    #     onEnded: saveBuffer 
    #     onError: handleError
    #     onRecordingStart: onRecordingStart 
    #     addNodes: null

    # audioCtx = micToBuffer(options);

    return

export stopRecording = ->
    log "audiorecordermodule.stopRecording"
    return unless stoppable
    stoppable = false
    startable = false
    micRecorder.stop()
    return

