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
import M from "mustache"

############################################################
state = null
audioStore = null

############################################################
playlists = null
playlistNames = null
nameToIndex = null

############################################################
entryTemplate = null

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
    
    entryTemplate = playlistEntryTemplate.innerHTML
    renderPlaylist(0)
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
    log dataURL
    audioElement.src = dataURL
    return

############################################################
renderPlaylist = (idx) ->
    log "renderPlaylist"
    pl = playlists[idx]
    name = playlistNames[idx]
    return unless pl?
    html = ""
    for el,i in pl
        html += createEntryHTML(el.storageObject, i, name)
    defaultPlaylist.innerHTML = html
    entries = defaultPlaylist.getElementsByClassName("playlist-entry")
    entry.addEventListener("click", entryClicked) for entry in entries
    return

createEntryHTML = (storageObject,index, playlistName) ->
    log "createEntryHTML"
    cObj = 
        index: index
        title: storageObject.title
        playlistName: playlistName

    return M.render(entryTemplate, cObj)

############################################################
entryClicked = (evt) ->
    log "entryClicked"
    target = evt.currentTarget 
    index = target.getAttribute("playlist-index")
    playlistName = target.getAttribute("playlist-name")
    log "index was: " + index
    log "playlist name was: " + playlistName

    pl = playlists[nameToIndex[playlistName]]
    storageObject = pl[index].storageObject
    setForPlaying(storageObject)
    return

#endregion


############################################################
#region exposedFunctions
export addToDefault = (storageObject) ->
    log "playlistmodule.addToDefault"
    addToPlaylistByIndex(0, storageObject)
    setForPlaying(storageObject)
    ## TODO restructure this line
    renderPlaylist(0)
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