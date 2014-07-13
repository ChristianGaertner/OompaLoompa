# Description:
#   Easter Eggs ;)
#
# Dependencies:
#   None
#
# Configuration:
#   None
#

module.exports = (robot) ->

  robot.hear /oompa sucks/i, (msg) ->
    msg.reply "https://foaas.herokuapp.com/off/#{msg.message.user.name}/OompaLoompa"

  robot.hear /flirtet mit OompaLoompa/i, (msg) ->
  	name = msg.message.user.name
    unless name.indexOf('watchdog') > -1
  		msg.reply "Ich hab schon eine Freundin... Tut mir Leid."
  	else
  		msg.reply "Ich habe keinen Hunde Fetish."
  		robot.adapter.command 'PRIVMSG', room, "\u0001ACTION wirft trotzdem mal einen Stock...\u0001"
  		msg.reply "Komm hol es dir!"