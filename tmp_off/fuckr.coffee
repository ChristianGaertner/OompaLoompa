# Description:
#   Misc stuff
#
# Dependencies:
#   jsdom
#
# Configuration:
#   None
#
# Commands:
#   4fuckr (me)

jsdom = require 'jsdom'

endpoint = () ->
  # 250 and 5000000
  max = 7000000
  min = 250
  return 'http://4fuckr.com/image_' + Math.floor(Math.random() * (max - min + 1) + min) + '.htm'



module.exports = (robot) ->

  robot.respond /4fuckr( me)?/i, (msg) ->
    process (err, img, url) ->
      if err
        console.log err
        return msg.send ":( Fehler ist aufgetreten"
      
      msg.send img.src + " (Full site #{url})"

      
      

process = (fn) ->
  url = endpoint()
  jsdom.env url, [], (errors, window) ->
    if errors
      return fn(errors)
    
    console.log '4fuckr: Loaded image now testing!'
    img = window.document.getElementById("mypic")
    if img
      console.log '4fuckr: Found image!'
      fn(null, img, url)
    else
      process(fn)