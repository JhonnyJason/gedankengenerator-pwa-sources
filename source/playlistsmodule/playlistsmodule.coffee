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
    playlists = state.get("playlists")
    playlistNames = state.get("playlistNames")
    # olog playlists
    # olog playlistNames
    if !playlists? 
        playlists = [[]]
        playlistNames = ["default"]
        state.save("playlists", playlists)
        state.save("playlistNames", playlistNames)
    # olog playlists
    # olog playlistNames
    return


    
