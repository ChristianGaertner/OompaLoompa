# Description:
#   Simple sed command for fixing typos.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   s/PATTERN/REPLACEMENT

sedRegex = new RegExp("s(ed)?/([\\w ]+)/([\\w ]+)", "i")
lastMsg = new Object()

module.exports = (robot) ->
  robot.hear /.*/i, (msg) ->
    name = msg.message.user.name
    text = msg.message.text
    res = sedRegex.exec(text)
    if res != null
      search = res[2]
      replace = res[3]
      if lastMsg[name] != undefined
        oldMsg = lastMsg[name]
        newMsg = oldMsg.replace(search, replace)
        if oldMsg.indexOf(search) > -1
          msg.reply newMsg
          delete lastMsg[name]
    else
      # set last message
      lastMsg[name] = text
