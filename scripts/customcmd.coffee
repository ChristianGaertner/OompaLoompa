# Description:
#   Allows to register commands on the fly
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   cmd add <name>=><link|searchterm> - Adds a command. If the name starts with R: you can use regex!
#   cmd del "<name>" - Deletes a command
#   cmd show - Lists all commands
#   cmd show <name> - Show content of command

acl = ['Chrisliebaer', 'Benni1000', 'Cabraca', 'DaGardner', 'zh32']


cache = {}

module.exports = (robot) ->

  robot.respond /cmd add (.*)=>(.*)/i, (msg) ->    
    if msg.message.user.name not in acl
      return msg.send "Du hast nicht die nötigen Rechte um diesen Befehl auszuführen!"
    


    name = msg.match[1].trim()
    content = msg.match[2].trim()

    if name.length <= 2
      return msg.send "Name muss mehr als 2 Zeichen haben"

    if content.length <= 2
      return msg.send "Suchwort muss mehr als 2 Zeichen haben"


    # Get all cmds
    cmds = getCmds(robot)

    escape = true

    if name.indexOf('R:') == 0
      name = name.substring 2, name.length
      escape = false
    

    if cmds.hasOwnProperty name
      return msg.send "Dieser Befehl existiert bereits. Lösche zunächst den alten!"


    ename = name

    # Escape Regex
    if escape
      ename = name.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&")
    

    cmds[name] = ['^' + ename + '$', 'i', content, msg.message.user.name]

    msg.send "Befehl '#{name}' erfolgreich hinzugefügt!"




  robot.respond /cmd del "(.*)"/i, (msg) ->
    if msg.message.user.name not in acl
      return msg.send "Du hast nicht die nötigen Rechte um diesen Befehl auszuführen!"

    cmds = getCmds(robot)

    name = msg.match[1]

    if cmds.hasOwnProperty name
      delete cmds[name]
      setCmds(cmds, robot)
      msg.send "Befehl erfolgreich gelöscht! Bye Bye #{name}... o/"
    else
      msg.send "Diesen Befehl kannte ich eh nicht... Alles chillo millo!"


  robot.respond /cmd show$/i, (msg) ->
    cmds = getCmds(robot)

    values = []
    for key of cmds
      console.log 'pushing: ', cmds[key][0]
      values.push cmds[key][0].substr(1).substr(0, cmds[key][0].length - 2)
    

    msg.send "Ich kenne zur Zeit die folgenden User erstellten Befehle:"
    msg.send values.join ','


  robot.respond /cmd show (.*)/i, (msg) ->
    cmds = getCmds(robot)

    name = msg.match[1].trim()

    if cmds[name] != null
      content = cmds[name][2]
      user = cmds[name][3]
      if isUrl content
        type = "URL"
      else
        type = 'Google Suche'
      
      msg.send "Befehl Name: #{name}"
      msg.send "Befehl (#{type}): #{content}"
      msg.send "Erstellt von: #{user}"
    else
      msg.send "Diesen Befehl kenn ich nicht..."



  #####DynamicListener
  robot.hear /(.*)/i, (msg) ->
    cmds = getCmds(robot)

    for key of cmds
      cmd = cmds[key]
      if cmds.hasOwnProperty(key)
        regex = new RegExp(cmd[0], cmd[1])

        if regex.test(msg.match[0])
          handleMatch cmd[2], msg
          console.log "DEBUG Custom CMD match for " + cmd[2]
  #####Dynamic Listener
      


handleMatch = (content, msg) ->

  if isUrl content
    return msg.send content

  if content of cache
    console.log "DEBUG Custom CMD using cache for #{content}"
    msg.send cache[content]
    return

  google msg, content, (url) ->
      cache[content] = url
      msg.send url


getCmds = (robot) ->
  cmds = robot.brain.get 'ccmds'

  if cmds == null
    robot.brain.set 'ccmds', {}
    cmds = {}

  return cmds

setCmds = (cmds, robot) ->
  robot.brain.set 'ccmds', cmds
    


google = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  googleCseId = process.env.HUBOT_GOOGLE_CSE_ID
  if googleCseId
    console.log "DEBUG Custom CMD CSE IS BEING USED"
    # Using Google Custom Search API
    googleApiKey = process.env.HUBOT_GOOGLE_CSE_KEY
    if !googleApiKey
      msg.robot.logger.error "Missing environment variable HUBOT_GOOGLE_CSE_KEY"
      msg.send "img search is not configured"
      return
    q =
      q: query,
      searchType:'image',
      safe: process.env.HUBOT_GOOGLE_SAFE_SEARCH || 'high',
      fields:'items(link)',
      cx: googleCseId,
      key: googleApiKey
    if animated is true
      q.fileType = 'gif'
      q.hq = 'animated'
      q.tbs = 'itp:animated'
    if faces is true
      q.imgType = 'face'
    url = 'https://www.googleapis.com/customsearch/v1'
    msg.http(url)
      .query(q)
      .get() (err, res, body) ->
        if err
          if res.statusCode is 403
            msg.send "Daily image quota exceeded, try again later."
          else
            msg.send "Encountered an error :( #{err}"
          return
        if res.statusCode isnt 200
          msg.send "Bad HTTP response :( #{res.statusCode}"
          return
        response = JSON.parse(body)
        if response?.items
          image = msg.random response.items
          cb image.link
        else
          msg.send "Oops. I had trouble searching '#{query}'. Try later."
          ((error) ->
            msg.robot.logger.error error.message
            msg.robot.logger
              .error "(see #{error.extendedHelp})" if error.extendedHelp
          ) error for error in response.error.errors if response.error?.errors
  else
    msg.send "Cannot search for images right now"

isUrl = (string) ->
  return string.indexOf('http') == 0