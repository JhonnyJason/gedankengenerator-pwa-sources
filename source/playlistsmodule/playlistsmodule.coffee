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
focusedTitleField = null
oldContent = null

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

    # reader = new FileReader()
    # onload = (evt) -> 
    #     olog reader.result
    #     audioElement.src = reader.result
    # reader.addEventListener("load", onload)
    # reader.readAsDataURL(data)

    olog data.arrayBuffer().length
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
    # entries = defaultPlaylist.getElementsByClassName("playlist-entry")
    # el.addEventListener("click", entryClicked) for el in entries
    playButtons = defaultPlaylist.getElementsByClassName("playlist-entry-play-button")
    el.addEventListener("click", playButtonClicked) for el in playButtons
    editButtons = defaultPlaylist.getElementsByClassName("playlist-entry-edit-button")
    el.addEventListener("click", editButtonClicked) for el in editButtons
    titleFields = defaultPlaylist.getElementsByClassName("playlist-entry-title")
    for el in titleFields
        el.addEventListener("focus", titleFieldClicked)

    return

createEntryHTML = (storageObject,index, playlistName) ->
    log "createEntryHTML"
    cObj = 
        index: index
        title: storageObject.title
        playlistName: playlistName

    return M.render(entryTemplate, cObj)

############################################################
blurOutTitleField = ->
    return unless focusedTitleField?
    focusedTitleField.blur()
    focusedTitleField = null
    return

saveNewTitle = (title) ->
    log "saveNewTitle"
    entry = focusedTitleField.parentNode
    index = entry.getAttribute("playlist-index")
    playlistName = entry.getAttribute("playlist-name")
    pl = playlists[nameToIndex[playlistName]]
    storageObject = pl[index].storageObject
    olog storageObject
    storageObject.title = title
    audioStore.save()
    olog storageObject
    return


############################################################
titleFieldType = (evt) ->
    log "titleFieldType"
    if(evt.key == "Escape")
        log "typed Escape"
        evt.target.textContent = oldContent
        blurOutTitleField()
        return
    if(evt.key == "Enter")
        log "typed Enter"
        blurOutTitleField()
        return
    return

titleFieldBlurred = (evt) ->
    log "titleFieldBlurred"
    newContent = evt.target.innerText
    log ""+newContent
    if newContent != oldContent then saveNewTitle(newContent)
    #remove the event Listeners again
    evt.target.removeEventListener("keydown", titleFieldType)
    evt.target.removeEventListener("blur", titleFieldBlurred)
    return

titleFieldClicked = (evt) ->
    log "titleFieldClicked"
    target = evt.target
    if target != focusedTitleField then blurOutTitleField()
    
    focusedTitleField = target
    oldContent = target.innerText
    #Add the event listeners
    target.addEventListener("keydown", titleFieldType)
    target.addEventListener("blur", titleFieldBlurred)
    return

editButtonClicked = (evt) ->
    log "editButtonClicked"
    entry = evt.currentTarget.parentNode
    index = entry.getAttribute("playlist-index")
    playlistName = entry.getAttribute("playlist-name")
    log "index was: " + index
    log "playlist name was: " + playlistName

    # pl = playlists[nameToIndex[playlistName]]
    # storageObject = pl[index].storageObject
    # setForPlaying(storageObject)
    # audioElement.play()
    return

playButtonClicked = (evt) ->
    log "playButtonClicked"
    entry = evt.currentTarget.parentNode
    index = entry.getAttribute("playlist-index")
    playlistName = entry.getAttribute("playlist-name")
    log "index was: " + index
    log "playlist name was: " + playlistName

    pl = playlists[nameToIndex[playlistName]]
    storageObject = pl[index].storageObject
    setForPlaying(storageObject)
    audioElement.play()
    return


entryClicked = (evt) ->
    log "entryClicked"
    return
    target = evt.currentTarget 
    index = target.getAttribute("playlist-index")
    playlistName = target.getAttribute("playlist-name")
    log "index was: " + index
    log "playlist name was: " + playlistName

    pl = playlists[nameToIndex[playlistName]]
    storageObject = pl[index].storageObject
    setForPlaying(storageObject)
    audioElement.play()
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