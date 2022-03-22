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

############################################################
export initialize = ->
    log "audioselectmodule.initialize"
    #Implement or Remove :-)
    audioselectInput.addEventListener("change", audioselectInputChanged)

    return
    
#
############################################################
source = null

############################################################
currentMode = "image"

############################################################
imageselectmodule.initialize = () ->
    log "imageselectmodule.initialize"
    source = allModules.sourceimagemodule
    
    #region addEventListeners
    imageselectInput.addEventListener("change", imageselectInputChanged)
    #endregion
    return

############################################################
#region eventHandlers
imageselectInputChanged = ->
    log "imageselectInputChanged"
    file = imageselectInput.files[0]
    if file then source.setAsSourceFile(file)
    return

captureButtonClicked = ->
    log "captureIconClicked"
    source.captureCamImage()
    return

resumeButtonClicked = ->
    log "captureIconClicked"
    source.resumeVideo()
    return
#endregion




