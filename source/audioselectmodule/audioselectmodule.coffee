export name = "audioselectmodule"
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["audioselectmodule"]?  then console.log "[audioselectmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

# hiddenAudioElement = null
state = null

############################################################
export initialize = ->
    log "audioselectmodule.initialize"
    #Implement or Remove :-)
    state = allModules.statemodule
    audioselectInput.addEventListener("change", audioselectInputChanged)

    # dataURL = state.load("dataURL")
    # if dataURL then hiddenAudioElement.src = dataURL
    # olog dataURL
    
    return

############################################################
#region eventHandlers
audioselectInputChanged = ->
    log "audioselectInputChanged"
    file = audioselectInput.files[0]
    reader = new FileReader()
    reader.onload = (evt)->
        state.save("audioDataURLFile", evt.target.result, true)
    # dataURL = URL.createObjectURL(file)
    reader.readAsDataURL(file)

    # dataURL = URL.createObjectURL(file)
    # if dataURL then hiddenAudioElement.src = dataURL
    # olog dataURL
    # state.save("dataURL", dataURL)
    return




#endregion