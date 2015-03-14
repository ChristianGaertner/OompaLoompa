# Description:
#   Misc stuff
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   test - Echos "Bestanden"
#   alarm - Displays a alarm relaeted quote
#   kot - Displays a image of shit (From Google)
#   wat(?) - Displays a WAT? image (From Google)
#   65( )wat(?)
#   niggawat(t)(s)(?)
#   popcorn - Displays a image of popcorn (From Google)
#   PARTY - slaps this person (wbkkramer only;))

urls =

  alarm: [
    'https://www.youtube.com/watch?v=TqDsMEOYA9g',
    'http://blogs.worldbank.org/files/publicsphere/alarm.jpg',
    'http://www.clker.com/cliparts/1/Z/i/2/V/v/orange-light-alarm-hi.png',
    'http://tmcc.charite.de/fileadmin/user_upload/microsites/forschungszentren/tmcc/ALARM/alarm_logo_600dpi.png',
    'http://gadgets.boingboing.net/gimages/darth_vader_led_alarm_clock.jpg'
  ],
  wat: [
    'http://i2.kym-cdn.com/photos/images/original/000/173/576/Wat8.jpg',
    'https://d24w6bsrhbeh9d.cloudfront.net/photo/aBKergD_460sa.gif'
  ],
  sixtyfivewat: 'http://pix.echtlustig.com/1308/65-wat.jpg',
  watgun: 'http://img.pr0gramm.com/2014/08/21/6e9e66df520ba625.gif'

module.exports = (robot) ->

  robot.hear /^test$/i, (msg) ->
    msg.send "Bestanden"

  robot.hear /^alarm$/i, (msg) ->
    msg.send msg.random urls.alarm

  robot.hear /^wat\??$/i, (msg) ->
    msg.send msg.random urls.wat

  robot.hear /^65 ?wat\??$/i, (msg) ->
    msg.send urls.sixtyfivewat

  robot.hear /^watgun$/i, (msg) ->
    msg.send urls.watgun

  robot.hear /^nigg(a|er)watt?s?\??$/i, (msg) ->
    google msg, 'niggawatt', (url) ->
      msg.send url

  robot.hear /^!away$/i, (msg) ->
    msg.send "http://sackheads.org/~bnaylor/spew/away_msgs.html"

  robot.hear /^kot$/i, (msg) ->
    google msg, 'kot haufen', (url) ->
      msg.send url

  robot.hear /^pop(c|k)orn!?$/i, (msg) ->
    google msg, 'popcorn', (url) ->
      msg.send url

  robot.hear /^PARTY$/i, (msg) ->
    name = msg.message.user.name
    unless name.indexOf('wbk') > -1 || name.indexOf('kramer') > -1
      google msg, 'partyhard', (url) ->
        msg.send url
      
      return

    room = msg.message.room
    robot.adapter.command 'PRIVMSG', room, "\u0001ACTION slaps #{msg.message.user.name}\u0001"

  robot.hear /^dafuq$/i, (msg) ->
    google msg, 'dafuq', (url) ->
      msg.send url


google = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  q = v: '1.0', rsz: '8', q: query, safe: 'active'
  q.imgtype = 'animated' if typeof animated is 'boolean' and animated is true
  q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image  = msg.random images
        cb "#{image.unescapedUrl}#.png"