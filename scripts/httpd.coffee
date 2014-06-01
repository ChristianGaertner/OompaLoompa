# Description:
#   A simple interaction with the built in HTTP Daemon
#
# Dependencies:
#   url
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   /version
#   /ping
#   /time
#   /info
#   /ip
#   /uptime

spawn = require('child_process').spawn
url = require 'url'

###
{
  monitorID: '*monitorID*',
  monitorURL: '*monitorURL*',
  monitorFriendlyName: '*monitorFriendlyName*',
  alertType: '*alertType*',
  alertDetails: '*alertDetails*',
  monitorAlertContacts: '*monitorAlertContacts*'
}
###

module.exports = (robot) ->

  robot.router.get "/version", (req, res) ->
    res.end robot.version

  robot.router.post "/ping", (req, res) ->
    res.end "PONG"

  robot.router.get "/time", (req, res) ->
    res.end "Server time is: #{new Date()}"

  robot.router.get "/info", (req, res) ->
    child = spawn('/bin/sh', ['-c', "echo I\\'m $LOGNAME@$(hostname):$(pwd) \\($(git rev-parse HEAD)\\)"])

    child.stdout.on 'data', (data) ->
      res.end "#{data.toString().trim()} running node #{process.version} [pid: #{process.pid}]"
      child.stdin.end()

  robot.router.get process.env.HTTP_UPTIME_ROBOT, (req, res) ->
    query = url.parse(req.url, true).query
    
    if query.alertType is "1"
      friendlyStatus = 'nicht erreichbar!'
    else if query.alertType is "2"
      friendlyStatus = 'jetzt erreichbar!'
    else
      friendlyStatus = 'vielleicht erreichbar. Der Status ist komisch... :/'
    

    robot.messageRoom process.env.HUBOT_MAIN_CHANNEL, "Der Uptime Status von #{query.monitorFriendlyName} hat sich geändert!", "Diese Seite ist #{friendlyStatus}"

    res.end "Ok. Thanks"

  robot.router.get "/ip", (req, res) ->
    robot.http('http://ifconfig.me/ip').get() (err, r, body) ->
      res.end body

  robot.router.get "/ping_error", (req, res) ->
    query = url.parse(req.url, true).query

    if query.err
      robot.messageRoom '#DaPing', "DaPing errored during ping:", query.err

    res.end "Ok. Thanks"

  robot.router.get process.env.HTTP_UPTIME_DAPING, (req, res) ->
    query = url.parse(req.url, true).query

    if query.status == '1'
      friendlyStatus = 'jetzt erreichbar!'
    else if query.status == '0'
      friendlyStatus = 'nicht erreichbar!'
    else
      friendlyStatus = 'vielleicht erreichbar. Der Status ist komisch... :/'

    if query.status
      robot.messageRoom '#OompaLoompa', "BETA - Der Uptime Status von Minecraft-Server.eu hat sich geändert!", "BETA - Diese Seite ist #{friendlyStatus}"

    res.end "Ok. Thanks (Status was #{query.status})"
  
  robot.router.get process.env.HTTP_DAPING_NOTIFY, (req, res) ->
    query = url.parse(req.url, true).query

    if query.err
      robot.messageRoom '#DaPing', "DaPing uptime calc notification:", query.err

    res.end "Ok. Thanks"

  robot.router.get process.env.HTTP_ROUTE_SHUTDOWN, (req, res) ->
     process.exit 1