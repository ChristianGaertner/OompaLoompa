# Description:
#   Minecraft-Server.eu spezifischer Listener
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot Matthias - Display a Matthias specific text
#   hubot IchHalt - Display a IchHalt specific text
#   Der Chat ist auch tot - Displays a funny quote

messages =

	chatTot: [
		"Tztztztz. Nur keine voreiligen Schlüsse ziehen!",
		"Das kommt noch!",
		"Das wollen wir mal sehen!",
		"Abwarten. Das kommt!"
	]

module.exports = (robot) ->

  robot.respond /Matthias/i, (msg) ->
    msg.send msg.random ["Muuuuuuh", "Kuh-Muh", "Z.Z. in der Karibik -> AFK"]

  robot.respond /IchHalt/i, (msg) ->
    msg.send "Der ist Kaffee trinken... oder so ähnlich!?"

  robot.hear /Der Chat ist auch tot/i, (msg) ->
  	msg.send msg.random messages.chatTot

