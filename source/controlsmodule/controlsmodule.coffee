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
export initialize = ->
    log "controlsmodule.initialize"
    #Implement or Remove :-)
    return
    
