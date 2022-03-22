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

############################################################
export initialize = ->
    log "audiorecordermodule.initialize"
    
    return
    
