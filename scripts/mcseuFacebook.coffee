# Description:
#   Minecraft-Server.eu Facebook-Feed streamer
#
# Dependencies:
#   moment
#
# Configuration:
#   None
#
# Commands:
#   hubot fb latest - Zeigt den neusten Beitrag an
#   hubot fb notify - Aktiviert die Down/Uptime Benachrichtungen
#   hubot fb notify disable- Deaktiviert die Down/Uptime Benachrichtungen

moment = require 'moment'

api = {
    url: 'https://graph.facebook.com/minecraft-server.eu/posts?fields=id,message&access_token=',
    key: process.env.FB_API_KEY
}
module.exports = (robot) ->

  notifyer = null
  last_id = -1

#########
  robot.respond /fb notify$/i, (msg) ->

    if notifyer
      return msg.send "Die automatische Benachrichtung ist bereits aktiviert!"
    else
      msg.send 'Die automatische Benachrichtung wurde aktiviert!'

    notifyer = setInterval () ->
      getFeed robot, msg, (err, feed, msg) ->
        if err
          return
        
        for post in feed.data
          if post.id == last_id
            return

          if last_id == -1
            last_id = post.id
            return
          
          last_id = post.id
          msg.send 'Neuer Post auf Minecraft-Server.eu Facebook (' + moment(post.created_time).zone('+01:00').format('DD.MM.YYYY HH:mm:ss') + '):'
          return msg.send '>>' + post.message

    , 600000 # 10 min

#########
  robot.respond /fb latest/i, (msg) ->
      getFeed robot, msg, (err, feed, msg) ->
        if err
          return
        
        for post in feed.data
          msg.send 'Letzter Post (' + moment(post.created_time).zone('+01:00').format('DD.MM.YYYY HH:mm:ss') + '):'
          return msg.send '>>' + post.message

#########
  robot.respond /fb notify disable/i, (msg) ->
    if notifyer
      msg.send "Die automatische Benachrichtung wurde deaktiviert!"
      clearInterval(notifyer)
      notifyer = null
    else
      msg.send "Ist eh deaktiviert. Aktivieren per 'mcseu notify'"

## Custom getFeed
## Check the status of mcseu
getFeed = (robot, msg, callback) ->
  robot.http(api.url + api.key).get() (err, res, body) ->
      if err
        console.log err
        return callback err, null, null

      feed = JSON.parse body

      if feed.error
        console.log feed.error
        return callback feed.error, null, null
      

      callback null, feed, msg