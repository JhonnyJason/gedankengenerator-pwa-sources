export name = "storagemodule"
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["storagemodule"]?  then console.log "[storagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
db = null

############################################################
dbName = null
dbVersion = null
STORENAME = "audioData"

############################################################
dbConnection = null



############################################################
export initialize = ->
    log "storagemodule.initialize"
    c = allModules.configmodule
    dbName = c.dbName
    dbVersion = c.dbVersion

    db = window.indexedDB
    if !db then log "no indexedDB found!"
    else 
        try 
            dbConnection = await createConnection()
            log "success!"
        catch err
            log "an error occured!" 
            olog err
            log err.message
    return


createConnection = -> new Promise (res, rej) ->
    request = db.open(dbName, dbVersion)
    request.onupgradeneeded = doUpgrade
    request.onsuccess = -> res(request.result)
    request.onerror = -> rej(request.error)
    request.onblocked = -> log('Waiting vor unblock!');
    return

doUpgrade = ->
    log "doUpgrade"
    log "well not yet^^"
    return

############################################################
export store = (audioData, key = null) -> new Promise (res, rej) ->
    trx = dbConnection.transaction(STORENAME, "readwrite")
    trx.onerror = (evt) -> rej(evt)
    objStore = trx.objectStore(STORENAME)
    request = objectStore.add(audioData)
    request.onsuccess = (evt) -> res(evt.result)
    return    

export remove = (key) -> new Promise (res, rej) ->
    trx = dbConnection.transaction(STORENAME, "readwrite")
    trx.onerror = (evt) -> rej(evt)
    objStore = trx.objectStore(STORENAME)
    request = objectStore.delete(key)
    request.onsuccess = -> res()
    return

export get = (key) -> new Promise (res, rej) ->
    trx = dbConnection.transaction(STORENAME)
    trx.onerror = (evt) -> rej(evt)
    objStore = trx.objectStore(STORENAME)
    request = objectStore.get(key)
    request.onsuccess = (evt) -> res(evt.result)
    return