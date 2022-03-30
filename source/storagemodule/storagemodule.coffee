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
STORENAME = null

############################################################
dbConnection = null


############################################################
export initialize = ->
    log "storagemodule.initialize"
    c = allModules.configmodule
    dbName = c.dbName
    dbVersion = c.dbVersion
    STORENAME = c.dbStoreName

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
    request.onblocked = -> log('Blocked: Waiting for unblock...');
    return

doUpgrade = (evt) ->
    log "doUpgrade"
    oldVer = evt.oldVersion
    newVer = evt.newVersion
    log "upgrade from "+oldVer+" to "+newVer

    t  = evt.target.result
    t.createObjectStore(STORENAME, {keyPath: "_id", autoIncrement: true})
    return

############################################################
export save = (audioData) -> new Promise (res, rej) ->
    trx = dbConnection.transaction(STORENAME, "readwrite")
    trx.onerror = (evt) -> rej(evt)
    objStore = trx.objectStore(STORENAME)
    request = objStore.add(audioData)
    request.onsuccess = (evt) -> res(request.result)
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
    request = objStore.get(key)
    request.onsuccess = (evt) -> res(request.result)
    return