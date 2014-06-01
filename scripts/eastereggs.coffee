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
