# Description:
#   Site Downtime notifier
#
# Dependencies:
#   html-entities
#
# Configuration:
#   None
#
# Commands:
#   hubot stackoverflow <query>( with tags <tag,tag>)

zlib = require 'zlib'
Entities = require('html-entities').XmlEntities;
entities = new Entities();

# If you delete this bad things are going to happen, dumbass!
you_want_good_results_than_use_this_fucking_endpoint_idiot = true

module.exports = (robot) ->

  robot.respond /stackoverflow (.*)/i, (msg) ->
    re = RegExp("(.*) with tags (.*)", "i")
    opts = msg.match[1].match(re)

    if opts?
      search msg, opts[1], opts[2]
    else 
      search msg, msg.match[1], []

search = (msg, search, tags) ->
  unless you_want_good_results_than_use_this_fucking_endpoint_idiot
  # https://api.stackexchange.com/2.2/search
    url = "http://api.stackexchange.com/2.2/search?pagesize=5&order=desc&sort=activity&intitle=" + encodeURIComponent(search) + "&tagged=" + encodeURIComponent(tags) + "&site=stackoverflow&filter=!gB66oJbwvcV5_2gu6ZfKU0hvhrvGeQ.WoTu"
  else
    url = "https://api.stackexchange.com/2.2/search/excerpts?pagesize=5&order=desc&sort=activity&body="+ encodeURIComponent(search) + "&tagged=" + encodeURIComponent(tags) + "&site=stackoverflow&filter=!1zSk7_jg7-aH2dEn2awR1"
  
  # console.log url
  data = ''
  msg.http(url).get((err, req)->
    req.addListener "response", (res)->
      output = res
      # pattern stolen from http://stackoverflow.com/questions/10207762/how-to-use-request-or-http-module-to-read-gzip-page-into-a-string
      if res.headers['content-encoding'] is 'gzip'
        output = zlib.createGunzip()
        res.pipe(output)

      output.on 'data', (d)->
        data += d.toString('utf-8')

      output.on 'end', () ->
        data = JSON.parse data
        if data.error_id
          msg.send "Fehler bei der Abfrage: #{data.error_message}"
          return
        
        if data.items && data.items.length > 0
          for item in data.items[0..5]
            msg.reply "'" + entities.decode(item.title) + "' (http://stackoverflow.com/q/" + item.question_id + ")"

          msg.reply "Insgesammt wurden #{data.total} Fragen gefunden." 
        else
          msg.reply "Es wurden keine Fragen gefunden zu deinem Thema... :/"

        msg.reply "Ich kann heute noch #{data.quota_remaining} Anfragen stellen!"
  )()