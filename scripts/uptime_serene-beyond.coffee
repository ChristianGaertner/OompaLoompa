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
#   hubot beta mcseu - Display if the minecraft-server.eu is down

module.exports = (robot) ->

#########
  robot.respond /beta mcseu$/i, (msg) ->
    msg.send "Monitor ist und bleibt erstmal offline!"

#########
  robot.respond /fck_chabbster_beta_mcseu$/i, (msg) ->
    displayUptime robot, msg


## Custom displayUptime
## Just the main method which get called every time!
displayUptime = (robot, msg) ->
  doCheck robot, msg, (err, monitor, msg) ->
      msg.send 'Der Status konnte nicht abgefragt werden.' if err
      
      msg.send 'BETA - Minecraft-Server.eu (http://minecraft-server.eu) ' + monitor.status_text + " (und das schon seit #{monitor.since})."
      # TODO: get calc since from DaPing
      msg.send 'BETA - Die Uptime beträgt zur Zeit ' + Math.floor(monitor.uptime * 100) / 100 + '% (Rechnung gestartet 10.05.2014 18:01:56).'

## Custom doCheck
## Check the status of any monitor
doCheck = (robot, msg, callback) ->
  robot.http(process.env.UPTIME_DAPING_ENDPOINT).get() (err, res, body) ->
      if err
        console.log err
        return callback err, null, null

      data = JSON.parse body


      if data.status == 'failure'
          console.log data.payload
          return callback payload, null, null


      if data.payload.status == -1
          return callback err, null, null


      data.payload.status_text = switch data.payload.status
          when 0 then ' ist nicht erreichbar.'
          when 1 then ' ist erreichbar.'
          when 666 then ' konnte nicht getestest werden. Es gab wohl einen Fehler bei der letzten Abfrage. In kürze nochmal versuchen!'
          else '... Komischer Status... Ich habe keine Ahnung was gerade los ist'

      callback null, data.payload, msg

