# Description:
#   Site Downtime notifier
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot mcseu notify - DEPRECATED
#   hubot mcseu - Display if the minecraft-server.eu is down
#   hubot craftlist - Display if craftlsit.de is down
#   hubot specialcraft - Display if the specialcraft.eu is down

api = {
    url: process.env.UPTIME_ROBOT_ENDPOINT,
    keys: {
      mcseu: process.env.UPTIME_ROBOT_API_KEY_MCSEU,
      craftlist: process.env.UPTIME_ROBOT_API_KEY_CL,
      specialcraft: process.env.UPTIME_ROBOT_API_KEY_SC
    }
}
module.exports = (robot) ->

  robot.respond /mcseu notify$/i, (msg) ->
    msg.send 'Es ist von nun an nicht mehr von Nöten die Benachrichtung zu aktivieren. Dies passiert automatisch!'

#########
  robot.respond /mcseu$/i, (msg) ->
    return msg.send "Monitor ist und bleibt erstmal offline!"

#########
  robot.respond /fck_chabbster_mcseu$/i, (msg) ->
    displayUptime api.keys.mcseu, robot, msg, 'vor 30 Tagen'

#########
  robot.respond /craftlist$/i, (msg) ->
    displayUptime api.keys.craftlist, robot, msg, 'vor 30 Tagen'

#########
  robot.respond /specialcraft$/i, (msg) ->
    displayUptime api.keys.specialcraft, robot, msg, 'vor 30 Tagen'


## Custom displayUptime
## Just the main method which get called every time!
displayUptime = (key, robot, msg, since) ->
  doCheck key, robot, msg, (err, monitor, msg) ->
      msg.send 'Der Status konnte nicht abgefragt werden.' if err
      calcResponseTime monitor, msg, (err, monitor, msg) ->
        msg.send monitor.friendlyname + ' (' + monitor.url + ') ' + monitor.status_text
        msg.send 'Die Uptime beträgt zur Zeit ' + monitor.alltimeuptimeratio + '% (Rechnung gestartet ' + since + ').'
        msg.send 'Die durchschnittliche Antwort-Zeit beträgt ' + ((Math.floor monitor.responsetimeAvr) / 1000)  + ' Sekunden.'

## Custom doCheck
## Check the status of any monitor
doCheck = (key, robot, msg, callback) ->
  robot.http(api.url + key).get() (err, res, body) ->
      if err
        console.log err
        return callback err, null, null

      status = JSON.parse body


      if status.stat == 'fail'
          console.log status.err
          return callback err, null, null

      try
        monitor = status.monitors.monitor[0]
      catch e
        console.log e
        monitor = {
          status: -1
          friendlyname: 'ERROR',
          url: 'ERROR'
        }


      if monitor.status == -1
          return callback err, null, null


      monitor.status_text = switch monitor.status
          when '0' then ' macht zur Zeit etwas; das Tracking ist aber aus technischen Gründen deaktiviert.'
          when '1' then ' wurde noch nicht getestet.'
          when '2' then ' ist erreichbar.'
          when '8' then ' scheint zur Zeit nicht erreichbar.'
          when '9' then ' ist nicht erreichbar.'
          else '... Komischer Status... Ich habe keine Ahnung was gerade los ist'

      callback null, monitor, msg

## Custom calcResponseTime
## Calculates an average response time
calcResponseTime = (monitor, msg, callback) ->
  i = 1
  total = 0;
  while i < monitor.responsetime.length
    total += parseInt monitor.responsetime[i].value
    i++

  monitor.responsetimeAvr = total / monitor.responsetime.length
  callback null, monitor, msg
