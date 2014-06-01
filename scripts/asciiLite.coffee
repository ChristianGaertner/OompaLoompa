# Description:
#   ASCII art limited to 1 per 15 minutes each!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ascii me <text> - Show text in ascii art
#
# Author:
#   atmos & DaGardner

grace_time = 1800000 / 2 #15 min
last_call = new Date(grace_time)

module.exports = (robot) ->
  robot.respond /ascii( me)? (.+)/i, (msg) ->

  	currentTime = new Date()
  	diff = currentTime.getTime() - last_call.getTime()

  	if diff < grace_time
      return msg.send "Das nutzen dieser Funktion wurde auf 1 Art pro 15 Minuten limitiert! Du musst noch " + ((grace_time - diff) / 1000) + " Sekunden warten!"

    msg
      .http("http://asciime.heroku.com/generate_ascii")
      .query(s: msg.match[2])
      .get() (err, res, body) ->
        last_call = new Date()
        msg.send body
