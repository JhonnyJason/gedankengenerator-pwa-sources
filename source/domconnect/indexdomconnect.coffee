indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.recordButton = document.getElementById("record-button")
    global.audioselectInput = document.getElementById("audioselect-input")
    global.messagebox = document.getElementById("messagebox")
    return
    
module.exports = indexdomconnect