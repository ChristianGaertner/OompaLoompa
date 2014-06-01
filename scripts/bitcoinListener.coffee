# Description:
#   Displays the latest bitcoin price when the word is mentioned.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None

url = 'http://api.bitcoincharts.com/v1/weighted_prices.json'
cached_res = {}
last_cache = new Date(1800000)

module.exports = (robot) ->

  robot.respond /bitcoinprice/i, (msg) ->

    currentTime = new Date()

    if currentTime.getTime() - last_cache.getTime() < 1800000
      return msg.send "Durschnitts-Preis von Bitcoin der letzten 7 Tage: " + cached_res.EUR['7d'] + "€ / $" + cached_res.USD['7d'] + "."
    
            

    robot.http(url)
      .get() (err, res, body) ->
        console.log 'Pulled from server.'
        if err
            console.log err
            msg.send "Konnte den aktuellen Kurs nicht laden. Es tut mir leid."
            return;
        
        data = JSON.parse(body)
        cached_res = data
        last_cache = new Date()

        msg.send "Durschnitts-Preis von Bitcoin der letzten 7 Tage: " + data.EUR['7d'] + "€ / $" + data.USD['7d'] + "."