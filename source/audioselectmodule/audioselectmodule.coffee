############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["audioselectmodule"]?  then console.log "[audioselectmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
audioStore = null

############################################################
export initialize = ->
    log "audioselectmodule.initialize"
    audioStore = allModules.audiostoremodule
    audioselectInput.addEventListener("change", audioselectInputChanged)    
    return

############################################################
digestFile = (file) ->
    # one = performance.now()

    # Version direct arrayBuffer - most performant
    # 
    # data = await file.arrayBuffer()
    # blob = new Blob([data], {type: file.type})
    # two = performance.now()
    # delta = two - one
    # log "performance delta was: "+delta

    # audioStore.add(blob)

    # Version DataURL by createObjectURL - close second
    #
    # dataURL = URL.createObjectURL(file)
    # blob = await (await fetch(dataURL)).blob()
    # two = performance.now()
    # delta = two - one
    # log "performance delta was: "+delta

    # audioStore.add(blob)
    
    # Version FileReader - super slow third
    #
    # reader = new FileReader()
    # reader.onload = (evt) ->
    #     blob = await (await fetch(evt.target.result)).blob()
    #     two = performance.now()
    #     delta = two - one
    #     log "performance delta was: "+delta

    #     audioStore.add(blob)
    # reader.readAsDataURL(file)
    return

############################################################
#region eventHandlers
audioselectInputChanged = ->
    log "audioselectInputChanged"
    audioStore.add(file) for file in audioselectInput.files
    return




#endregion