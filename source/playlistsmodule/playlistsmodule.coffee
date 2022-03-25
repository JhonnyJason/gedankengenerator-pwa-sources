############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["playlistsmodule"]?  then console.log "[playlistsmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = null
audioStore = null

############################################################
playlists = null
playlistNames = null
nameToIndex = null

############################################################
export initialize = ->
    log "playlistsmodule.initialize"
    state = allModules.statemodule
    audioStore = allModules.audiostoremodule

    playlists = state.get("playlists")
    state.setChangeDetectionFunction("playlists", () -> return true)
    playlistNames = state.get("playlistNames")
    state.setChangeDetectionFunction("playlistNames", () -> return true)
    nameToIndex = {}
    nameToIndex[name] = idx for name,idx in playlistNames
    # olog nameToIndex
    addAllStorageObjectsToDefault()
    return

############################################################
#region internalFunctions
addAllStorageObjectsToDefault = ->
    log "addAllToDefault"
    allStorageObjects = state.load("allStorageObjects")
    # olog allStorageObjects
    return unless allStorageObjects? and allStorageObjects.length
    
    for obj in allStorageObjects when isNotInDefault(obj)
        addToDefault(obj)
    state.saveRegularState()
    return

isNotInDefault = (obj) ->
    pl = playlists[0]
    for el in pl when el.storageObject.index == obj.index then return false
    return true


############################################################
addToPlaylistByIndex = (idx, storageObject) ->
    log "addToPlaylistByIndex"
    el = {storageObject}
    olog storageObject
    playlists[idx].push(el)
    state.save("playlists", playlists)
    return

removeFromPlaylistByIndex = (idx, storageObject) ->
    log "removeFromPlaylist"
    plOld = playlists[idx]
    playlists[idx] = plOld.filter((el) -> el.storageObject != storageObject)
    state.saveRegularState()
    return

############################################################
setForPlaying = (storageObject) ->
    log "setForPlaying"
    olog storageObject
    data = await audioStore.getAudioData(storageObject)
    dataURL = URL.createObjectURL(data)
    audioElement.src = dataURL
    return

#endregion

############################################################
#region exposedFunctions
export addToDefault = (storageObject) ->
    log "playlistmodule.addToDefault"
    addToPlaylistByIndex(0, storageObject)
    setForPlaying(storageObject)
    return

export addToPlaylist = (name, storageObject) ->
    log "playlistsmodule.addToPlaylist"
    idx = nameToIndex[name]
    addToPlaylistByIndex(idx, storageObject)
    return

export removeFromPlaylist = (name, storageObject) ->
    log "playlistmodule.removeFromPlaylist"
    idx = nameToIndex[name]
    removeFromPlaylistByIndex(idx, storageObject)
    return

#endregion