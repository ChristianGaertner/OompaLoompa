# Description:
#   Tumbleweed Image poster
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None

images = [
  "http://gifs.gifbin.com/052011/1304618376_tumbleweed-gif.gif",
  "http://i1209.photobucket.com/albums/cc395/scout03060/smileys/4827fdff_tumbleweed.gif",
  "http://i444.photobucket.com/albums/qq162/paulwar2/tumbleweed.gif",
  "http://www.awesomelyluvvie.com/wp-content/uploads/2013/05/Tumbleweeds2.gif"
]

module.exports = (robot) ->

  robot.hear /nichts los hier/i, (msg) ->
    msg.send msg.random images

