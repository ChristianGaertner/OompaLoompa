export HUBOT_IRC_SERVER=kornbluth.freenode.net
export HUBOT_IRC_ROOMS="#OompaLoompa,#DaPing"
export HUBOT_MAIN_CHANNEL="$HUBOT_IRC_ROOMS"
export HUBOT_IRC_NICK="OompaLoompaTest"
export HUBOT_IRC_DEBUG=true
export HUBOT_LOG_LEVEL="debug"
export PORT=4000
export HUBOT_MAIN_CHANNEL="#OompaLoompa"

export HTTP_DAPING_NOTIFY="/notify"
export HTTP_ROUTE_SHUTDOWN="/shutdown"
export HTTP_UPTIME_DAPING="/daping"
export HTTP_UPTIME_ROBOT="/robot"

echo "RUN REDIS SERVER!!!!!!!!"

./bin/hubot -a irc -n "$HUBOT_IRC_NICK" -l oompa