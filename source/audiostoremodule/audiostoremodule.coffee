############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["audiostoremodule"]?  then console.log "[audiostoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
store = null
state = null
playlists = null

############################################################
audioDataCache = {}
allStorageObjects = null

############################################################
export initialize = ->
    log "audiostoremodule.initialize"
    store = allModules.storagemodule
    state = allModules.statemodule
    playlists = allModules.playlistsmodule

    allStorageObjects = state.load("allStorageObjects")
    state.setChangeDetectionFunction("allStorageObjects", () -> return true)

    if(!allStorageObjects?)
        allStorageObjects = [] 
        state.save("allStorageObjects", allStorageObjects, true)

    return
    
############################################################
export add = (blob) ->
    log "audiostoremodulle.add"
    olog blob
    log blob.toString()
    log blob.type
    try
        obj = await createStorageObject(blob)
        playlists.addToDefault(obj)
    catch err
        olog err.stack
    # log "TODO: create (and save) StorageObject"
    # data = await blob.arrayBuffer()
    # type = blob.type
    return 

export getAudioData = (storageObject) ->
    log "get audiodata from StorageObject with key: " + storageObject.key
    key = storageObject.key
    if !audioDataCache[key]?
        data = await store.get(key)
        audioDataCache[key] = new Blob([data], {type:storageObject.type})
    return audioDataCache[key]

export destroyAudioData = (storageObject) ->
    log "TODO: destroy StorageObject with key: " + storageObject.key

export saveAllStorageObject = -> state.save("allStorageObjects", allStorageObjects)

############################################################
createStorageObject = (blob) ->
    data = await blob.arrayBuffer()
    type = blob.type
    key = await store.save(data)
    log "retrieved key "+ key
    audioDataCache[key] = blob
    index = allStorageObjects.length
    title = "unnamed"
    timestamp = (new Date()).toISOString()
    creator = "me"

    obj = {key, type, index, title, timestamp, creator}
    allStorageObjects[index] = obj
    state.save("allStorageObjects", allStorageObjects)
    return obj

