export name = "playlistsmodule"
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
playlists = null
playlistNames = null
state = null

############################################################
export initialize = ->
    log "playlistsmodule.initialize"
    state = allModules.statemodule
    playlists = state.load("playlists")
    playlistNames = state.load("playlistNames")
    # olog playlists
    # olog playlistNames
    if !playlists? 
        playlists = [[]]
        playlistNames = ["default"]
        state.set("playlists", playlists)
        state.set("playlistNames", playlistNames)
        state.saveAll()
    # olog playlists
    # olog playlistNames
    return


    
